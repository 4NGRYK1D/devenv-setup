# DevEnvSetup

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

A powerful bash utility to quickly set up development environments across different machines.

## Features

- **Profile-based Configuration**: Choose from predefined development profiles (web dev, data science, etc.) or create your own
- **Cross-platform Support**: Works on most Unix-like systems (Linux, macOS)
- **Customizable**: Easily extend with your own modules and configurations
- **Smart Detection**: Automatically detects installed software to avoid redundant operations
- **Git Configuration**: Set up your git identity, aliases, and preferences
- **Editor Configuration**: Configure popular editors like VS Code, Vim, etc.
- **Docker Setup**: Install and configure Docker if needed
- **Programming Language Setup**: Install and configure multiple programming languages

## Quick Start

```bash
# Clone the repository
git clone https://github.com/RadinRabiee/devenv-setup.git
cd devenv-setup

# Make the script executable
chmod +x devenv-setup.sh

# Run with default settings
./devenv-setup.sh

# Run with a specific profile
./devenv-setup.sh --profile web_dev

# See all available options
./devenv-setup.sh --help
```

## Available Profiles

- **default**: Basic development tools and configurations
- **web_dev**: Web development environment (Node.js, npm, etc.)
- **data_science**: Data science environment (Python, Jupyter, etc.)

## Customization

Create your own profile by copying an existing one from the `config/profiles/` directory and modifying it according to your needs.

```bash
cp config/profiles/default.conf config/profiles/my_custom_profile.conf
# Edit my_custom_profile.conf with your favorite editor
./devenv-setup.sh --profile my_custom_profile
```

## Project Structure

```
devenv-setup/
├── devenv-setup.sh          # Main script
├── modules/                 # Individual components of the setup
├── config/                  # Configuration files and profiles
├── tests/                   # Test scripts
└── docs/                    # Documentation
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Author

Created by Radin Rabiee on Sunday, March 30, 2025.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.
