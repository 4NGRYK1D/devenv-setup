#!/usr/bin/env bash
#
# DevEnvSetup - Editor Setup Module
# This module handles the installation and configuration of code editors

# Function to set up code editors
function setup_editor() {
    log "INFO" "Setting up code editor(s)..."
    
    # Set up Vim if enabled
    if [[ "${SETUP_VIM_CONFIG}" == true ]]; then
        setup_vim
    fi
    
    # Install and set up VS Code if enabled
    if [[ "${INSTALL_VSCODE}" == true ]]; then
        install_vscode
    fi
    
    # Install and set up Neovim if enabled
    if [[ "${INSTALL_NEOVIM}" == true ]]; then
        install_neovim
    fi
    
    # Install and set up Jupyter if enabled
    if [[ "${INSTALL_JUPYTER}" == true ]]; then
        install_jupyter
    fi
    
    log "SUCCESS" "Editor setup completed successfully"
    return 0
}

# Function to set up Vim configuration
function setup_vim() {
    log "INFO" "Setting up Vim configuration..."
    
    if ! check_command vim; then
        log "INFO" "Vim not found. Installing Vim..."
        install_package "vim" || {
            log "ERROR" "Failed to install Vim"
            return 1
        }
    fi
    
    if [[ "${DRY_RUN}" != true ]]; then
        # Create .vimrc if it doesn't exist
        if [[ ! -f "${HOME}/.vimrc" ]]; then
            log "INFO" "Creating .vimrc file..."
            
            # Copy the vim config template if it exists, otherwise create a basic one
            if [[ -f "${SCRIPT_DIR}/config/editor_configs/vim_config.vim" ]]; then
                cp "${SCRIPT_DIR}/config/editor_configs/vim_config.vim" "${HOME}/.vimrc" || {
                    log "ERROR" "Failed to copy Vim configuration template"
                    return 1
                }
            else
                # Create a basic .vimrc with sensible defaults
                cat > "${HOME}/.vimrc" << 'EOF'
" Basic Settings
syntax on                 " Enable syntax highlighting
set number                " Show line numbers
set relativenumber        " Show relative line numbers
set autoindent            " Auto-indent new lines
set expandtab             " Use spaces instead of tabs
set smartindent           " Enable smart-indent
set smarttab              " Enable smart-tabs
set softtabstop=4         " Number of spaces per tab
set shiftwidth=4          " Number of auto-indent spaces
set ruler                 " Show row and column ruler information
set undolevels=1000       " Number of undo levels
set backspace=indent,eol,start  " Backspace behavior

" Search settings
set hlsearch              " Highlight all search results
set incsearch             " Searches for strings incrementally
set ignorecase            " Ignore case in search patterns
set smartcase             " Override ignorecase when search contains uppercase

" Other settings
set wildmenu              " Enable command-line completion
set confirm               " Prompt confirmation for unsaved changes
set visualbell            " Use visual bell instead of beeping
set t_vb=                 " Disable visual bell
set mouse=a               " Enable mouse usage
set cmdheight=1           " Command line height
set showmatch             " Highlight matching braces
set mat=2                 " How many tenths of a second to blink
set encoding=utf-8        " Default encoding
set fileencoding=utf-8    " File encoding
set fileformats=unix,dos,mac  " File format
set autoread              " Auto-reload files changed outside of Vim

" Key mappings
" Map leader key to comma
let mapleader = ","

" Quick save
nmap <leader>w :w!<cr>

" Quick quit
nmap <leader>q :q<cr>

" Quick save and quit
nmap <leader>wq :wq<cr>

" Toggle paste mode
nmap <leader>p :set paste!<cr>

" Toggle line numbers
nmap <leader>n :set number!<cr>
EOF
            fi
            
            log "SUCCESS" "Created Vim configuration file at ${HOME}/.vimrc"
        else
            log "INFO" "Vim configuration already exists at ${HOME}/.vimrc"
        fi
    fi
    
    log "SUCCESS" "Vim configuration completed successfully"
    return 0
}

# Function to install VS Code
function install_vscode() {
    log "INFO" "Setting up Visual Studio Code..."
    
    if check_command code; then
        log "INFO" "Visual Studio Code is already installed"
    else
        log "INFO" "Visual Studio Code not found. Installing..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            # Install VS Code on Debian-based systems
                            # Add Microsoft GPG key
                            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
                            sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg || {
                                log "ERROR" "Failed to add Microsoft GPG key"
                                return 1
                            }
                            
                            # Add VS Code repository
                            echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | \
                                sudo tee /etc/apt/sources.list.d/vscode.list || {
                                log "ERROR" "Failed to add VS Code repository"
                                return 1
                            }
                            
                            # Update and install
                            sudo apt update && sudo apt install -y code || {
                                log "ERROR" "Failed to install Visual Studio Code"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            # Install VS Code on RHEL-based systems
                            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc || {
                                log "ERROR" "Failed to import Microsoft GPG key"
                                return 1
                            }
                            
                            # Add VS Code repository
                            cat << EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
                            
                            # Install
                            if check_command dnf; then
                                sudo dnf install -y code || {
                                    log "ERROR" "Failed to install Visual Studio Code"
                                    return 1
                                }
                            else
                                sudo yum install -y code || {
                                    log "ERROR" "Failed to install Visual Studio Code"
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
                    # Install VS Code on macOS
                    brew install --cask visual-studio-code || {
                        log "ERROR" "Failed to install Visual Studio Code"
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
    
    # Install VS Code extensions if specified
    if [[ -n "${VSCODE_EXTENSIONS}" && "${DRY_RUN}" != true ]]; then
        log "INFO" "Installing VS Code extensions..."
        
        for extension in "${VSCODE_EXTENSIONS[@]}"; do
            log "INFO" "Installing VS Code extension: ${extension}"
            code --install-extension "${extension}" || {
                log "WARNING" "Failed to install VS Code extension: ${extension}"
            }
        done
    fi
    
    # Configure VS Code settings if needed
    if [[ "${SETUP_VSCODE_SETTINGS}" == true && "${DRY_RUN}" != true ]]; then
        log "INFO" "Configuring VS Code settings..."
        
        local vscode_settings_dir
        
        case "${OS}" in
            linux)
                vscode_settings_dir="${HOME}/.config/Code/User"
                ;;
                
            macos)
                vscode_settings_dir="${HOME}/Library/Application Support/Code/User"
                ;;
                
            *)
                log "ERROR" "Unsupported operating system for VS Code settings: ${OS}"
                return 1
                ;;
        esac
        
        # Create settings directory if it doesn't exist
        mkdir -p "${vscode_settings_dir}" || {
            log "ERROR" "Failed to create VS Code settings directory"
            return 1
        }
        
        # Copy settings.json if it exists in the repo
        if [[ -f "${SCRIPT_DIR}/config/editor_configs/vscode_settings.json" ]]; then
            cp "${SCRIPT_DIR}/config/editor_configs/vscode_settings.json" "${vscode_settings_dir}/settings.json" || {
                log "ERROR" "Failed to copy VS Code settings"
                return 1
            }
        fi
    fi
    
    log "SUCCESS" "Visual Studio Code setup completed successfully"
    return 0
}

# Function to install Neovim
function install_neovim() {
    log "INFO" "Setting up Neovim..."
    
    if check_command nvim; then
        log "INFO" "Neovim is already installed"
    else
        log "INFO" "Neovim not found. Installing..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            case "${OS}" in
                linux)
                    case "${DISTRO}" in
                        debian)
                            sudo apt install -y neovim || {
                                log "ERROR" "Failed to install Neovim"
                                return 1
                            }
                            ;;
                            
                        redhat)
                            if check_command dnf; then
                                sudo dnf install -y neovim || {
                                    log "ERROR" "Failed to install Neovim"
                                    return 1
                                }
                            else
                                sudo yum install -y neovim || {
                                    log "ERROR" "Failed to install Neovim"
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
                    brew install neovim || {
                        log "ERROR" "Failed to install Neovim"
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
    
    # Set up Neovim configuration
    if [[ "${DRY_RUN}" != true ]]; then
        # Create config directory
        mkdir -p "${HOME}/.config/nvim" || {
            log "ERROR" "Failed to create Neovim config directory"
            return 1
        }
        
        # Create init.vim if it doesn't exist
        if [[ ! -f "${HOME}/.config/nvim/init.vim" ]]; then
            log "INFO" "Creating Neovim configuration file..."
            
            # Basic Neovim config that includes .vimrc if it exists
            cat > "${HOME}/.config/nvim/init.vim" << 'EOF'
" Include Vim configuration if available
if filereadable(expand("~/.vimrc"))
    source ~/.vimrc
endif

" Neovim specific settings
set termguicolors           " Enable true color support
set inccommand=nosplit      " Show preview of substitutions in real-time

" Additional key mappings for Neovim
" Terminal mode mappings
tnoremap <Esc> <C-\><C-n>   " Escape to exit terminal mode

" Plugin settings (if plugins are installed)
" Add your plugin configurations here
EOF
        fi
    fi
    
    log "SUCCESS" "Neovim setup completed successfully"
    return 0
}

# Function to install Jupyter
function install_jupyter() {
    log "INFO" "Setting up Jupyter..."
    
    if check_command jupyter; then
        log "INFO" "Jupyter is already installed"
    else
        log "INFO" "Jupyter not found. Installing..."
        
        if [[ "${DRY_RUN}" != true ]]; then
            # Ensure pip is installed
            if ! check_command pip3; then
                log "INFO" "pip3 not found. Installing Python3 and pip3..."
                install_package "python3-pip" || {
                    log "ERROR" "Failed to install pip3"
                    return 1
                }
            fi
            
            # Install Jupyter using pip
            pip3 install jupyter notebook || {
                log "ERROR" "Failed to install Jupyter"
                return 1
            }
        fi
    fi
    
    log "SUCCESS" "Jupyter setup completed successfully"
    return 0
}