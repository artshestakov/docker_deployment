#!/bin/bash

# Create a folder
#mkdir actions-runner && cd actions-runner

# Download the latest runner package
#curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz

# Optional: Validate the hash
# echo "3f6efb7488a183e291fc2c62876e14c9ee732864173734facc85a1bfb1744464  actions-runner-linux-x64-2.319.1.tar.gz" | shasum -a 256 -c

# Extract the installer
#tar xzf ./actions-runner-linux-x64-2.319.1.tar.gz

# Create the runner and start the configuration experience
# RUNNER_ALLOW_RUNASROOT="1" ./runner/config.sh --unattended --url https://github.com/artshestakov/Migrator --token ALYBK6C5QUHFD2LHYC7EYC3GZXHMK --name debian_runner

# Last step, run it!
RUNNER_ALLOW_RUNASROOT="1" ./runner/run.sh
