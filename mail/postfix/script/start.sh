#!/bin/bash

#Sendgrid configuration.
echo "smtp_sasl_auth_enable = yes" > /etc/postfix/main.cf
echo "smtp_sasl_password_maps = static:$USERNAME:$PASSWORD"  >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous"  >> /etc/postfix/main.cf
echo "smtp_tls_security_level = encrypt"  >> /etc/postfix/main.cf
echo "header_size_limit = 4096000" >> /etc/postfix/main.cf
echo "relayhost = [smtp.sendgrid.net]:587"  >> /etc/postfix/main.cf

postfix reload
