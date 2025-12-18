#!/system/bin/sh
# Copy FixWdevineL1/* directory to /data/local/tmp
cp -r ./FixWdevineL1/* /data/local/tmp/

# Set correct permissions
chmod 777 /data/local/tmp/FixWdevineL1.sh
chmod 777 /data/local/tmp/attestation

# Set owner and group to root:root
chown root:root /data/local/tmp/FixWdevineL1.sh
chown root:root /data/local/tmp/attestation

# Execute the script
su -c sh /data/local/tmp/FixWdevineL1.sh
