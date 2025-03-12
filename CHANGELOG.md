# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v10.1.0](https://github.com/treydock/puppet-module-globus/tree/v10.1.0) (2025-03-12)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v10.0.0...v10.1.0)

### Added

- Support Debian 12 [\#46](https://github.com/treydock/puppet-module-globus/pull/46) ([treydock](https://github.com/treydock))

### Fixed

- Only manage mod\_auth\_openidc for RHEL8 [\#45](https://github.com/treydock/puppet-module-globus/pull/45) ([treydock](https://github.com/treydock))

## [v10.0.0](https://github.com/treydock/puppet-module-globus/tree/v10.0.0) (2023-11-29)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v9.0.0...v10.0.0)

### Changed

- Updates to support Globus Connect Server 5.4.61+ [\#41](https://github.com/treydock/puppet-module-globus/pull/41) ([treydock](https://github.com/treydock))
- Major updates, see description [\#40](https://github.com/treydock/puppet-module-globus/pull/40) ([treydock](https://github.com/treydock))

## [v9.0.0](https://github.com/treydock/puppet-module-globus/tree/v9.0.0) (2023-03-17)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v8.0.0...v9.0.0)

### Changed

- Updates - Including drop Debian 9 support [\#36](https://github.com/treydock/puppet-module-globus/pull/36) ([treydock](https://github.com/treydock))

## [v8.0.0](https://github.com/treydock/puppet-module-globus/tree/v8.0.0) (2022-08-10)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v7.0.0...v8.0.0)

### Changed

- Require python module \>= 6.3.0 [\#34](https://github.com/treydock/puppet-module-globus/pull/34) ([treydock](https://github.com/treydock))

### Added

- Set allowed puppet-epel version to \< 5.0.0 [\#32](https://github.com/treydock/puppet-module-globus/pull/32) ([yorickps](https://github.com/yorickps))

### Fixed

- Fix ensure\_packages usage [\#33](https://github.com/treydock/puppet-module-globus/pull/33) ([treydock](https://github.com/treydock))

## [v7.0.0](https://github.com/treydock/puppet-module-globus/tree/v7.0.0) (2022-04-05)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v6.0.1...v7.0.0)

### Changed

- Replace CentOS 8 with Rocky 8 [\#31](https://github.com/treydock/puppet-module-globus/pull/31) ([treydock](https://github.com/treydock))
- Move globus-timer-cli into dedicated class to avoid conflicts with globus-cli [\#30](https://github.com/treydock/puppet-module-globus/pull/30) ([treydock](https://github.com/treydock))

## [v6.0.1](https://github.com/treydock/puppet-module-globus/tree/v6.0.1) (2022-04-04)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v6.0.0...v6.0.1)

### Fixed

- Fix execution condition of Exec\['globus-node-setup'\] [\#29](https://github.com/treydock/puppet-module-globus/pull/29) ([cmd-ntrf](https://github.com/cmd-ntrf))

## [v6.0.0](https://github.com/treydock/puppet-module-globus/tree/v6.0.0) (2021-09-07)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v5.2.0...v6.0.0)

### Changed

- Drop Puppet 5 support, add Puppet 7 [\#25](https://github.com/treydock/puppet-module-globus/pull/25) ([treydock](https://github.com/treydock))

### Added

- Support globus::cli and globus::sdk on ubuntu 20.04 [\#28](https://github.com/treydock/puppet-module-globus/pull/28) ([treydock](https://github.com/treydock))
- Update module dependency ranges [\#27](https://github.com/treydock/puppet-module-globus/pull/27) ([treydock](https://github.com/treydock))
- Support installing globus-timer-cli [\#24](https://github.com/treydock/puppet-module-globus/pull/24) ([treydock](https://github.com/treydock))

### Fixed

- Fix node setup fact and only run gcs\_manager once node is actually setup [\#26](https://github.com/treydock/puppet-module-globus/pull/26) ([treydock](https://github.com/treydock))

## [v5.2.0](https://github.com/treydock/puppet-module-globus/tree/v5.2.0) (2020-12-29)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v5.1.0...v5.2.0)

### Added

- Add globus\_info fact [\#23](https://github.com/treydock/puppet-module-globus/pull/23) ([treydock](https://github.com/treydock))

## [v5.1.0](https://github.com/treydock/puppet-module-globus/tree/v5.1.0) (2020-12-29)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v5.0.0...v5.1.0)

### Added

- Use Python 3 for globus::cli and globus::sdk [\#22](https://github.com/treydock/puppet-module-globus/pull/22) ([treydock](https://github.com/treydock))

## [v5.0.0](https://github.com/treydock/puppet-module-globus/tree/v5.0.0) (2020-12-14)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v4.2.0...v5.0.0)

### Changed

- Rename repo baseurl parameters [\#18](https://github.com/treydock/puppet-module-globus/pull/18) ([treydock](https://github.com/treydock))
- BREAKING Switch default to Globus v5.4, numerous parameter changes [\#17](https://github.com/treydock/puppet-module-globus/pull/17) ([treydock](https://github.com/treydock))

### Added

- Use python3 for EL8 python installs [\#20](https://github.com/treydock/puppet-module-globus/pull/20) ([treydock](https://github.com/treydock))
- Support Debian and Ubuntu [\#19](https://github.com/treydock/puppet-module-globus/pull/19) ([treydock](https://github.com/treydock))

### Fixed

- Fix globus-connect-server setup commands for Globus v5.4 [\#21](https://github.com/treydock/puppet-module-globus/pull/21) ([treydock](https://github.com/treydock))

## [v4.2.0](https://github.com/treydock/puppet-module-globus/tree/v4.2.0) (2020-11-18)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v4.1.0...v4.2.0)

### Added

- Improve globus::cli and add globus::sdk [\#15](https://github.com/treydock/puppet-module-globus/pull/15) ([treydock](https://github.com/treydock))

## [v4.1.0](https://github.com/treydock/puppet-module-globus/tree/v4.1.0) (2019-11-14)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v4.0.0...v4.1.0)

### Added

- Add testing repos that are disabled [\#13](https://github.com/treydock/puppet-module-globus/pull/13) ([treydock](https://github.com/treydock))

## [v4.0.0](https://github.com/treydock/puppet-module-globus/tree/v4.0.0) (2019-10-30)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v3.0.1...v4.0.0)

### Changed

- Support Globus v5 [\#10](https://github.com/treydock/puppet-module-globus/pull/10) ([treydock](https://github.com/treydock))

### Added

- Use module Hiera data [\#12](https://github.com/treydock/puppet-module-globus/pull/12) ([treydock](https://github.com/treydock))
- Add globus CLI class [\#11](https://github.com/treydock/puppet-module-globus/pull/11) ([treydock](https://github.com/treydock))

## [v3.0.1](https://github.com/treydock/puppet-module-globus/tree/v3.0.1) (2019-07-09)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/v3.0.0...v3.0.1)

### Fixed

- Fix repo URLs [\#9](https://github.com/treydock/puppet-module-globus/pull/9) ([treydock](https://github.com/treydock))

## [v3.0.0](https://github.com/treydock/puppet-module-globus/tree/v3.0.0) (2019-05-15)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/2.1.0...v3.0.0)

### Changed

- Use datatypes for all parameters [\#6](https://github.com/treydock/puppet-module-globus/pull/6) ([treydock](https://github.com/treydock))

### Added

- Use PDK [\#8](https://github.com/treydock/puppet-module-globus/pull/8) ([treydock](https://github.com/treydock))
- Use puppet strings [\#7](https://github.com/treydock/puppet-module-globus/pull/7) ([treydock](https://github.com/treydock))
- Support Puppet 5 and 6 and update module dependency versions [\#5](https://github.com/treydock/puppet-module-globus/pull/5) ([treydock](https://github.com/treydock))

## [2.1.0](https://github.com/treydock/puppet-module-globus/tree/2.1.0) (2019-05-14)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/2.0.1...2.1.0)

### Added

- Use beaker4 and update some module development files [\#4](https://github.com/treydock/puppet-module-globus/pull/4) ([treydock](https://github.com/treydock))
- add setting of MyProxy CaSubjectDN [\#3](https://github.com/treydock/puppet-module-globus/pull/3) ([gtallan](https://github.com/gtallan))
- Allow epel management to be disabled [\#2](https://github.com/treydock/puppet-module-globus/pull/2) ([treydock](https://github.com/treydock))

## [2.0.1](https://github.com/treydock/puppet-module-globus/tree/2.0.1) (2017-10-28)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/2.0.0...2.0.1)

## [2.0.0](https://github.com/treydock/puppet-module-globus/tree/2.0.0) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/1.0.0...2.0.0)

## [1.0.0](https://github.com/treydock/puppet-module-globus/tree/1.0.0) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/0.0.1...1.0.0)

## [0.0.1](https://github.com/treydock/puppet-module-globus/tree/0.0.1) (2017-10-26)

[Full Changelog](https://github.com/treydock/puppet-module-globus/compare/a843d995675de61f54888d6187a004fe842626a3...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
