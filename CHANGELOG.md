# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.4.0]

### Added

- Require Terraform version 0.12.0 or greater.
- Optionally create a self-contained `kubeconfig` with inline certs.

### Changed

- Change name of tenant cluster credentials module to better reflect purpose.

## [0.3.1]

### Changed

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
