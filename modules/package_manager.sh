#!/usr/bin/env bash
#
# DevEnvSetup - Package Manager Module
# This module handles package manager setup and package installation

# Function to set up the appropriate package manager
function setup_package_manager() {
    log "INFO" "Setting up package manager..."
    
    # Ensure package manager is up to date
    case "${DISTRO}" in
        debian)
            if check_command apt; then
                log "INFO" "Updating apt package lists..."
                if [[ "${DRY_RUN}" != true ]]; then
                    sudo apt update || {
                        log "ERROR" "Failed to update apt package lists"
                        return 1
                    }
                    log "SUCCESS" "Successfully updated apt package lists"
                fi
            else
                log "ERROR" "apt not found"
                return 1
            fi
            ;;
        
        redhat)
            if check_command dnf; then
                log "INFO" "Updating dnf package lists..."
                if [[ "${DRY_RUN}" != true ]]; then
                    sudo dnf check-update || {
                        # dnf check-update exits with code 100 if there are updates
                        if [[ $? -ne 100 ]]; then
                            log "ERROR" "Failed to update dnf package lists"
                            return 1
                        fi
                    }
                    log "SUCCESS" "Successfully updated dnf package lists"
                fi
            elif check_command yum; then
                log "INFO" "Updating yum package lists..."
                if [[ "${DRY_RUN}" != true ]]; then
                    sudo yum check-update || {
                        # yum check-update exits with code 100 if there are updates
                        if [[ $? -ne 100 ]]; then
                            log "ERROR" "Failed to update yum package lists"
                            return 1
                        fi
                    }
                    log "SUCCESS" "Successfully updated yum package lists"
                fi
            else
                log "ERROR" "Neither dnf nor yum found"
                return 1
            fi
            ;;
        
        macos)
            if check_command brew; then
                log "INFO" "Updating Homebrew..."
                if [[ "${DRY_RUN}" != true ]]; then
                    brew update || {
                        log "ERROR" "Failed to update Homebrew"
                        return 1
                    }
                    log "SUCCESS" "Successfully updated Homebrew"
                fi
            else
                log "INFO" "Homebrew not found. Installing Homebrew..."
                if [[ "${DRY_RUN}" != true ]]; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
                        log "ERROR" "Failed to install Homebrew"
                        return 1
                    }
                    log "SUCCESS" "Successfully installed Homebrew"
                fi
            fi
            ;;
        
        *)
            log "ERROR" "Unsupported distribution: ${DISTRO}"
            return 1
            ;;
    esac
    
    # Install essential packages
    install_essential_packages
    
    log "SUCCESS" "Package manager setup completed successfully"
    return 0
}

# Function to install essential packages based on distribution
function install_essential_packages() {
    log "INFO" "Installing essential packages..."
    
    case "${DISTRO}" in
        debian)
            local pkgs=("${ESSENTIAL_PACKAGES_DEBIAN[@]}")
            log "INFO" "Installing packages: ${pkgs[*]}"
            
            if [[ "${DRY_RUN}" != true ]]; then
                sudo apt install -y "${pkgs[@]}" || {
                    log "ERROR" "Failed to install essential packages"
                    return 1
                }
            fi
            ;;
        
        redhat)
            local pkgs=("${ESSENTIAL_PACKAGES_REDHAT[@]}")
            log "INFO" "Installing packages: ${pkgs[*]}"
            
            if [[ "${DRY_RUN}" != true ]]; then
                if check_command dnf; then
                    sudo dnf install -y "${pkgs[@]}" || {
                        log "ERROR" "Failed to install essential packages"
                        return 1
                    }
                else
                    sudo yum install -y "${pkgs[@]}" || {
                        log "ERROR" "Failed to install essential packages"
                        return 1
                    }
                fi
            fi
            ;;
        
        macos)
            local pkgs=("${ESSENTIAL_PACKAGES_MACOS[@]}")
            log "INFO" "Installing packages: ${pkgs[*]}"
            
            if [[ "${DRY_RUN}" != true ]]; then
                brew install "${pkgs[@]}" || {
                    log "ERROR" "Failed to install essential packages"
                    return 1
                }
            fi
            ;;
        
        *)
            log "ERROR" "Unsupported distribution: ${DISTRO}"
            return 1
            ;;
    esac
    
    log "SUCCESS" "Essential packages installed successfully"
    return 0
}

# Function to install a specific package
function install_package() {
    local package="$1"
    
    log "INFO" "Installing package: ${package}"
    
    case "${DISTRO}" in
        debian)
            if [[ "${DRY_RUN}" != true ]]; then
                sudo apt install -y "${package}" || {
                    log "ERROR" "Failed to install package: ${package}"
                    return 1
                }
            fi
            ;;
        
        redhat)
            if [[ "${DRY_RUN}" != true ]]; then
                if check_command dnf; then
                    sudo dnf install -y "${package}" || {
                        log "ERROR" "Failed to install package: ${package}"
                        return 1
                    }
                else
                    sudo yum install -y "${package}" || {
                        log "ERROR" "Failed to install package: ${package}"
                        return 1
                    }
                fi
            fi
            ;;
        
        macos)
            if [[ "${DRY_RUN}" != true ]]; then
                brew install "${package}" || {
                    log "ERROR" "Failed to install package: ${package}"
                    return 1
                }
            fi
            ;;
        
        *)
            log "ERROR" "Unsupported distribution: ${DISTRO}"
            return 1
            ;;
    esac
    
    log "SUCCESS" "Package ${package} installed successfully"
    return 0
}
