# Use Amazon Corretto JDK image with ARM64 support
FROM amazoncorretto:11-alpine

# Enable non-free packages for OpenSSH
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install openssh server and bash
RUN apk update && apk add --no-cache openssh bash sudo curl


# ------------------------------------------------------------------
#  5. Copy the Spring‑Boot application
# ------------------------------------------------------------------
COPY build/libs/*.jar /app/theme-park-ride-gradle.jar

# ------------------------------------------------------------------
#  6. Expose the required ports
# ------------------------------------------------------------------
EXPOSE 22 8080

# ------------------------------------------------------------------
#  7. Health‑check (optional – adjust the URL to your actuator)
# ------------------------------------------------------------------
HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
  CMD curl -f http://localhost:5000/actuator/health || exit 1

# ------------------------------------------------------------------
#  8. Entrypoint – starts sshd in the background and then runs the app
# ------------------------------------------------------------------
COPY containers/app/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh



# Create SSH host keys (required)
RUN ssh-keygen -A

# Create vagrant user
RUN adduser -D vagrant && echo "vagrant:vagrant" | chpasswd && \
    mkdir -p /home/vagrant/.ssh && chmod 700 /home/vagrant/.ssh

# Add the default vagrant insecure key
# (We'll copy it in from the build context)
COPY containers/app/insecure_key.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys && chown -R vagrant:vagrant /home/vagrant/.ssh

# ------------------------------------------------------------------
#  3. Create the “vagrant” user
# ------------------------------------------------------------------
RUN addgroup -S sudo \
    && addgroup vagrant sudo \
    && echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant

# Enable root SSH login (optional)
# RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
#     echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
#     echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
#     echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22 8080 5000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start SSH server in foreground
CMD ["/usr/sbin/sshd", "-D"]
