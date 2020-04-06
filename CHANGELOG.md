# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.3.1]

### Added

- Explicit dependencies to ensure kubeconfig and credentials are created after the cluster is ready.

## [0.3.0]

### Added

- Module to output tenant cluster kubeconfig and credentials.

### Changed

- Use nodepool node count to indicate cluster readiness.
- Require the use of the `shell_script` provider.

## [0.2.0]

### Added

- Module to wait until cluster is reported ready.

## [0.1.0]

### Added

- Initial commit.
