# Remote command
Prefix a command with `rcmd` to excecute it in a remote virtual environment.

## Install
```bash
/bin/sh <(curl -s https://raw.githubusercontent.com/dergoegge/rcmd/master/install.sh)
```

## Providers
Configure `rcmd` with your provider of choice:

```bash
rcmd --configure provider <provider>
```

If the command completes succesfull it generated a `Vagrantfile` template in the `~/.rcmd/env` directory for your chosen provider.
This file will have to be edited with your provider info.

The environment in `~/.rcmd/env` will be used by `rcmd` as your default if there is no Vagrantfile present in the calling directory. 

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

