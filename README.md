# Dotfiles

Stores dotfiles and an ansible playbook to provision the local machine.
This is meant to provision a fedora workstation.

Dotfiles are stored in the [`files/dotfiles/`](/files/dotfiles/) directory.

## Usage

To provision the machine, clone the repo, then run :

```bash
$ ./setup-machine.sh
```

It will install ansible and use it to provision the machine.

Then, reboot.

## Options

There is a [`vars/localhost.yml.dist`](/vars/localhost.yml.dist) file which is
copied to the actual file used by ansible during the first machine setup.

You can copy this file first and adjust the options before provisioning the
machine.

## Provisioning a specific task

Each ansible task is tagged so it can be played again by specifying the tag :

```bash
$ ansible-playbook \
    -i hosts \
    -l localhost \
    playbook.yml \
    --ask-become-pass \
    -t <tag_name>
```
