# @summary Manage dnscrypt-proxy
#
# Install, manage configuration and service for service dnscrypt-proxy
#
# @example
#   include dnscrypt_proxy
#
# @param package_name
#   Package name
#
# @param service_name
#   Service name
#
# @param config_path
#   Path to configuration file
#
# @param listen_addresses
#   List of local addresses and ports to listen to
#
# @param max_clients
#   Maximum number of simultaneous client connections to accept
#
# @param ipv4_servers
#   Use servers reachable over IPv4
#
# @param ipv6_servers
#   Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectiviy
#
# @param dnscrypt_servers
#   Use servers implementing the DNSCrypt protocol
#
# @param doh_servers
#   Use servers implementing the DNS-over-HTTPS protocol
#
# @param odoh_servers
#   Use servers implementing the Oblivious DoH protocol
#
# @param require_dnssec
#   Server must support DNS security extensions (DNSSEC)
#
# @param require_nolog
#   Server must not log user queries (declarative)
#
# @param require_nofilter
#   Server must not enforce its own blocklist (for parental control, ads blocking...)
#
# @param force_tcp
#   Always use TCP to connect to upstream servers
#
# @param http3
#   Enable support for HTTP/3 (HTTP over QUIC)
#
# @param http3_probe
#   When http3 is true, always try HTTP/3 first for DoH server
#
# @param timeout
#   How long a DNS query will wait for a response, in milliseconds.
#
# @param keepalive
#   Keepalive for HTTP (HTTPS, HTTP/2, HTTP/3) queries, in seconds
#
# @param disabled_server_names
#   Server names to avoid even if they match all criteria
#
# @param server_names
#   Switch to a different system user after listening sockets have been created
#
# @param user_name
#   List of servers to use
class dnscrypt_proxy (
  String[1] $package_name,
  String[1] $service_name,
  Stdlib::Absolutepath $config_path,
  Array[String[1]] $listen_addresses,
  Integer[1] $max_clients,
  Boolean $ipv4_servers,
  Boolean $ipv6_servers,
  Boolean $dnscrypt_servers,
  Boolean $doh_servers,
  Boolean $odoh_servers,
  Boolean $require_dnssec,
  Boolean $require_nolog,#
  Boolean $require_nofilter,
  Boolean $force_tcp,
  Boolean $http3,
  Boolean $http3_probe,
  Integer[5000] $timeout,
  Integer $keepalive,
  Array[String[1]] $disabled_server_names = [],
  Optional[Array[String[1]]] $server_names = undef,
  Optional[String[1]] $user_name = undef,
) {
  package { 'dnscrypt-proxy':
    ensure => 'installed',
    name   => $package_name,
  }

  file { 'dnscrypt-proxy.toml':
    ensure  => 'file',
    path    => $config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('dnscrypt_proxy/dnscrypt-proxy.toml.epp',
      {
        server_names          => $server_names,
        listen_addresses      => $listen_addresses,
        max_clients           => $max_clients,
        ipv4_servers          => $ipv4_servers,
        ipv6_servers          => $ipv6_servers,
        dnscrypt_servers      => $dnscrypt_servers,
        doh_servers           => $doh_servers,
        odoh_servers          => $odoh_servers,
        require_dnssec        => $require_dnssec,
        require_nofilter      => $require_nofilter,
        require_nolog         => $require_nolog,
        disabled_server_names => $disabled_server_names,
        force_tcp             => $force_tcp,
        http3                 => $http3,
        http3_probe           => $http3_probe,
        timeout               => $timeout,
        keepalive             => $keepalive,
        user_name             => $user_name,
      }
    ),
    require => Package['dnscrypt-proxy'],
  }

  service { 'dnscrypt-proxy':
    ensure  => 'running',
    enable  => true,
    name    => $service_name,
    require => File['dnscrypt-proxy.toml'],
  }
}
