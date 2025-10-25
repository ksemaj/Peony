#!/bin/bash
# Automatic TODO <-> GitHub Issue Sync Script
# This script syncs Cursor TODOs with GitHub issues and project board

set -e

PROJECT_ID="PVT_kwHODY1GmM4BGYmK"
REPO="ksemaj/Peony"
PROJECT_NAME="@ksemaj's Peony"

# Project field IDs
STATUS_FIELD_ID="PVTSSF_lAHODY1GmM4BGYmKzg3cmgc"
PRIORITY_FIELD_ID="PVTSSF_lAHODY1GmM4BGYmKzg3cmpc"

# Status option IDs
STATUS_BACKLOG="f75ad846"
STATUS_READY="61e4505c"
STATUS_IN_PROGRESS="47fc9ee4"
STATUS_IN_REVIEW="df73e18b"
STATUS_DONE="98236657"

# Priority option IDs
PRIORITY_P0="79628723"
PRIORITY_P1="0a877460"
PRIORITY_P2="da944a9c"

# Function to get project item ID for an issue
get_project_item_id() {
    local issue_number=$1
    gh api graphql -f query="
        query {
            repository(owner: \"ksemaj\", name: \"Peony\") {
                issue(number: $issue_number) {
                    projectItems(first: 1) {
                        nodes {
                            id
                        }
                    }
                }
            }
        }" --jq '.data.repository.issue.projectItems.nodes[0].id'
}

# Function to update project item status
update_project_status() {
    local item_id=$1
    local status_id=$2
    gh project item-edit \
        --project-id "$PROJECT_ID" \
        --id "$item_id" \
        --field-id "$STATUS_FIELD_ID" \
        --single-select-option-id "$status_id" 2>/dev/null || true
}

# Function to update project priority
update_project_priority() {
    local item_id=$1
    local priority_id=$2
    gh project item-edit \
        --project-id "$PROJECT_ID" \
        --id "$item_id" \
        --field-id "$PRIORITY_FIELD_ID" \
        --single-select-option-id "$priority_id" 2>/dev/null || true
}

# Function to mark issue as in-progress
mark_in_progress() {
    local issue_number=$1
    echo "→ Moving issue #$issue_number to 'In Progress'"
    
    # Reopen if closed
    gh issue reopen "$issue_number" 2>/dev/null || true
    
    # Update project status
    local item_id=$(get_project_item_id "$issue_number")
    if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
        update_project_status "$item_id" "$STATUS_IN_PROGRESS"
    fi
}

# Function to mark issue as completed
mark_completed() {
    local issue_number=$1
    local commit_sha=${2:-""}
    
    echo "✓ Closing issue #$issue_number and moving to 'Done'"
    
    # Add completion comment
    if [ -n "$commit_sha" ]; then
        gh issue comment "$issue_number" --body "✅ Completed in commit $commit_sha" 2>/dev/null || true
    fi
    
    # Close the issue
    gh issue close "$issue_number" --reason completed 2>/dev/null || true
    
    # Update project status to Done
    local item_id=$(get_project_item_id "$issue_number")
    if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
        update_project_status "$item_id" "$STATUS_DONE"
    fi
}

# Function to create issue from TODO
create_issue_from_todo() {
    local title=$1
    local body=$2
    local priority=${3:-"P1"}
    
    echo "+ Creating new issue: $title"
    
    local issue_url=$(gh issue create \
        --title "$title" \
        --body "$body" \
        --label "enhancement" \
        --project "$PROJECT_NAME")
    
    local issue_number=$(echo "$issue_url" | grep -o '[0-9]*$')
    echo "  Created issue #$issue_number"
    
    # Set priority
    local item_id=$(get_project_item_id "$issue_number")
    if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
        case $priority in
            "High"|"P0")
                update_project_priority "$item_id" "$PRIORITY_P0"
                ;;
            "Medium"|"P1")
                update_project_priority "$item_id" "$PRIORITY_P1"
                ;;
            "Low"|"P2")
                update_project_priority "$item_id" "$PRIORITY_P2"
                ;;
        esac
    fi
    
    echo "$issue_number"
}

# Main sync function
sync_todo() {
    local action=$1
    local issue_number=$2
    local title=${3:-""}
    local body=${4:-""}
    local commit_sha=${5:-""}
    
    case $action in
        "start")
            mark_in_progress "$issue_number"
            ;;
        "complete")
            mark_completed "$issue_number" "$commit_sha"
            ;;
        "create")
            create_issue_from_todo "$title" "$body"
            ;;
        *)
            echo "Usage: sync-todos.sh {start|complete|create} [issue_number|title] [body] [commit_sha]"
            exit 1
            ;;
    esac
}

# Run the sync
sync_todo "$@"

