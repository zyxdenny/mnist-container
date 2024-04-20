# Use debian linux as the base OS
FROM debian:bookworm 

MAINTAINER yuxuan "zyx@yuxuanzheng.com"

# Install just the Python runtime (no dev)
RUN apt-get -y update && apt-get -y install python3.11-venv

# Set up a working folder and install the pre-reqs
WORKDIR /
ADD mnist /mnist
WORKDIR /mnist
RUN python3 -m venv .
RUN . bin/activate && \
    pip3 install -r requirements.txt

# Train the model
CMD . bin/activate && python3 main.py --epoch 1 --no-cuda --dry-run
