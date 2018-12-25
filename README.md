# Remote command
Prefix a command with `rcmd` to excecute it in a remote virtual environment.

## Install
```bash
/bin/sh <(curl -s https://raw.githubusercontent.com/dergoegge/rcmd/master/install.sh)
```

## Usage

To execute a command in a remote environment:
```bash
rcmd "<command>"
```
This will automatically start a machine according to your Vagrantfile if it is not running already and then run your command. The established connection will be cached so subsequent calls are fast. 

## Providers
Configure `rcmd` with your provider of choice:

```bash
rcmd --configure provider <provider>
```

If the command completes succesfully it generated a `Vagrantfile` template in the calling directory for your chosen provider.
This file will have to be edited with your provider info.


You can set up a default environment for your favourite provider in the `~/.rcmd/env` directory with:
```bash
rcmd --configure default-env <provider>
```

You can copy the default environment to your current location with:
```bash
rcmd --init
```

or create a `Vagrantfile` from one of the provider templates with:

```bash
rcmd --init <provider>
```
Currently supported providers are `google` and `aws` using the vagrant plugins [vagrant-google](https://github.com/mitchellh/vagrant-google) and [vagrant-aws](https://github.com/mitchellh/vagrant-aws).

*If no provider is configured the default `vagrant` provider is used.*

## Autocompletion

Enable autocompletion by:
```bash
source ~/.rcmd/cli/autocompletion.sh
```

Currently the first word behind `rcmd` will autocomplete to a command available on the remote machine, everything after that will autocomplete to files and dirs.
