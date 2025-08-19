#!/system/bin/sh
# Copy FixWdevineL1 directory to /data/local/tmp
cp -r "$(pwd)/FixWdevineL1" /data/local/tmp/

# Set correct permissions
chmod 777 /data/local/tmp/FixWdevineL1/FixWdevineL1.sh
chmod 777 /data/local/tmp/FixWdevineL1/attestation

# Set owner and group to root:root
chown root:root /data/local/tmp/FixWdevineL1/FixWdevineL1.sh
chown root:root /data/local/tmp/FixWdevineL1/attestation

# Execute the script
sh /data/local/tmp/FixWdevineL1/FixWdevineL1.sh