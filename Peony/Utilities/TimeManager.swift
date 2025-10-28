//
//  TimeManager.swift
//  Peony
//
//  Centralized time and season management system
//

import Foundation
import Observation

/// Hemisphere configuration for seasonal calculations
enum Hemisphere: String, CaseIterable {
    case northern = "Northern"
    case southern = "Southern"
}

/// Season of the year
enum Season: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    
    /// User-facing display name
    var displayName: String { rawValue }
    
    /// Emoji representation
    var emoji: String {
        switch self {
        case .spring: return "🌸"
        case .summer: return "☀️"
        case .fall: return "🍂"
        case .winter: return "❄️"
        }
    }
}

/// Time of day period
enum TimeOfDay: String, CaseIterable {
    case preDawn = "Pre-Dawn"
    case dawn = "Dawn"
    case morning = "Morning"
    case afternoon = "Afternoon"
    case dusk = "Dusk"
    case night = "Night"
    
    /// User-facing display name
    var displayName: String { rawValue }
}

/// Observable time manager that tracks real device time and calculates seasons/time periods
@Observable
class TimeManager {
    /// Shared singleton instance
    static let shared = TimeManager()
    
    // MARK: - Published Properties
    
    /// Current date and time
    private(set) var currentDate: Date = Date()
    
    /// Current hour (0-23)
    private(set) var currentHour: Int = 0
    
    /// Current minute (0-59)
    private(set) var currentMinute: Int = 0
    
    /// Current month (1-12)
    private(set) var currentMonth: Int = 0
    
    /// Hemisphere setting (affects seasonal calculations)
    var hemisphere: Hemisphere = .northern {
        didSet {
            updateTimeState()
        }
    }
    
    /// Default latitude for solar calculations (40°N - mid-US)
    /// TODO: Make this user-configurable with location services
    var latitude: Double = 40.0
    
    /// Default longitude for solar calculations (95°W - mid-US)
    var longitude: Double = -95.0
    
    // MARK: - Private Properties
    
    private var updateTimer: Timer?
    private let calendar = Calendar.current
    private var cachedSunrise: Date?
    private var cachedSunset: Date?
    private var lastCalculationDate: Date?
    
    // MARK: - Initialization
    
    private init() {
        updateTimeState()
        startTimer()
    }
    
    deinit {
        updateTimer?.invalidate()
    }
    
    // MARK: - Public Computed Properties
    
    /// Current season based on month and hemisphere
    var currentSeason: Season {
        let month = currentMonth
        
        switch hemisphere {
        case .northern:
            switch month {
            case 3, 4, 5: return .spring
            case 6, 7, 8: return .summer
            case 9, 10, 11: return .fall
            default: return .winter // 12, 1, 2
            }
        case .southern:
            // Southern hemisphere seasons are opposite
            switch month {
            case 3, 4, 5: return .fall
            case 6, 7, 8: return .winter
            case 9, 10, 11: return .spring
            default: return .summer // 12, 1, 2
            }
        }
    }
    
    /// Current time of day period (based on actual sunrise/sunset)
    var timeOfDay: TimeOfDay {
        let sunrise = sunriseTime
        let sunset = sunsetTime
        
        // Get sunrise/sunset in minutes since midnight
        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        
        let currentMinutes = currentHour * 60 + currentMinute
        
        // Calculate twilight windows (45 minutes before/after sunrise/sunset)
        let preDawnStart = sunriseMinutes - 90  // 1.5 hours before sunrise
        let dawnStart = sunriseMinutes - 45     // 45 min before sunrise
        let dawnEnd = sunriseMinutes + 60       // 1 hour after sunrise
        let duskStart = sunsetMinutes - 60      // 1 hour before sunset
        let duskEnd = sunsetMinutes + 45        // 45 min after sunset
        
        // Determine time period
        if currentMinutes >= preDawnStart && currentMinutes < dawnStart {
            return .preDawn
        } else if currentMinutes >= dawnStart && currentMinutes < dawnEnd {
            return .dawn
        } else if currentMinutes >= dawnEnd && currentMinutes < 720 { // Until noon
            return .morning
        } else if currentMinutes >= 720 && currentMinutes < duskStart {
            return .afternoon
        } else if currentMinutes >= duskStart && currentMinutes < duskEnd {
            return .dusk
        } else {
            return .night
        }
    }
    
    /// Whether it's currently daytime (based on actual sunrise/sunset)
    var isDaytime: Bool {
        let sunrise = sunriseTime
        let sunset = sunsetTime
        
        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        let currentMinutes = currentHour * 60 + currentMinute
        
        return currentMinutes >= sunriseMinutes && currentMinutes < sunsetMinutes
    }
    
    /// Whether it's currently nighttime (based on actual sunrise/sunset)
    var isNighttime: Bool {
        !isDaytime
    }
    
    /// Progress through the day (0.0 = midnight, 0.5 = noon, 1.0 = midnight)
    var dayProgress: Double {
        let totalMinutes = currentHour * 60 + currentMinute
        return Double(totalMinutes) / 1440.0 // 1440 minutes in a day
    }
    
    /// Sun position progress (0.0 = sunrise, 0.5 = zenith, 1.0 = sunset)
    /// Returns nil if sun is not visible
    var sunProgress: Double? {
        let sunrise = sunriseTime
        let sunset = sunsetTime
        
        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        let currentMinutes = currentHour * 60 + currentMinute
        
        // Sun visible from sunrise to sunset
        guard currentMinutes >= sunriseMinutes && currentMinutes <= sunsetMinutes else { return nil }
        
        let minutesSinceSunrise = currentMinutes - sunriseMinutes
        let totalDaylightMinutes = sunsetMinutes - sunriseMinutes
        return Double(minutesSinceSunrise) / Double(totalDaylightMinutes)
    }
    
    /// Moon position progress (0.0 = moonrise, 0.5 = zenith, 1.0 = moonset)
    /// Returns nil if moon is not visible
    var moonProgress: Double? {
        let sunrise = sunriseTime
        let sunset = sunsetTime
        
        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        let currentMinutes = currentHour * 60 + currentMinute
        
        // Moon visible from sunset to sunrise (next day)
        if currentMinutes >= sunsetMinutes {
            // Evening (sunset - midnight)
            let minutesSinceMoonrise = currentMinutes - sunsetMinutes
            let minutesToMidnight = 1440 - sunsetMinutes // Minutes from sunset to midnight
            let totalNightMinutes = minutesToMidnight + sunriseMinutes // To sunrise next day
            return Double(minutesSinceMoonrise) / Double(totalNightMinutes)
        } else if currentMinutes < sunriseMinutes {
            // Early morning (midnight - sunrise)
            let minutesSinceMidnight = currentMinutes
            let minutesToMidnight = 1440 - sunsetMinutes
            let totalNightMinutes = minutesToMidnight + sunriseMinutes
            return (Double(minutesToMidnight) + Double(minutesSinceMidnight)) / Double(totalNightMinutes)
        } else {
            return nil
        }
    }
    
    /// Twilight opacity (0.0 = full day/night, 1.0 = peak twilight)
    /// Used for crossfading sun and moon
    var twilightOpacity: Double {
        switch timeOfDay {
        case .dawn:
            // Fade in from 5:30 to 7:00 (90 minutes)
            let minutesSinceDawnStart = (currentHour * 60 + currentMinute) - 330
            return min(1.0, Double(minutesSinceDawnStart) / 90.0)
        case .dusk:
            // Fade out from 5:00 to 7:00 (120 minutes)
            let minutesSinceDuskStart = (currentHour * 60 + currentMinute) - 1020
            return max(0.0, 1.0 - (Double(minutesSinceDuskStart) / 120.0))
        default:
            return 0.0
        }
    }
    
    /// Whether both sun and moon should be visible (twilight hours)
    var isTwilight: Bool {
        timeOfDay == .dawn || timeOfDay == .dusk
    }
    
    // MARK: - Solar Calculations
    
    /// Calculate sunrise time for current date and location
    var sunriseTime: Date {
        if let cached = cachedSunrise,
           let lastCalc = lastCalculationDate,
           calendar.isDate(lastCalc, inSameDayAs: currentDate) {
            return cached
        }
        
        let sunrise = calculateSunrise(for: currentDate, latitude: latitude, longitude: longitude)
        cachedSunrise = sunrise
        lastCalculationDate = currentDate
        return sunrise
    }
    
    /// Calculate sunset time for current date and location
    var sunsetTime: Date {
        if let cached = cachedSunset,
           let lastCalc = lastCalculationDate,
           calendar.isDate(lastCalc, inSameDayAs: currentDate) {
            return cached
        }
        
        let sunset = calculateSunset(for: currentDate, latitude: latitude, longitude: longitude)
        cachedSunset = sunset
        return sunset
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        updateTimer = Timer.scheduledTimer(
            withTimeInterval: 60, // Update every minute
            repeats: true
        ) { [weak self] _ in
            self?.updateTimeState()
        }
        
        // Ensure timer runs in all run loop modes
        if let timer = updateTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func updateTimeState() {
        currentDate = Date()
        currentHour = calendar.component(.hour, from: currentDate)
        currentMinute = calendar.component(.minute, from: currentDate)
        currentMonth = calendar.component(.month, from: currentDate)
    }
    
    /// Calculate sunrise using solar noon approximation
    private func calculateSunrise(for date: Date, latitude: Double, longitude: Double) -> Date {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        // Solar declination angle (simplified)
        let declination = 23.45 * sin((360.0 / 365.0) * Double(dayOfYear - 81) * .pi / 180.0)
        
        // Hour angle for sunrise
        let latRad = latitude * .pi / 180.0
        let decRad = declination * .pi / 180.0
        let cosHourAngle = -tan(latRad) * tan(decRad)
        
        // Handle polar day/night
        let hourAngle: Double
        if cosHourAngle > 1 {
            hourAngle = 0 // Polar night
        } else if cosHourAngle < -1 {
            hourAngle = 180 // Polar day
        } else {
            hourAngle = acos(cosHourAngle) * 180.0 / .pi
        }
        
        // Calculate solar noon (approximate)
        let solarNoon = 12.0 - (longitude / 15.0)
        
        // Sunrise time in decimal hours
        let sunriseHour = solarNoon - (hourAngle / 15.0)
        
        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(sunriseHour)
        components.minute = Int((sunriseHour - Double(Int(sunriseHour))) * 60)
        
        return calendar.date(from: components) ?? date
    }
    
    /// Calculate sunset using solar noon approximation
    private func calculateSunset(for date: Date, latitude: Double, longitude: Double) -> Date {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        
        // Solar declination angle (simplified)
        let declination = 23.45 * sin((360.0 / 365.0) * Double(dayOfYear - 81) * .pi / 180.0)
        
        // Hour angle for sunset
        let latRad = latitude * .pi / 180.0
        let decRad = declination * .pi / 180.0
        let cosHourAngle = -tan(latRad) * tan(decRad)
        
        // Handle polar day/night
        let hourAngle: Double
        if cosHourAngle > 1 {
            hourAngle = 0 // Polar night
        } else if cosHourAngle < -1 {
            hourAngle = 180 // Polar day
        } else {
            hourAngle = acos(cosHourAngle) * 180.0 / .pi
        }
        
        // Calculate solar noon (approximate)
        let solarNoon = 12.0 - (longitude / 15.0)
        
        // Sunset time in decimal hours
        let sunsetHour = solarNoon + (hourAngle / 15.0)
        
        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(sunsetHour)
        components.minute = Int((sunsetHour - Double(Int(sunsetHour))) * 60)
        
        return calendar.date(from: components) ?? date
    }
    
    // MARK: - Public Methods
    
    /// Force an immediate time update (useful for testing)
    func forceUpdate() {
        updateTimeState()
    }
}

