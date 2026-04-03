# frozen_string_literal: true

require 'spec_helper'

describe 'dnscrypt_proxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:package_name) do
        case os_facts[:os]['family']
        when 'Gentoo' then 'net-dns/dnscrypt-proxy'
        else 'dnscrypt-proxy'
        end
      end

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_package('dnscrypt-proxy')
          .with_ensure('installed')
          .with_name(package_name)
      end

      it do
        is_expected.to contain_file('dnscrypt-proxy.toml')
          .with_ensure('file')
          .with_path('/etc/dnscrypt-proxy/dnscrypt-proxy.toml')
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
          .with_content(File.read('spec/fixtures/files/dnscrypt-proxy.toml'))
          .that_requires('Package[dnscrypt-proxy]')
      end

      it do
        is_expected.to contain_service('dnscrypt-proxy')
          .with_ensure('running')
          .with_enable(true)
          .with_name('dnscrypt-proxy')
          .that_requires('File[dnscrypt-proxy.toml]')
      end
    end

    context 'with param package_name set to "dnscrypt-package"' do
      let(:params) { { package_name: 'dnscrypt-package' } }

      it { is_expected.to contain_package('dnscrypt-proxy').with_name('dnscrypt-package') }
    end

    context 'with param service_name set to "dnscrypt-proy.service"' do
      let(:params) { { service_name: 'dnscrypt-proxy.service' } }

      it { is_expected.to contain_service('dnscrypt-proxy').with_name('dnscrypt-proxy.service') }
    end

    context 'with param config_path set to "/etc/dnscrypt-proxy.toml"' do
      let(:params) { { config_path: '/etc/dnscrypt-proxy.toml' } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_path('/etc/dnscrypt-proxy.toml') }
    end

    context 'with param listen_addresses set to ["127.0.0.1:53", "192.168.1.53:53"]' do
      let(:params) { { listen_addresses: ['127.0.0.1:53', '192.168.1.53:53'] } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^listen_addresses = \['127.0.0.1:53', '192.168.1.53:53'\]$}) }
    end

    context 'with param max_clients set to 500' do
      let(:params) { { max_clients: 500 } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^max_clients = 500$}) }
    end

    %w[ipv4_servers ipv6_servers dnscrypt_servers doh_servers odoh_servers require_dnssec
       require_nolog require_nofilter force_tcp http3 http3_probe].each do |service|
      [false, true].each do |boolean|
        context "with param #{service} set to #{boolean}" do
          let(:params) { { "#{service}": boolean } }

          it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^#{service} = #{boolean}$}) }
        end
      end
    end

    context 'with param timeout set to 10000' do
      let(:params) { { timeout: 10_000 } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^timeout = 10000$}) }
    end

    context 'with param keepalive set to 20' do
      let(:params) { { keepalive: 20 } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^keepalive = 20$}) }
    end

    context 'with param disabled_server_names set to ["google", "google-ipv6"]' do
      let(:params) { { disabled_server_names: %w[badserver1 badserver2] } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^disabled_server_names = \['badserver1', 'badserver2'\]$}) }
    end

    context 'with param server_names set to ["mullvad-doh", "google-ipv6"]' do
      let(:params) { { server_names: %w[mullvad-doh njalla-doh] } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^server_names = \['mullvad-doh', 'njalla-doh'\]$}) }
    end

    context 'with param user_name set to "dnscrypt-proxy"' do
      let(:params) { { user_name: 'dnscrypt-proxy' } }

      it { is_expected.to contain_file('dnscrypt-proxy.toml').with_content(%r{^user_name = 'dnscrypt-proxy'$}) }
    end
  end
end
