#!/bin/sh

# set timezone with TZ
# eg. TZ=America/Toronto
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Download the list of primary root servers.
# Unbound ships its own list but we can also download the most recent list and
# update it whenever we think it is a good idea. Note: there is no point in
# doing it more often then every 6 months.
echo "Download the list of primary root servers..."
curl https://www.internic.net/domain/named.root -o "/opt/unbound/etc/unbound/root.hints"

echo "Update the root trust anchor for DNSSEC validation..."
/opt/unbound/sbin/unbound-anchor -a "/opt/unbound/etc/unbound/root.key"

echo "Take ownership of the unbound configuration directory..."
chown -R unbound:unbound "/opt/unbound/etc/unbound"

echo "Start the unbound daemon..."
/opt/unbound/sbin/unbound -d -c "/opt/unbound/etc/unbound/unbound.conf"