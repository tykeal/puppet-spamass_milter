# spamass_milter

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with spamass_milter](#setup)
    * [What spamass_milter affects](#what-spamass_milter-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with spamass_milter](#beginning-with-spamass_milter)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description
[![Build
Status](https://gitlab.com/tykeal/puppet-spamass_milter/badges/main/pipeline.svg)](https://gitlab.com/tykeal/puppet-spamass_milter/-/tree/main)

This module installs and configures spamass-milter on a system. By default it
sets up exactly the same configuration that just installing the packages would
install. It defaults to installing the spamass-milter-postfix integration at the
same time.

## Setup

### What spamass_milter affects

### Setup Requirements

* `puppetlabs/stdlib` is required for this module to work

### Beginning with spamass_milter

This module is designed to "just work". Configuration is done against the
following hiera locations:

* `spamass_milter::install`
* `spamass_milter::config`
* `spamass_milter::service`

## Usage

To use, simply do the following:

```puppet
include ::spamass_milter
```

## Limitations

This module is presently only developed for RedHat and CentOS 8 systems. It may
work on 7.

Other distros are welcome to open Merge Requests

## Development

Development for this module is happening at
https://gitlab.com/tykeal/puppet-spamass_milter

To contribue please open a Merge request

A [DCO](https://developercertificate.org/) line indicated by a Signed-off-by
line in the commit footer of _every_ commit of a patch series, not just your
merge reuqest is _required_. If any of the commits in the series do not contain
this, the request will be rejected.
