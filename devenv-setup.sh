#!/usr/bin/env bash
#
# DevEnvSetup - Development Environment Setup Tool
# Author: Your Name
# License: MIT
# Version: 1.0.0
#
# A tool to quickly set up development environments with customizable profiles

# Exit on error, undefined variable, or pipe failure
set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
PROFILE="default"
DRY_RUN=false
VERBOSE=false
LOG_FILE="${SCRIPT_DIR}/devenv-setup.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------

function log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Log to file
    echo "${timestamp} [${level}] ${message}" >> "${LOG_FILE}"
    
    # Log to stdout if verbose
    if [[ "${VERBOSE}" == true || "${level}" == "ERROR" ]]; then
        case "${level}" in
            "INFO")
                echo -e "${BLUE}[INFO]${NC} ${message}"
                ;;
            "SUCCESS")
                echo -e "${GREEN}[SUCCESS]${NC} ${message}"
                ;;
            "WARNING")
                echo -e "${YELLOW}[WARNING]${NC} ${message}"
                ;;
            "ERROR")
                echo -e "${RED}[ERROR]${NC} ${message}" >&2
                ;;
        esac
    fi
}

function check_command() {
    local cmd="$1"
    if ! command -v "${cmd}" &> /dev/null; then
        return 1
    fi
    return 0
}

function load_profile() {
    local profile_path="${SCRIPT_DIR}/config/profiles/${PROFILE}.conf"
    
    if [[ ! -f "${profile_path}" ]]; then
        log "ERROR" "Profile '${PROFILE}' not found at ${profile_path}"
        exit 1
    fi
    
    log "INFO" "Loading profile '${PROFILE}' from ${profile_path}"
    source "${profile_path}"
    log "SUCCESS" "Profile '${PROFILE}' loaded successfully"
}

function print_banner() {
    echo -e "${BLUE}"
    echo "  _____              _____           _____      _               "
    echo " |  __ \            |  ___|         /  ___|    | |              "
    echo " | |  | | _____   __|  |_ _ ____   _\ \-_ _ __| |_ _   _ _ __  "
    echo " | |  | |/ _ \ \ / /|  _| '_ \ \ / /\ \| | '__| __| | | | '_ \ "
    echo " | |__| |  __/\ V / | | | | | \ V / _\ \ | |  | |_| |_| | |_) |"
    echo " |_____/ \___| \_/  \_| |_| |_|\_/  \__/_|_|   \__|\__,_| .__/ "
    echo "                                                         | |    "
    echo "                                                         |_|    "
    echo -e "${NC}"
    echo "DevEnvSetup v1.0.0 - Development Environment Setup Tool"
    echo "-----------------------------------------------------"
    echo
}

function print_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help                 Show this help message and exit"
    echo "  -p, --profile PROFILE      Specify the profile to use (default: default)"
    echo "  -d, --dry-run              Show what would be done without making changes"
    echo "  -v, --verbose              Enable verbose output"
    echo "  --list-profiles            List available profiles"
    echo
    echo "Available profiles:"
    for profile in "${SCRIPT_DIR}"/config/profiles/*.conf; do
        profile_name=$(basename "${profile}" .conf)
        echo "  - ${profile_name}"
    done
    echo
    echo "Examples:"
    echo "  $0                         # Run with default profile"
    echo "  $0 -p web_dev              # Set up a web development environment"
    echo "  $0 -p data_science -v      # Set up a data science environment with verbose output"
    echo "  $0 -d                      # Dry run with default profile"
    echo
}

function list_profiles() {
    echo "Available profiles:"
    for profile in "${SCRIPT_DIR}"/config/profiles/*.conf; do
        profile_name=$(basename "${profile}" .conf)
        echo "  - ${profile_name}"
    done
}

function check_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [[ -f /etc/debian_version ]]; then
            DISTRO="debian"
        elif [[ -f /etc/redhat-release ]]; then
            DISTRO="redhat"
        else
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macos"
    else
        log "ERROR" "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log "INFO" "Detected OS: ${OS}, Distribution: ${DISTRO}"
}

function load_modules() {
    log "INFO" "Loading modules..."
    
    # Load all module scripts
    for module in "${SCRIPT_DIR}"/modules/*.sh; do
        if [[ -f "${module}" ]]; then
            log "INFO" "Loading module: $(basename "${module}")"
            source "${module}"
        fi
    done
    
    log "SUCCESS" "All modules loaded successfully"
}

function execute_setup() {
    log "INFO" "Starting setup with profile '${PROFILE}'"
    
    # Execute setup functions based on the loaded profile
    if [[ "${SETUP_PACKAGE_MANAGER}" == true ]]; then
        setup_package_manager || log "ERROR" "Failed to set up package manager"
    fi
    
    if [[ "${SETUP_GIT}" == true ]]; then
        setup_git || log "ERROR" "Failed to set up Git"
    fi
    
    if [[ "${SETUP_EDITOR}" == true ]]; then
        setup_editor || log "ERROR" "Failed to set up editor"
    fi
    
    if [[ "${SETUP_DOCKER}" == true ]]; then
        setup_docker || log "ERROR" "Failed to set up Docker"
    fi
    
    if [[ "${SETUP_LANGUAGES}" == true ]]; then
        setup_languages || log "ERROR" "Failed to set up programming languages"
    fi
    
    if [[ "${SETUP_SHELL}" == true ]]; then
        setup_shell || log "ERROR" "Failed to set up shell configuration"
    fi
    
    log "SUCCESS" "Setup completed successfully!"
}

# -----------------------------------------------------------------------------
# Main script execution
# -----------------------------------------------------------------------------

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_help
            exit 0
            ;;
        -p|--profile)
            PROFILE="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --list-profiles)
            list_profiles
            exit 0
            ;;
        *)
            log "ERROR" "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Initialize log file
> "${LOG_FILE}"
log "INFO" "Starting DevEnvSetup script"

# Print banner
print_banner

# Check operating system
check_os

# Load the selected profile
load_profile

# Load modules
load_modules

# Execute setup if not in dry-run mode
if [[ "${DRY_RUN}" == true ]]; then
    log "INFO" "Dry run mode enabled. No changes will be made."
    # TODO: Implement dry-run logic for each module
else
    execute_setup
fi

# Print completion message
echo
echo -e "${GREEN}=======================================================${NC}"
if [[ "${DRY_RUN}" == true ]]; then
    echo -e "${YELLOW}Dry run completed. No changes were made.${NC}"
else
    echo -e "${GREEN}Development environment setup completed successfully!${NC}"
fi
echo -e "${BLUE}Log file: ${LOG_FILE}${NC}"
echo -e "${GREEN}=======================================================${NC}"

exit 0
