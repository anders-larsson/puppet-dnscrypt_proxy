# dnscrypt_proxy

Install, configure and manage dnscrypt-proxy service.

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with dnscrypt_proxy](#setup)
    * [What dnscrypt_proxy affects](#what-dnscrypt_proxy-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dnscrypt_proxy](#beginning-with-dnscrypt_proxy)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Manage dnscrypt-proxy package, configuration file and service and protect your
DNS queries from being sent in the clear over the Internet to DNS servers.

## Setup

### Beginning with dnscrypt_proxy

Simplest would be to enable the class without setting any parameters.
This will implement the default configuration shipped by dnscrypt-proxy and will
automatically select dnscrypt and DNS-over-HTTPS (DoH) servers with suitable
latency.

## Usage

### Setting servers to use

It is possible to set the servers you want dnscrypt-proxy to utilise.
```puppet
class { 'dnscrypt-proxy':
    server_names => ['google', 'cloudflare']
}
```
or in hiera
```yaml
dnscrypt_proxy::servers:
  - google
  - cloudflware
```

## Limitations

All configuration options are currently not managed. Currently only
written to suport systemd and only Gentoo Linux is tested.

Support for other operating systems should be possible with hiera
values. Pull requests are welcome.

## Development

Follow best practices, use same style as already used in the module.
Don't forget to add unit tests for whatever functionality you add!
