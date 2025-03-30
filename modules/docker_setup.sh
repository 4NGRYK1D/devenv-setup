#!/usr/bin/env bash
#
# DevEnvSetup - Docker Setup Module
# This module handles Docker installation and configuration

# Function to set up Docker
function setup_docker() {
    log "INFO" "Setting up Docker..."
    
    # Check if Docker is already installed
    if check_command docker; then
        log "INFO" "Docker is already installed"
    else
        log "INFO" "Docker not found. Installing Docker..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            # Install dependencies
                            sudo apt-get update
                            sudo apt-get install -y \
                                ca-certificates \
                                curl \
                                gnupg \
                                lsb-release || {
                                log "ERROR" "Failed to install Docker dependencies"
                                return 1
                            }
                            
                            # Add Docker's official GPG key
                            sudo mkdir -p /etc/apt/keyrings
                            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || {
                                log "ERROR" "Failed to add Docker GPG key"
                                return 1
                            }
                            
                            # Set up the repository
                            echo \
                                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || {
                                log "ERROR" "Failed to add Docker repository"
                                return 1
                            }
                            
                            # Install Docker Engine
                            sudo apt-get update
                            sudo apt-get install -y docker-ce docker-ce-cli containerd.io || {
                                log "ERROR" "Failed to install Docker"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            # Install dependencies
                            if check_command dnf; then
                                sudo dnf -y install dnf-plugins-core || {
                                    log "ERROR" "Failed to install Docker dependencies"
                                    return 1
                                }
                                
                                # Add Docker repository
                                sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || {
                                    log "ERROR" "Failed to add Docker repository"
                                    return 1
                                }
                                
                                # Install Docker Engine
                                sudo dnf install -y docker-ce docker-ce-cli containerd.io || {
                                    log "ERROR" "Failed to install Docker"
                                    return 1
                                }
                            else
                                # For older versions using yum
                                sudo yum install -y yum-utils || {
                                    log "ERROR" "Failed to install Docker dependencies"
                                    return 1
                                }
                                
                                # Add Docker repository
                                sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || {
                                    log "ERROR" "Failed to add Docker repository"
                                    return 1
                                }
                                
                                # Install Docker Engine
                                sudo yum install -y docker-ce docker-ce-cli containerd.io || {
                                    log "ERROR" "Failed to install Docker"
                                    return 1
                                }
                            fi
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    
                    # Start and enable Docker service
                    sudo systemctl start docker || {
                        log "ERROR" "Failed to start Docker service"
                        return 1
                    }
                    
                    sudo systemctl enable docker || {
                        log "ERROR" "Failed to enable Docker service"
                        return 1
                    }
                    
                    # Add current user to docker group to run docker without sudo
                    sudo usermod -aG docker "${USER}" || {
                        log "WARNING" "Failed to add user to docker group. You may need to run Docker with sudo."
                    }
                    
                    log "INFO" "Please log out and log back in for the group changes to take effect."
                    ;;
                    
                macos)
                    # On macOS, we'll use Homebrew to install Docker Desktop
                    log "INFO" "Installing Docker Desktop for Mac..."
                    brew install --cask docker || {
                        log "ERROR" "Failed to install Docker Desktop"
                        return 1
                    }
                    
                    # Open Docker Desktop
                    open -a Docker || {
                        log "WARNING" "Failed to open Docker Desktop. Please open it manually."
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Docker installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Docker installation..."
        
        if ! docker --version; then
            log "ERROR" "Docker installation verification failed"
            return 1
        fi
    fi
    
    # Set up Docker Compose if enabled
    if [[ "${SETUP_DOCKER_COMPOSE}" == true ]]; then
        setup_docker_compose
    fi
    
    log "SUCCESS" "Docker setup completed successfully"
    return 0
}

# Function to set up Docker Compose
function setup_docker_compose() {
    log "INFO" "Setting up Docker Compose..."
    
    # Check if Docker Compose is already installed
    if check_command docker-compose; then
        log "INFO" "Docker Compose is already installed"
    else
        log "INFO" "Docker Compose not found. Installing Docker Compose..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    # Install Docker Compose
                    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
                    sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || {
                        log "ERROR" "Failed to download Docker Compose"
                        return 1
                    }
                    
                    sudo chmod +x /usr/local/bin/docker-compose || {
                        log "ERROR" "Failed to set executable permission for Docker Compose"
                        return 1
                    }
                    ;;
                    
                macos)
                    # Docker Compose is included with Docker Desktop for Mac
                    log "INFO" "Docker Compose should be included with Docker Desktop for Mac"
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Docker Compose installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Docker Compose installation..."
        
        if ! docker-compose --version; then
            log "ERROR" "Docker Compose installation verification failed"
            return 1
        fi
    fi
    
    log "SUCCESS" "Docker Compose setup completed successfully"
    return 0
}