#!/usr/bin/env zsh

set -ve

# Make Good Root CA with new key
openssl req -new -newkey rsa:1024 -keyout good_root_key.pem -nodes -x509 -days 36500 -out good_root_cert.pem -subj "/C=CA/ST=California/O=All That is Good/OU=All That is Good Root CA" -text

# Make Good Site Req with new key
openssl req -new -newkey rsa:1024 -keyout good_site_key.pem -nodes -days 36500 -out good_site_request.pem -subj "/C=CA/ST=California/O=All That is Good/OU=All That is Good Site/CN=localhost" -text

# Sign Good Site Req with new key
openssl x509 -in good_site_request.pem -req -CA good_root_cert.pem -CAkey good_root_key.pem -days 36500 -set_serial 1 -out good_site_cert.pem -text

# Make Evil Root CA with new key
openssl req -new -newkey rsa:1024 -keyout evil_root_key.pem -nodes -x509 -days 36500 -out evil_root_cert.pem -subj "/C=CA/ST=California/O=All That is Evil/OU=All That is Evil Root CA" -text

# Make Evil Site Req with new key
openssl req -new -newkey rsa:1024 -keyout evil_site_key.pem -nodes -days 36500 -out evil_site_request.pem -subj "/C=CA/ST=California/O=All That is Evil/OU=All That is Evil Site/CN=*" -text

# Sign Evil Site Req with new key
openssl x509 -in evil_site_request.pem -req -CA evil_root_cert.pem -CAkey evil_root_key.pem -days 36500 -set_serial 1 -out evil_site_cert.pem -text

# Encode certificates for iOS Specs
openssl x509 -in good_root_cert.pem -inform pem -out good_root_cert.der -outform der

set +v
echo '============================='
echo Verifying newly created certs
echo '============================='

# Verify
openssl verify -verbose -purpose sslclient -CAfile good_root_cert.pem good_site_cert.pem
openssl verify -verbose -purpose sslclient -CAfile evil_root_cert.pem good_site_cert.pem

openssl verify -verbose -purpose sslclient -CAfile good_root_cert.pem evil_site_cert.pem
openssl verify -verbose -purpose sslclient -CAfile evil_root_cert.pem evil_site_cert.pem
