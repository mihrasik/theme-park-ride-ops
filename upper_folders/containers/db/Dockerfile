FROM mariadb:latest

# Install SSH + tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Generate SSH host keys
RUN ssh-keygen -A && \
    mkdir -p /var/run/sshd && \
    chmod 755 /var/run/sshd

# Create vagrant user
RUN useradd -m -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    usermod -aG sudo vagrant && \
    echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant && \
    chmod 440 /etc/sudoers.d/vagrant

# Setup SSH key
RUN mkdir -p /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh && \
    chown vagrant:vagrant /home/vagrant/.ssh

# Copy Vagrant insecure public key
COPY insecure_key.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys && \
    chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# Copy custom entrypoint
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Expose ports
EXPOSE 22 3306

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["mariadbd"]