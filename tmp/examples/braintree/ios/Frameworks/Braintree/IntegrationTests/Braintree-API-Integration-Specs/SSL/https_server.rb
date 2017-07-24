#!/usr/bin/env ruby
require 'webrick'
require 'webrick/https'
require 'openssl'

BEGIN { File.write("#{ $0 }.pid", $$) }
END { File.delete("#{ $0 }.pid") }

private_key_file = "#{__dir__}/good_site_key.pem"
cert_file = "#{__dir__}/good_site_cert.pem"
root_cert_file = "#{__dir__}/good_root_cert.pem"

pkey = OpenSSL::PKey::RSA.new(File.read(private_key_file))
cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
root_cert = OpenSSL::X509::Certificate.new(File.read(root_cert_file))

def log message
  puts "[https_server] #{message}"
end

good_server = WEBrick::HTTPServer.new(
  :BindAddress => '0.0.0.0',
  :Port => 9443,
  :Logger => WEBrick::Log::new(nil, WEBrick::Log::ERROR),
  :SSLEnable => true,
  :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate => cert,
  :SSLPrivateKey => pkey,
  :SSLExtraChainCert => [root_cert]
)
good_server.mount_proc '/' do |req, res|
    res.body = '{ "status": "ok", "server": "good" }'
    res.content_type = 'application/json'
end

evil_private_key_file = "#{__dir__}/evil_site_key.pem"
evil_cert_file = "#{__dir__}/evil_site_cert.pem"
evil_root_cert_file = "#{__dir__}/evil_root_cert.pem"

pkey = OpenSSL::PKey::RSA.new(File.read(evil_private_key_file))
cert = OpenSSL::X509::Certificate.new(File.read(evil_cert_file))
root_cert = OpenSSL::X509::Certificate.new(File.read(evil_root_cert_file))

evil_server = WEBrick::HTTPServer.new(
  :BindAddress => '0.0.0.0',
  :Port => 9444,
  :Logger => WEBrick::Log::new(nil, WEBrick::Log::ERROR),
  :SSLEnable => true,
  :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate => cert,
  :SSLPrivateKey => pkey,
  :SSLExtraChainCert => [root_cert]
)
evil_server.mount_proc '/' do |req, res|
    res.body = '{ "status": "ok", "server": "evil" }'
    res.content_type = 'application/json'
end

http_server = WEBrick::HTTPServer.new(
  :BindAddress => '0.0.0.0',
  :Port => 9445,
  :Logger => WEBrick::Log::new(nil, WEBrick::Log::ERROR),
  :SSLEnable => false,
)
http_server.mount_proc '/' do |req, res|
    res.body = '{ "status": "ok", "server": "non-ssl" }'
    res.content_type = 'application/json'
end

t1 = Thread.new do
  log 'Starting good server on :9443'
  $stdout.flush
  good_server.start
end

t2 = Thread.new do
  log 'Starting evil server on :9444'
  $stdout.flush
  evil_server.start
end

t3 = Thread.new do
  log 'Starting http server on :9445'
  $stdout.flush
  http_server.start
end

trap("INT") do
  log 'Shutting down...'
  t1.kill;
  t2.kill;
  t3.kill
end

t1.join
t2.join
t3.join
