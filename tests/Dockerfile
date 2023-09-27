# Use the Ubuntu base image
FROM ubuntu:latest

# Install OpenSSH server
RUN apt-get update && apt-get install -y openssh-server

# Create a folder for the SSH daemon
RUN mkdir /var/run/sshd

# Get the public key as a build argument
ARG PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBznwIb7wGsPVKqUqehpBK7wpUBHaiqU1HQEwfc48LzP kcrook@live.com"

# Add the provided public key to the container's authorized keys for root
RUN mkdir -p /root/.ssh
RUN echo "$PUBLIC_KEY" > /root/.ssh/authorized_keys

# Correct permissions for the .ssh directory and authorized_keys
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

# Create arbitrary users (you can add more users as needed)
RUN sh -c 'useradd -m user1 && echo "user1:password1" | chpasswd'
RUN sh -c 'useradd -m user2 && echo "user2:password2" | chpasswd'
RUN sh -c 'useradd -m user3 && echo "user3:password3" | chpasswd'

# SSH login fix so the user doesn't get kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Permit root login with public key (you can also use 'yes' if password is also allowed)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin without-password/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Start SSHD in the background and tail its logs
CMD ["/usr/sbin/sshd", "-D"]