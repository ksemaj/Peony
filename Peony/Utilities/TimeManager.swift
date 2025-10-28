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

/// Time of day period - 3 day stages + 3 night stages
enum TimeOfDay: String, CaseIterable {
    // Day stages (sun visible)
    case sunrise = "Sunrise"
    case day = "Day"
    case afternoon = "Afternoon"

    // Night stages (moon visible)
    case sunset = "Sunset"
    case evening = "Evening"
    case midnight = "Midnight"

    /// User-facing display name
    var displayName: String { rawValue }
}

/// Observable time manager that tracks real device time and calculates seasons/time periods
@Observable
class TimeManager {
    /// Shared singleton instance
    static let shared = TimeManager()

    // MARK: - Debug Mode

    /// Debug mode - allows overriding time for testing
    var isDebugMode: Bool = false

    /// Debug time override (only used when isDebugMode = true)
    var debugTimeOfDay: TimeOfDay = .afternoon {
        didSet {
            if isDebugMode {
                updateDebugTime()
            }
        }
    }

    // MARK: - Published Properties

    /// Current date and time
    private(set) var currentDate: Date = Date()

    /// Current hour (0-23)
    private(set) var currentHour: Int = Calendar.current.component(.hour, from: Date())

    /// Current minute (0-59)
    private(set) var currentMinute: Int = Calendar.current.component(.minute, from: Date())

    /// Current month (1-12)
    private(set) var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    /// Hemisphere setting (affects seasonal calculations)
    var hemisphere: Hemisphere = .northern {
        didSet {
            updateTimeState()
        }
    }
    
    /// Get user's latitude from LocationManager
    var latitude: Double {
        LocationManager.shared.latitude
    }

    /// Get user's longitude from LocationManager
    var longitude: Double {
        LocationManager.shared.longitude
    }
    
    // MARK: - Private Properties
    
    private var updateTimer: Timer?
    private let calendar = Calendar.current
    private var cachedSunrise: Date?
    private var cachedSunset: Date?
    private var cachedMoonrise: Date?
    private var cachedMoonset: Date?
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
    
    /// Current time of day period (based on actual sunrise/sunset, or debug override)
    var timeOfDay: TimeOfDay {
        // In debug mode, directly use the selected debug time of day
        if isDebugMode {
            return debugTimeOfDay
        }

        // Normal mode: use actual sunrise/sunset calculations
        let sunrise = sunriseTime
        let sunset = sunsetTime

        // Get sunrise/sunset in minutes since midnight
        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)

        let currentMinutes = currentHour * 60 + currentMinute

        // Calculate solar noon (midpoint between sunrise and sunset)
        let solarNoon = (sunriseMinutes + sunsetMinutes) / 2

        // Calculate night midpoint (midnight = 0:00 / 1440 minutes)
        // Handle night wrapping around midnight
        let _ = 0  // Actual midnight (12 AM) - reserved for future use

        // Calculate transition windows
        let sunriseStart = sunriseMinutes - 90  // 1.5 hours before sunrise
        let sunriseEnd = sunriseMinutes + 60    // 1 hour after sunrise
        let sunsetStart = sunsetMinutes - 60    // 1 hour before sunset
        let sunsetEnd = sunsetMinutes + 45      // 45 min after sunset

        // Determine time period based on solar calculations
        if currentMinutes >= sunriseStart && currentMinutes < sunriseEnd {
            return .sunrise  // Sunrise period (around sunrise)
        } else if currentMinutes >= sunriseEnd && currentMinutes < solarNoon {
            return .day  // Morning until solar noon
        } else if currentMinutes >= solarNoon && currentMinutes < sunsetStart {
            return .afternoon  // Solar noon until sunset begins
        } else if currentMinutes >= sunsetStart && currentMinutes < sunsetEnd {
            return .sunset  // Sunset period (around sunset)
        } else if currentMinutes >= sunsetEnd {
            return .evening  // After sunset until midnight
        } else {
            return .midnight  // After midnight until sunrise
        }
    }
    
    /// Whether it's currently daytime (based on actual sunrise/sunset or debug mode)
    var isDaytime: Bool {
        // In debug mode, determine based on debug time of day
        if isDebugMode {
            switch debugTimeOfDay {
            case .sunrise, .day, .afternoon, .sunset:
                return true  // Sun visible during all these stages
            case .evening, .midnight:
                return false  // Moon visible during these stages
            }
        }

        // Normal mode: use actual sunrise/sunset
        let sunrise = sunriseTime
        let sunset = sunsetTime

        let sunriseMinutes = calendar.component(.hour, from: sunrise) * 60 + calendar.component(.minute, from: sunrise)
        let sunsetMinutes = calendar.component(.hour, from: sunset) * 60 + calendar.component(.minute, from: sunset)
        let currentMinutes = currentHour * 60 + currentMinute

        return currentMinutes >= sunriseMinutes && currentMinutes < sunsetMinutes
    }

    /// Whether it's currently nighttime (based on actual sunrise/sunset or debug mode)
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
        // In debug mode, calculate based on debug time of day
        if isDebugMode {
            switch debugTimeOfDay {
            case .sunrise:
                return 0.0   // Sun on left horizon (rising)
            case .day:
                return 0.33  // Sun mid-morning
            case .afternoon:
                return 0.5   // Sun at zenith (top/center)
            case .sunset:
                return 1.0   // Sun on right horizon (setting)
            case .evening, .midnight:
                return nil   // Sun not visible at night
            }
        }

        // Normal mode: use actual time calculations
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
        // In debug mode, calculate based on debug time of day
        if isDebugMode {
            switch debugTimeOfDay {
            case .evening:
                return 0.3  // Moon rising, moving toward zenith
            case .midnight:
                return 0.5  // Moon at zenith (topmost center - DARKEST)
            case .sunrise, .day, .afternoon, .sunset:
                return nil  // Moon not visible during day stages
            }
        }

        // Normal mode: use simplified moonrise/moonset (sunset to sunrise)
        let moonrise = moonriseTime
        let moonset = moonsetTime

        let moonriseMinutes = calendar.component(.hour, from: moonrise) * 60 + calendar.component(.minute, from: moonrise)
        let moonsetMinutes = calendar.component(.hour, from: moonset) * 60 + calendar.component(.minute, from: moonset)
        let currentMinutes = currentHour * 60 + currentMinute

        // Moon visible from sunset to sunrise (moonset is next day)
        // Since moonset = sunrise (next day), moonset will always be less than moonrise
        if currentMinutes >= moonriseMinutes {
            // After moonrise (sunset), before midnight
            let minutesSinceMoonrise = currentMinutes - moonriseMinutes
            let minutesToMidnight = 1440 - moonriseMinutes
            let totalMoonlightMinutes = minutesToMidnight + moonsetMinutes
            return Double(minutesSinceMoonrise) / Double(totalMoonlightMinutes)
        } else if currentMinutes < moonsetMinutes {
            // After midnight, before moonset (sunrise)
            let minutesSinceMidnight = currentMinutes
            let minutesToMidnight = 1440 - moonriseMinutes
            let totalMoonlightMinutes = minutesToMidnight + moonsetMinutes
            return (Double(minutesToMidnight) + Double(minutesSinceMidnight)) / Double(totalMoonlightMinutes)
        } else {
            return nil // Moon not visible (daytime)
        }
    }
    
    /// Twilight opacity (0.0 = full day/night, 1.0 = peak twilight)
    /// Used for crossfading sun and moon
    var twilightOpacity: Double {
        switch timeOfDay {
        case .sunrise:
            // Fade in from 6:00 to 7:30 (90 minutes)
            let minutesSinceSunriseStart = (currentHour * 60 + currentMinute) - 360
            return min(1.0, Double(minutesSinceSunriseStart) / 90.0)
        case .sunset:
            // Fade out from 6:00 to 7:30 (90 minutes)
            let minutesSinceSunsetStart = (currentHour * 60 + currentMinute) - 1080
            return max(0.0, 1.0 - (Double(minutesSinceSunsetStart) / 90.0))
        default:
            return 0.0
        }
    }

    /// Whether both sun and moon should be visible (twilight hours)
    var isTwilight: Bool {
        // Only sunrise is twilight (moon fading, sun appearing)
        // Sunset shows only sun (no moon yet)
        timeOfDay == .sunrise
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

    /// Moonrise time - simplified to always show moon at night
    var moonriseTime: Date {
        // Moon rises when sun sets
        return sunsetTime
    }

    /// Moonset time - simplified to always show moon at night
    var moonsetTime: Date {
        // Moon sets when sun rises
        return sunriseTime
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
        Task { @MainActor in
            // Skip updates if in debug mode
            guard !isDebugMode else { return }

            currentDate = Date()
            currentHour = calendar.component(.hour, from: currentDate)
            currentMinute = calendar.component(.minute, from: currentDate)
            currentMonth = calendar.component(.month, from: currentDate)
        }
    }

    /// Update to debug time (for testing different times of day)
    func updateDebugTime() {
        Task { @MainActor in
            currentMonth = 10 // October for current season

            // Set time based on debug TimeOfDay - 3 day + 3 night stages
            switch debugTimeOfDay {
            case .sunrise:
                currentHour = 6
                currentMinute = 30
            case .day:
                currentHour = 10
                currentMinute = 0
            case .afternoon:
                currentHour = 14
                currentMinute = 0
            case .sunset:
                currentHour = 18
                currentMinute = 30
            case .evening:
                currentHour = 20
                currentMinute = 30
            case .midnight:
                currentHour = 23
                currentMinute = 30
            }
        }
    }

    /// Toggle to next time of day (for debug cycling)
    func cycleDebugTime() {
        guard isDebugMode else { return }

        let allTimes = TimeOfDay.allCases
        if let currentIndex = allTimes.firstIndex(of: debugTimeOfDay) {
            let nextIndex = (currentIndex + 1) % allTimes.count
            debugTimeOfDay = allTimes[nextIndex]
        }
    }
    
    /// Calculate sunrise using solar noon approximation with timezone correction
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

        // Calculate solar noon in UTC
        // Longitude correction: 15° = 1 hour; east is positive time shift
        let longitudeTimeOffset = -longitude / 15.0

        // Get timezone offset in hours from UTC
        let timezone = TimeZone.current
        let timezoneOffset = Double(timezone.secondsFromGMT(for: date)) / 3600.0

        // Solar noon in local time = 12:00 (UTC solar noon) + timezone offset
        let solarNoonLocal = 12.0 + timezoneOffset + longitudeTimeOffset

        // Sunrise time in decimal hours (local time)
        var sunriseHour = solarNoonLocal - (hourAngle / 15.0)

        // Normalize to 0-24 range
        while sunriseHour < 0 { sunriseHour += 24 }
        while sunriseHour >= 24 { sunriseHour -= 24 }

        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(sunriseHour)
        components.minute = Int((sunriseHour - Double(Int(sunriseHour))) * 60)

        return calendar.date(from: components) ?? date
    }
    
    /// Calculate sunset using solar noon approximation with timezone correction
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

        // Calculate solar noon in UTC
        // Longitude correction: 15° = 1 hour; east is positive time shift
        let longitudeTimeOffset = -longitude / 15.0

        // Get timezone offset in hours from UTC
        let timezone = TimeZone.current
        let timezoneOffset = Double(timezone.secondsFromGMT(for: date)) / 3600.0

        // Solar noon in local time = 12:00 (UTC solar noon) + timezone offset
        let solarNoonLocal = 12.0 + timezoneOffset + longitudeTimeOffset

        // Sunset time in decimal hours (local time)
        var sunsetHour = solarNoonLocal + (hourAngle / 15.0)

        // Normalize to 0-24 range
        while sunsetHour < 0 { sunsetHour += 24 }
        while sunsetHour >= 24 { sunsetHour -= 24 }

        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(sunsetHour)
        components.minute = Int((sunsetHour - Double(Int(sunsetHour))) * 60)

        return calendar.date(from: components) ?? date
    }

    // MARK: - Lunar Calculations

    /// Calculate Julian Date from given date
    private func calculateJulianDate(for date: Date) -> Double {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        var y = Double(year)
        var m = Double(month)

        if m <= 2 {
            y -= 1
            m += 12
        }

        let a = floor(y / 100.0)
        let b = 2.0 - a + floor(a / 4.0)

        let jd = floor(365.25 * (y + 4716.0)) + floor(30.6001 * (m + 1.0)) + Double(day) + b - 1524.5
        let timeOfDay = (Double(hour) + Double(minute) / 60.0) / 24.0

        return jd + timeOfDay
    }

    /// Calculate moon's ecliptic longitude and latitude
    private func calculateLunarPosition(julianDate: Double) -> (longitude: Double, latitude: Double, distance: Double) {
        // Days since J2000.0
        let d = julianDate - 2451545.0

        // Lunar orbital elements
        let l = (218.316 + 13.176396 * d).truncatingRemainder(dividingBy: 360.0) // Mean longitude
        let m = (134.963 + 13.064993 * d).truncatingRemainder(dividingBy: 360.0) // Mean anomaly
        let f = (93.272 + 13.229350 * d).truncatingRemainder(dividingBy: 360.0)  // Argument of latitude

        // Convert to radians
        let mRad = m * .pi / 180.0
        let fRad = f * .pi / 180.0

        // Calculate ecliptic longitude (simplified)
        let longitude = l + 6.289 * sin(mRad)

        // Calculate ecliptic latitude (simplified)
        let latitude = 5.128 * sin(fRad)

        // Calculate distance (not critical for rise/set)
        let distance = 385001.0 - 20905.0 * cos(mRad)

        return (longitude, latitude, distance)
    }

    /// Calculate lunar declination and right ascension
    private func calculateLunarCoordinates(longitude: Double, latitude: Double) -> (declination: Double, rightAscension: Double) {
        // Convert to radians
        let lonRad = longitude * .pi / 180.0
        let latRad = latitude * .pi / 180.0

        // Obliquity of ecliptic (Earth's axial tilt)
        let epsilon = 23.439 * .pi / 180.0

        // Calculate right ascension
        let y = sin(lonRad) * cos(epsilon) - tan(latRad) * sin(epsilon)
        let x = cos(lonRad)
        var rightAscension = atan2(y, x) * 180.0 / .pi

        if rightAscension < 0 {
            rightAscension += 360.0
        }

        // Calculate declination
        let declination = asin(sin(latRad) * cos(epsilon) + cos(latRad) * sin(epsilon) * sin(lonRad)) * 180.0 / .pi

        return (declination, rightAscension)
    }

    /// Calculate moonrise time using lunar position
    private func calculateMoonrise(for date: Date, latitude: Double, longitude: Double) -> Date {
        let jd = calculateJulianDate(for: date)
        let (eclipLon, eclipLat, _) = calculateLunarPosition(julianDate: jd)
        let (declination, rightAscension) = calculateLunarCoordinates(longitude: eclipLon, latitude: eclipLat)

        // Calculate hour angle
        let latRad = latitude * .pi / 180.0
        let decRad = declination * .pi / 180.0

        // Use altitude of -0.833° for rise/set (same as sun, accounts for refraction)
        let h0 = -0.833 * .pi / 180.0
        let cosH = (sin(h0) - sin(latRad) * sin(decRad)) / (cos(latRad) * cos(decRad))

        // Check if moon rises/sets today
        let hourAngle: Double
        if cosH > 1 {
            // Moon doesn't rise today, use midnight
            hourAngle = 0
        } else if cosH < -1 {
            // Moon doesn't set today (always up)
            hourAngle = 180
        } else {
            hourAngle = acos(cosH) * 180.0 / .pi
        }

        // Calculate local sidereal time approximation
        let localSiderealTime = (100.46 + 0.985647 * (jd - 2451545.0) + longitude) // Degrees

        // Calculate moonrise time
        let moonriseHA = (rightAscension - localSiderealTime - hourAngle).truncatingRemainder(dividingBy: 360.0)
        let moonriseHour = (moonriseHA / 15.0) // Convert degrees to hours

        // Adjust to reasonable time range (0-24)
        var adjustedHour = moonriseHour
        while adjustedHour < 0 {
            adjustedHour += 24
        }
        while adjustedHour >= 24 {
            adjustedHour -= 24
        }

        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(adjustedHour)
        components.minute = Int((adjustedHour - Double(Int(adjustedHour))) * 60)

        return calendar.date(from: components) ?? date
    }

    /// Calculate moonset time using lunar position
    private func calculateMoonset(for date: Date, latitude: Double, longitude: Double) -> Date {
        let jd = calculateJulianDate(for: date)
        let (eclipLon, eclipLat, _) = calculateLunarPosition(julianDate: jd)
        let (declination, rightAscension) = calculateLunarCoordinates(longitude: eclipLon, latitude: eclipLat)

        // Calculate hour angle
        let latRad = latitude * .pi / 180.0
        let decRad = declination * .pi / 180.0

        // Use altitude of -0.833° for rise/set
        let h0 = -0.833 * .pi / 180.0
        let cosH = (sin(h0) - sin(latRad) * sin(decRad)) / (cos(latRad) * cos(decRad))

        // Check if moon rises/sets today
        let hourAngle: Double
        if cosH > 1 {
            // Moon doesn't rise today
            hourAngle = 0
        } else if cosH < -1 {
            // Moon doesn't set today
            hourAngle = 180
        } else {
            hourAngle = acos(cosH) * 180.0 / .pi
        }

        // Calculate local sidereal time approximation
        let localSiderealTime = (100.46 + 0.985647 * (jd - 2451545.0) + longitude)

        // Calculate moonset time (add hour angle instead of subtract)
        let moonsetHA = (rightAscension - localSiderealTime + hourAngle).truncatingRemainder(dividingBy: 360.0)
        let moonsetHour = (moonsetHA / 15.0)

        // Adjust to reasonable time range (0-24)
        var adjustedHour = moonsetHour
        while adjustedHour < 0 {
            adjustedHour += 24
        }
        while adjustedHour >= 24 {
            adjustedHour -= 24
        }

        // Convert to Date
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = Int(adjustedHour)
        components.minute = Int((adjustedHour - Double(Int(adjustedHour))) * 60)

        return calendar.date(from: components) ?? date
    }

    // MARK: - Public Methods
    
    /// Force an immediate time update (useful for testing)
    func forceUpdate() {
        updateTimeState()
    }
}

