#!/usr/bin/env bash
#
# DevEnvSetup - Git Configuration Module
# This module handles Git installation and configuration

# Function to set up Git
function setup_git() {
    log "INFO" "Setting up Git configuration..."
    
    # Check if Git is installed, otherwise install it
    if ! check_command git; then
        log "INFO" "Git not found. Installing Git..."
        install_package "git" || {
            log "ERROR" "Failed to install Git"
            return 1
        }
    else
        log "INFO" "Git is already installed"
    fi
    
    # Configure Git if enabled
    if [[ "${CONFIGURE_GIT}" == true && "${DRY_RUN}" != true ]]; then
        # Set username and email if provided
        if [[ -n "${GIT_USERNAME}" ]]; then
            log "INFO" "Setting Git username to '${GIT_USERNAME}'"
            git config --global user.name "${GIT_USERNAME}" || {
                log "ERROR" "Failed to set Git username"
                return 1
            }
        else
            # Prompt for username if not configured and not in dry-run mode
            read -p "Enter your Git username: " git_username
            git config --global user.name "${git_username}" || {
                log "ERROR" "Failed to set Git username"
                return 1
            }
        fi
        
        if [[ -n "${GIT_EMAIL}" ]]; then
            log "INFO" "Setting Git email to '${GIT_EMAIL}'"
            git config --global user.email "${GIT_EMAIL}" || {
                log "ERROR" "Failed to set Git email"
                return 1
            }
        else
            # Prompt for email if not configured and not in dry-run mode
            read -p "Enter your Git email: " git_email
            git config --global user.email "${git_email}" || {
                log "ERROR" "Failed to set Git email"
                return 1
            }
        fi
        
        # Set default branch name
        log "INFO" "Setting default branch name to '${GIT_DEFAULT_BRANCH}'"
        git config --global init.defaultBranch "${GIT_DEFAULT_BRANCH}" || {
            log "ERROR" "Failed to set default branch name"
            return 1
        }
        
        # Configure Git aliases
        log "INFO" "Setting up Git aliases..."
        if [[ "${SETUP_GIT_ALIASES}" == true ]]; then
            git config --global alias.co checkout || log "WARNING" "Failed to set Git alias: co"
            git config --global alias.br branch || log "WARNING" "Failed to set Git alias: br"
            git config --global alias.ci commit || log "WARNING" "Failed to set Git alias: ci"
            git config --global alias.st status || log "WARNING" "Failed to set Git alias: st"
            git config --global alias.unstage 'reset HEAD --' || log "WARNING" "Failed to set Git alias: unstage"
            git config --global alias.last 'log -1 HEAD' || log "WARNING" "Failed to set Git alias: last"
            git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit" || log "WARNING" "Failed to set Git alias: lg"
            log "SUCCESS" "Git aliases configured successfully"
        fi
        
        # Configure Git editor
        if [[ -n "${GIT_EDITOR}" ]]; then
            log "INFO" "Setting Git editor to '${GIT_EDITOR}'"
            git config --global core.editor "${GIT_EDITOR}" || {
                log "ERROR" "Failed to set Git editor"
                return 1
            }
        fi
    fi
    
    log "SUCCESS" "Git configuration completed successfully"
    return 0
}
