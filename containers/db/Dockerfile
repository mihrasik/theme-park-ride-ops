
FROM mariadb:latest

# Install base tools + SSH
RUN apt-get update && apt-get install -y \
    openssh-server sudo passwd curl git iproute2 iputils-ping net-tools wget \
    && rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------------
#  6. Expose the required ports
# ------------------------------------------------------------------
EXPOSE 22 3306


# ------------------------------------------------------------------
#  8. Entrypoint – starts sshd in the background and then runs the app
# ------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh


# Create SSH host keys (required)
RUN ssh-keygen -A

# Prepare SSH
RUN mkdir /var/run/sshd

# Create vagrant user with password
RUN useradd -m -s /bin/bash vagrant \
    && echo "vagrant:vagrant" | chpasswd \
    && usermod -aG sudo vagrant \
    && echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant


# Add the default vagrant insecure key
# (We'll copy it in from the build context)
COPY insecure_key.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys && chown -R vagrant:vagrant /home/vagrant/.ssh

# Create directories and set permissions (if needed)
RUN mkdir -p /var/run/sshd && \
    chmod 755 /var/run/sshd
 

# Expose SSH port
EXPOSE 22 3306

#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


# Copy initialization scripts (run once on first start)
# COPY init-db.sql /docker-entrypoint-initdb.d/

# Optional: custom entrypoint if you really need post-init logic
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command
CMD ["mariadbd"]