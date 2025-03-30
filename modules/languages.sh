#!/usr/bin/env bash
#
# DevEnvSetup - Programming Languages Module
# This module handles the installation and configuration of programming languages

# Function to set up programming languages
function setup_languages() {
    log "INFO" "Setting up programming languages..."
    
    # Set up Python if enabled
    if [[ "${INSTALL_PYTHON}" == true ]]; then
        setup_python
    fi
    
    # Set up Node.js if enabled
    if [[ "${INSTALL_NODE}" == true ]]; then
        setup_node
    fi
    
    # Set up Java if enabled
    if [[ "${INSTALL_JAVA}" == true ]]; then
        setup_java
    fi
    
    # Set up Go if enabled
    if [[ "${INSTALL_GO}" == true ]]; then
        setup_go
    fi
    
    # Set up Rust if enabled
    if [[ "${INSTALL_RUST}" == true ]]; then
        setup_rust
    fi
    
    # Set up R if enabled
    if [[ "${INSTALL_R}" == true ]]; then
        setup_r
    fi
    
    # Set up Conda if enabled
    if [[ "${SETUP_CONDA}" == true ]]; then
        setup_conda
    fi
    
    log "SUCCESS" "Programming languages setup completed successfully"
    return 0
}

# Function to set up Java
function setup_java() {
    log "INFO" "Setting up Java..."
    
    # Check if Java is already installed
    if check_command java; then
        log "INFO" "Java is already installed"
    else
        log "INFO" "Java not found. Installing Java..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            sudo apt-get update
                            sudo apt-get install -y default-jdk || {
                                log "ERROR" "Failed to install Java"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            if check_command dnf; then
                                sudo dnf install -y java-latest-openjdk-devel || {
                                    log "ERROR" "Failed to install Java"
                                    return 1
                                }
                            else
                                sudo yum install -y java-latest-openjdk-devel || {
                                    log "ERROR" "Failed to install Java"
                                    return 1
                                }
                            fi
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    ;;
                    
                macos)
                    brew install openjdk || {
                        log "ERROR" "Failed to install Java"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Java installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Java installation..."
        
        if ! java -version; then
            log "ERROR" "Java installation verification failed"
            return 1
        fi
        
        # Set JAVA_HOME environment variable if not already set
        if [[ -z "${JAVA_HOME}" ]]; then
            local java_home
            
            case "${OS}" in
                linux)
                    java_home=$(dirname "$(dirname "$(readlink -f "$(which java)")")")
                    echo "export JAVA_HOME=${java_home}" >> "${HOME}/.bashrc"
                    ;;
                    
                macos)
                    java_home=$(/usr/libexec/java_home)
                    echo "export JAVA_HOME=${java_home}" >> "${HOME}/.bash_profile"
                    ;;
            esac
            
            log "INFO" "Set JAVA_HOME environment variable to ${java_home}"
        fi
    fi
    
    log "SUCCESS" "Java setup completed successfully"
    return 0
}

# Function to set up Go
function setup_go() {
    log "INFO" "Setting up Go..."
    
    # Check if Go is already installed
    if check_command go; then
        log "INFO" "Go is already installed"
    else
        log "INFO" "Go not found. Installing Go..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            sudo apt-get update
                            sudo apt-get install -y golang-go || {
                                log "ERROR" "Failed to install Go"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            if check_command dnf; then
                                sudo dnf install -y golang || {
                                    log "ERROR" "Failed to install Go"
                                    return 1
                                }
                            else
                                sudo yum install -y golang || {
                                    log "ERROR" "Failed to install Go"
                                    return 1
                                }
                            fi
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    ;;
                    
                macos)
                    brew install go || {
                        log "ERROR" "Failed to install Go"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Go installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Go installation..."
        
        if ! go version; then
            log "ERROR" "Go installation verification failed"
            return 1
        fi
        
        # Set up Go environment variables if not already set
        if [[ -z "${GOPATH}" ]]; then
            mkdir -p "${HOME}/go"
            echo "export GOPATH=${HOME}/go" >> "${HOME}/.bashrc"
            echo "export PATH=\${PATH}:\${GOPATH}/bin" >> "${HOME}/.bashrc"
            log "INFO" "Set GOPATH environment variable to ${HOME}/go"
        fi
    fi
    
    log "SUCCESS" "Go setup completed successfully"
    return 0
}

# Function to set up Rust
function setup_rust() {
    log "INFO" "Setting up Rust..."
    
    # Check if Rust is already installed
    if check_command rustc; then
        log "INFO" "Rust is already installed"
    else
        log "INFO" "Rust not found. Installing Rust..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            # Install Rust using rustup
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || {
                log "ERROR" "Failed to install Rust"
                return 1
            }
            
            # Load Rust environment
            source "${HOME}/.cargo/env" || {
                log "ERROR" "Failed to load Rust environment"
                return 1
            }
        fi
    fi
    
    # Verify Rust installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Rust installation..."
        
        if ! rustc --version; then
            log "ERROR" "Rust installation verification failed"
            return 1
        fi
        
        # Verify cargo installation
        log "INFO" "Verifying cargo installation..."
        
        if ! cargo --version; then
            log "ERROR" "cargo installation verification failed"
            return 1
        }
    fi
    
    log "SUCCESS" "Rust setup completed successfully"
    return 0
}

# Function to set up R
function setup_r() {
    log "INFO" "Setting up R..."
    
    # Check if R is already installed
    if check_command R; then
        log "INFO" "R is already installed"
    else
        log "INFO" "R not found. Installing R..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            # Add R repository for Debian-based systems
                            sudo apt-get update
                            sudo apt-get install -y dirmngr gnupg software-properties-common
                            sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
                            sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
                            sudo apt-get update
                            sudo apt-get install -y r-base r-base-dev || {
                                log "ERROR" "Failed to install R"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            if check_command dnf; then
                                sudo dnf install -y R || {
                                    log "ERROR" "Failed to install R"
                                    return 1
                                }
                            else
                                sudo yum install -y R || {
                                    log "ERROR" "Failed to install R"
                                    return 1
                                }
                            fi
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    ;;
                    
                macos)
                    brew install r || {
                        log "ERROR" "Failed to install R"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify R installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying R installation..."
        
        if ! R --version; then
            log "ERROR" "R installation verification failed"
            return 1
        fi
    fi
    
    # Install R packages if specified
    if [[ -n "${R_PACKAGES}" && "${DRY_RUN}" != true ]]; then
        log "INFO" "Installing R packages..."
        
        # Create R script to install packages
        local r_script="/tmp/install_r_packages.R"
        
        echo "install.packages(c(" > "${r_script}"
        
        # Add packages as quoted strings
        for package in "${R_PACKAGES[@]}"; do
            echo "  \"${package}\"," >> "${r_script}"
        done
        
        # Close the list and add repository
        echo "), repos='https://cran.rstudio.com/')" >> "${r_script}"
        
        # Run the R script
        Rscript "${r_script}" || {
            log "WARNING" "Failed to install some R packages"
        }
        
        # Remove temporary script
        rm -f "${r_script}"
    fi
    
    log "SUCCESS" "R setup completed successfully"
    return 0
}

# Function to set up Conda
function setup_conda() {
    log "INFO" "Setting up Conda..."
    
    # Check if Conda is already installed
    if check_command conda; then
        log "INFO" "Conda is already installed"
    else
        log "INFO" "Conda not found. Installing Miniconda..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            # Download Miniconda installer
            local miniconda_installer="/tmp/miniconda.sh"
            
            case "${OS}" in
                linux)
                    curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o "${miniconda_installer}" || {
                        log "ERROR" "Failed to download Miniconda installer"
                        return 1
                    }
                    ;;
                    
                macos)
                    curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o "${miniconda_installer}" || {
                        log "ERROR" "Failed to download Miniconda installer"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
            
            # Install Miniconda
            bash "${miniconda_installer}" -b -p "${HOME}/miniconda" || {
                log "ERROR" "Failed to install Miniconda"
                rm -f "${miniconda_installer}"
                return 1
            }
            
            # Remove installer
            rm -f "${miniconda_installer}"
            
            # Initialize Conda
            "${HOME}/miniconda/bin/conda" init bash || {
                log "ERROR" "Failed to initialize Conda"
                return 1
            }
            
            # Add Conda to the current path
            export PATH="${HOME}/miniconda/bin:${PATH}"
        fi
    fi
    
    # Verify Conda installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Conda installation..."
        
        if ! conda --version; then
            log "ERROR" "Conda installation verification failed"
            return 1
        fi
        
        # Update Conda
        conda update -y conda || {
            log "WARNING" "Failed to update Conda"
        }
    fi
    
    log "SUCCESS" "Conda setup completed successfully"
    return 0
}

# Function to set up Python
function setup_python() {
    log "INFO" "Setting up Python..."
    
    # Check if Python is already installed
    if check_command python3; then
        log "INFO" "Python 3 is already installed"
    else
        log "INFO" "Python 3 not found. Installing Python 3..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            sudo apt-get update
                            sudo apt-get install -y python3 python3-pip python3-venv || {
                                log "ERROR" "Failed to install Python 3"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            # Install Node.js using NVM (Node Version Manager)
                            if ! check_command nvm; then
                                log "INFO" "Installing NVM (Node Version Manager)..."
                                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash || {
                                    log "ERROR" "Failed to install NVM"
                                    return 1
                                }
                                
                                # Load NVM
                                export NVM_DIR="$HOME/.nvm"
                                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || {
                                    log "ERROR" "Failed to load NVM"
                                    return 1
                                }
                            fi
                            
                            # Install latest LTS version of Node.js
                            nvm install --lts || {
                                log "ERROR" "Failed to install Node.js"
                                return 1
                            }
                            
                            # Use the installed version
                            nvm use --lts || {
                                log "ERROR" "Failed to use the installed Node.js version"
                                return 1
                            }
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    ;;
                    
                macos)
                    # Install Node.js using Homebrew
                    brew install node || {
                        log "ERROR" "Failed to install Node.js"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Node.js installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Node.js installation..."
        
        if ! node --version; then
            log "ERROR" "Node.js installation verification failed"
            return 1
        fi
        
        # Verify npm installation
        log "INFO" "Verifying npm installation..."
        
        if ! npm --version; then
            log "ERROR" "npm installation verification failed"
            return 1
        }
    fi
    
    # Install global Node.js packages if specified
    if [[ -n "${NODE_GLOBAL_PACKAGES}" && "${DRY_RUN}" != true ]]; then
        log "INFO" "Installing global Node.js packages..."
        
        for package in "${NODE_GLOBAL_PACKAGES[@]}"; do
            log "INFO" "Installing Node.js package: ${package}"
            npm install -g "${package}" || {
                log "WARNING" "Failed to install Node.js package: ${package}"
            }
        done
    fi
    
    log "SUCCESS" "Node.js setup completed successfully"
    return 0
                            ;;
                            
                        redhat)
                            if check_command dnf; then
                                sudo dnf install -y python3 python3-pip || {
                                    log "ERROR" "Failed to install Python 3"
                                    return 1
                                }
                            else
                                sudo yum install -y python3 python3-pip || {
                                    log "ERROR" "Failed to install Python 3"
                                    return 1
                                }
                            fi
                            ;;
                            
                        *)
                            log "ERROR" "Unsupported Linux distribution: ${DISTRO}"
                            return 1
                            ;;
                    esac
                    ;;
                    
                macos)
                    brew install python || {
                        log "ERROR" "Failed to install Python 3"
                        return 1
                    }
                    ;;
                    
                *)
                    log "ERROR" "Unsupported operating system: ${OS}"
                    return 1
                    ;;
            esac
        fi
    fi
    
    # Verify Python installation
    if [[ "${DRY_RUN}" != true ]]; then
        log "INFO" "Verifying Python installation..."
        
        if ! python3 --version; then
            log "ERROR" "Python installation verification failed"
            return 1
        fi
        
        # Verify pip installation
        log "INFO" "Verifying pip installation..."
        
        if ! pip3 --version; then
            log "ERROR" "pip installation verification failed"
            return 1
        fi
    fi
    
    # Install global Python packages if specified
    if [[ -n "${PYTHON_GLOBAL_PACKAGES}" && "${DRY_RUN}" != true ]]; then
        log "INFO" "Installing global Python packages..."
        
        for package in "${PYTHON_GLOBAL_PACKAGES[@]}"; do
            log "INFO" "Installing Python package: ${package}"
            pip3 install --user "${package}" || {
                log "WARNING" "Failed to install Python package: ${package}"
            }
        done
    fi
    
    log "SUCCESS" "Python setup completed successfully"
    return 0
}

# Function to set up Node.js
function setup_node() {
    log "INFO" "Setting up Node.js..."
    
    # Check if Node.js is already installed
    if check_command node; then
        log "INFO" "Node.js is already installed"
    else
        log "INFO" "Node.js not found. Installing Node.js..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            # Install Node.js using NVM (Node Version Manager)
                            if ! check_command nvm; then
                                log "INFO" "Installing NVM (Node Version Manager)..."
                                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash || {
                                    log "ERROR" "Failed to install NVM"
                                    return 1
                                }
                                
                                # Load NVM
                                export NVM_DIR="$HOME/.nvm"
                                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || {
                                    log "ERROR" "Failed to load NVM"
                                    return 1
                                }
                            fi
                            
                            # Install latest LTS version of Node.js
                            nvm install --lts || {
                                log "ERROR" "Failed to install Node.js"
                                return 1
                            }
                            
                            # Use the installed version
                            nvm use --lts || {
                                log "ERROR" "Failed to use the installed Node.js version"
                                return 1
                            }