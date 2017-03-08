# retrypuppet

[![Build Status](https://img.shields.io/travis/aolabs/puppet-retrypuppet/master.svg)](https://travis-ci.org/aolabs/puppet-retrypuppet)
[![Coverage](https://img.shields.io/coveralls/aolabs/puppet-retrypuppet.svg)](https://coveralls.io/github/aolabs/puppet-retrypuppet)
[![GitHub Issues](https://img.shields.io/github/issues/aolabs/puppet-retrypuppet.svg)](https://github.com/aolabs/puppet-retrypuppet/issues)
[![Puppet Forge Version](http://img.shields.io/puppetforge/v/aolabs/retrypuppet.svg)](https://forge.puppetlabs.com/aolabs/retrypuppet)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/aolabs/retrypuppet.svg)](https://forge.puppetlabs.com/aolabs/retrypuppet)
[![Maintained by AO Labs](https://img.shields.io/badge/by-aolabs-blue.svg)](https://aolabs.nz)

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Contributors](#contributors)
1. [ChangeLog](#changelog)

## Description
Provides a simple python based wrapper script around `puppet agent` to automatically retry in the event that a run is already in progress.

Where the puppet agent is polling at a high frequency, whether in "apply" mode or "noop" mode for audit purposes, it is likely that any manual agent run will clash with the agent already running in the background.  This can be especially irritating where an orchestration tool such as mCollective or Salt is used to run puppet - perhaps as part of a deployment process.
```shell
# puppet agent -tv
Notice: Run of Puppet configuration client already in progress; skipping  (/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock exists)
```

## Usage
Add the below to your manifests for any machine on which you want to run `puppet agent`:
```puppet
class { '::retrypuppet': }
```

Then simply use the `retrypuppet` wrapper script in place of the `puppet` binary.  The script passes any arguments specified on its command-line directly to the `puppet` binary, passes any output from the puppet binary on its standard output (note that any agent output to stderr will be flattened to stdout), and will return Puppet's returncode as its returncode.  If the agent returns a notice that a run is already in progress, then `retrypuppet` will wait for a 30 second back-off period before trying again.  After 10 "blocked" attempts, `retrypuppet` will exit returning 11 (EAGAIN).  To reduce noise, `retrypuppet` will not display any output from a blocked run other than a notice.

```
# retrypuppet agent -tv
Run already in progress, will retry in 30 seconds, 9 attempts remain...
Run already in progress, will retry in 30 seconds, 8 attempts remain...
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Loading facts
Info: Caching catalog for centos-puppet.localdomain
Info: Applying configuration version '1488412377'
Notice: Applied catalog in 1.14 seconds
```

## Contributors
Original module authored by Patrick Brennan and released under the LGPLv3 license courtesy of Hapara LLC.  Ongoing maintenance by AO Labs courtesy of Patrick Brennan.

## ChangeLog
* 1.1.0 Documentation updates, Travis-CI test integration, return puppet's return code (issue #45).
* 1.0.1 Support Python 2 and 3.
* 1.0.0 Initial release, Python 3 only.
