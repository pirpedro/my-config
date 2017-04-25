# my config

A set of useful shell script tools to aid in configuring environments.
Works in debian-like distros (ubuntu, etc.) and OSX distros.

## Testing

###Prerequisites

You need to install [`bats - Bash Automated Testing System`](https://github.com/sstephenson/bats).

Our test scripts uses [`vagrant`](https://www.vagrantup.com/) to virtualize the test environment.

(__PS:__ `my config` has a recipe for vagrant installation)

####Ubuntu bats installation
Run these in your terminal:
```
sudo add-apt-repository ppa:duggan/bats --yes
sudo apt-get update -qq
sudo apt-get install -qq bats
```

####OSX bats installation
Install [`homebrew - a package manager for macOS`](https://brew.sh) if you didn't have already.
(__PS:__ `my config` has as recipe for homebrew installation too, don't worry :P)

and run this in your terminal:
```
brew install bats
```

###Running the suite
Use one of the scripts located in `test` folder.
-   `run_core_tests.sh` - cover the internal functions and external commands execution.
-   `run_installation_tests.sh` - cover all process of installation.
-   `run_all_tests.sh` - execute all previously scripts.

### Built with
-   [bats - Bash Automated Testing System](https://github.com/sstephenson/bats).
-   [bats-support](https://github.com/ztombol/bats-support)
-   [bats-assert](https://github.com/ztombol/bats-assert)
-   [vagrant](https://www.vagrantup.com/)



Go back to [readme](../README.md) for installation steps and usage examples.
