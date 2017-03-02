# retrypuppet

#### Table of Contents

1. [Description](#description)
1. [The Problem](#the-problem)
1. [The Solution](#the-solution)
1. [Contributors](#contributors)

## Description
Provides a simple python based wrapper script around calls to `puppet agent` to automatically retry in the event that a run is already in progress.

## The Problem
Where the puppet agent is polling at a high frequency, whether in "apply" mode or "noop" mode for audit purposes, it is likely that any manual agent run will clash with the agent already running in the background.  This can be especially irritating where an orchestration tool such as mCollective or Salt is used to run puppet - perhaps as part of a deployment process.

```
# puppet agent -tv
Notice: Run of Puppet configuration client already in progress; skipping  (/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock exists)
```

## The Solution
The `retrypuppet` wrapper script is called in place of the `puppet` binary.  The script passes any arguments specified on its command-line directly to the `puppet` binary and passes any output from the puppet binary on its standard output (note that any agent output to stderr will be flattened to stdout).  If the puppet agent returns a notice that a run is already in progress, then the script will wait for a 30 second back-off period before trying again.  To reduce noise, `retrypuppet` will not display any output from a blocked run other than a notice.

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
