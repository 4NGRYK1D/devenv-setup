# DevEnvSetup - Usage Guide

This document provides detailed information on how to use the DevEnvSetup tool to configure your development environment.

## Basic Usage

The DevEnvSetup tool is designed to be simple to use with sensible defaults. Here are the basic commands:

```bash
# Clone the repository
git clone https://github.com/yourusername/devenv-setup.git
cd devenv-setup

# Make the script executable
chmod +x devenv-setup.sh

# Run with default settings
./devenv-setup.sh
```

## Command-Line Options

DevEnvSetup provides several command-line options to customize its behavior:

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message and exit |
| `-p, --profile PROFILE` | Specify the profile to use (default: default) |
| `-d, --dry-run` | Show what would be done without making changes |
| `-v, --verbose` | Enable verbose output |
| `--list-profiles` | List available profiles |

## Examples

### Running with a specific profile

```bash
./devenv-setup.sh --profile web_dev
```

This will set up a web development environment with tools like Node.js, npm, and related packages.

### Viewing what would be done without making changes

```bash
./devenv-setup.sh --dry-run
```

This will show you what the script would do without actually making any changes to your system.

### Running with verbose output

```bash
./devenv-setup.sh --verbose
```

This will show detailed information about what the script is doing.

### Combining options

```bash
./devenv-setup.sh --profile data_science --verbose
```

This will set up a data science environment with detailed output.

## Profiles

DevEnvSetup comes with several predefined profiles:

### Default Profile

The default profile installs basic development tools and configurations:

- Essential packages (git, vim, curl, etc.)
- Git configuration
- Vim configuration
- Bash aliases and prompt

### Web Development Profile

The web development profile installs tools for web development:

- All tools from the default profile
- Node.js and npm
- TypeScript, ESLint, Prettier
- VS Code with web development extensions
- Docker and Docker Compose

### Data Science Profile

The data science profile installs tools for data science and machine learning:

- All tools from the default profile
- Python and pip
- Jupyter Notebook
- NumPy, Pandas, Matplotlib, Scikit-learn
- R and common R packages
- Conda environment

## Customization

You can create your own profile by copying an existing one from the `config/profiles/` directory and modifying it:

```bash
cp config/profiles/default.conf config/profiles/my_custom_profile.conf
# Edit my_custom_profile.conf with your favorite editor
./devenv-setup.sh --profile my_custom_profile
```

### Profile Configuration Options

Here are some of the configuration options available in profile files:

#### Package Manager

```bash
SETUP_PACKAGE_MANAGER=true
ESSENTIAL_PACKAGES_DEBIAN=("git" "vim" "curl" ...)
ESSENTIAL_PACKAGES_REDHAT=("git" "vim" "curl" ...)
ESSENTIAL_PACKAGES_MACOS=("git" "vim" "curl" ...)
```

#### Git Configuration

```bash
SETUP_GIT=true
CONFIGURE_GIT=true
SETUP_GIT_ALIASES=true
GIT_USERNAME="Your Name"
GIT_EMAIL="your.email@example.com"
GIT_DEFAULT_BRANCH="main"
```

#### Editor Configuration

```bash
SETUP_EDITOR=true
DEFAULT_EDITOR="vim"
INSTALL_VSCODE=true
INSTALL_NEOVIM=false
SETUP_VIM_CONFIG=true
```

#### Programming Languages

```bash
SETUP_LANGUAGES=true
INSTALL_PYTHON=true
INSTALL_NODE=true
INSTALL_JAVA=false
PYTHON_GLOBAL_PACKAGES=("numpy" "pandas" "matplotlib")
NODE_GLOBAL_PACKAGES=("typescript" "prettier" "eslint")
```

## Logs

DevEnvSetup creates a log file at `devenv-setup.log` in the script directory. This file contains detailed information about what the script did, which can be useful for troubleshooting.

## Troubleshooting

If you encounter any issues while using DevEnvSetup, please check the following:

1. Make sure the script has executable permissions: `chmod +x devenv-setup.sh`
2. Check the log file for detailed error messages: `cat devenv-setup.log`
3. Try running with the `--verbose` option to see more detailed output
4. Make sure you have sudo access if installing system packages
5. If a specific module fails, you can modify your profile to disable that module and run the script again