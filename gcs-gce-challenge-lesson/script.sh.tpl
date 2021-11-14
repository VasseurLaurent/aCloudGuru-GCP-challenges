# https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/troubleshooting

#! /bin/bash

#
# Echo commands as they are run, to make debugging easier.
# GCE startup script output shows up in "/var/log/syslog" .
#
set -x


#
# Stop apt-get calls from trying to bring up UI.
#
export DEBIAN_FRONTEND=noninteractive


#
# Make sure installed packages are up to date with all security patches.
#
sudo apt-get -yq update
sudo apt-get -yq upgrade


#
# Install Google's Stackdriver logging agent, as per
# https://cloud.google.com/logging/docs/agent/installation
#

:> agents_to_install.csv && \
echo '"projects/${project}/zones/${region}/instances/${machine}","[{""type"":""ops-agent""}]"' >> agents_to_install.csv && \
curl -sSO https://dl.google.com/cloudagents/mass-provision-google-cloud-ops-agents.py 
mv mass-provision-google-cloud-ops-agents.py /home/${user}/mass-provision-google-cloud-ops-agents.py
mv agents_to_install.csv /home/${user}/agents_to_install.csv
chown ${user}:${user} /home/${user}/mass-provision-google-cloud-ops-agents.py
chown ${user}:${user} /home/${user}/agents_to_install.csv
cd /home/${user}
sudo -u ${user} python3 /home/${user}/mass-provision-google-cloud-ops-agents.py --file /home/${user}/agents_to_install.csv


#
# Install and run the "stress" tool to max the CPU load for a while.
#
sudo apt-get -yq install stress
sudo stress -c 8 -t 10


#
# Report that we're done.
#

# Metadata should be set in the "lab-logs-bucket" attribute using the "gs://mybucketname/" format.
log_bucket_metadata_name=lab-logs-bucket
log_bucket_metadata_url="http://metadata.google.internal/computeMetadata/v1/instance/attributes/$${log_bucket_metadata_name}"
worker_log_bucket=$(curl -H "Metadata-Flavor: Google" "$${log_bucket_metadata_url}")

# We write a file named after this machine.
worker_log_file="machine-$(hostname)-finished.txt"
echo "Phew!  Work completed at $(date)" >"$${worker_log_file}"

# And we copy that file to the bucket specified in the metadata.
echo "Copying the log file to the bucket..."
gsutil cp "$${worker_log_file}" "$${worker_log_bucket}"