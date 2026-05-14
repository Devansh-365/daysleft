# Contributing to Days Left

Thank you for considering contributing to Days Left. This document provides guidelines and steps for contributing.

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report, please check existing issues to see if the problem has already been reported. When you create a bug report, include as many details as possible:

- macOS version
- Days Left version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- Clear description of the feature
- Why it would be useful
- How it should work
- Any examples or mockups

### Pull Requests

1. Fork the repository
2. Create a branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`make test`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

### Requirements

- macOS 13 or later
- Xcode 16 or later
- Swift 6

### Build

```bash
make build
```

### Test

```bash
make test
```

## Style Guidelines

- Follow Swift style conventions
- Use kebab-case for file names
- Add tests for new features
- Update documentation for API changes

## Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests liberally after the first line

## Questions?

Feel free to open an issue for any questions about contributing.
