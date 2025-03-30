# DevEnvSetup - Contributing Guide

Thank you for your interest in contributing to DevEnvSetup! This guide will help you get started with contributing to the project.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We aim to create a welcoming and inclusive community for everyone.

## Getting Started

1. Fork the repository on GitHub.
2. Clone your fork to your local machine:
   ```bash
   git clone https://github.com/yourusername/devenv-setup.git
   cd devenv-setup
   ```

3. Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/originalowner/devenv-setup.git
   ```

4. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Running Tests

Before submitting a pull request, make sure all tests pass:

```bash
cd tests
./run_tests.sh
```

### Adding New Features

When adding new features, please follow these guidelines:

1. Create a new module in the `modules/` directory if appropriate.
2. Update the main script (`devenv-setup.sh`) if necessary.
3. Update default profile configurations in `config/profiles/`.
4. Add tests for your new feature in the `tests/` directory.
5. Update documentation in the `docs/` directory.

### Coding Style

- Use 4 spaces for indentation in Bash scripts.
- Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) for Bash scripting.
- Use descriptive function and variable names.
- Add comments to explain complex logic.
- Maintain error handling with appropriate log messages.
- Always use double brackets for conditionals: `[[ ... ]]` instead of `[ ... ]`.

### Commit Messages

- Use clear and descriptive commit messages.
- Start with a verb in the present tense (e.g., "Add", "Fix", "Update").
- Reference issue numbers if applicable.
- Keep the first line under 50 characters if possible.
- Use the extended description for more details if needed.

Example:
```
Add Docker Compose installation feature

- Add Docker Compose installation for Linux and macOS
- Update profiles to include Docker Compose option
- Add tests for Docker Compose installation
- Update documentation with Docker Compose options

Fixes #42
```

## Pull Request Process

1. Make sure your changes are committed to your feature branch.
2. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. Go to the original repository on GitHub and create a pull request from your branch.
4. Include a clear description of the changes and any relevant issue numbers.
5. Wait for the maintainers to review your pull request and address any feedback.

## Adding New Profiles

If you want to contribute a new profile:

1. Create a new file in `config/profiles/` with a descriptive name.
2. Base it on existing profiles for consistency.
3. Document the profile in `docs/usage.md`.
4. Add the profile to the README.md list of available profiles.

## Adding New Modules

If you want to contribute a new module:

1. Create a new file in `modules/` with a descriptive name.
2. Implement the main setup function and any helper functions.
3. Add appropriate logging and error handling.
4. Update the main script to include your module.
5. Add configuration options to the profiles.
6. Add tests for your module.
7. Document the module in `docs/configuration.md`.

## Reporting Issues

If you find a bug or have a feature request, please open an issue on GitHub. Include as much detail as possible:

- For bugs: OS version, exact steps to reproduce, expected outcome, and actual outcome.
- For feature requests: detailed description of the feature and why it would be valuable.

## License

By contributing to DevEnvSetup, you agree that your contributions will be licensed under the project's MIT License.