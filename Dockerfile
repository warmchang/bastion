FROM scratch
ADD rootfs.tar.gz /
RUN apk --update add openssh && rm -f /var/cache/apk/*
RUN ssh-keygen -A
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
  echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config && \
  echo "Port 9022" >> /etc/ssh/sshd_config && \
  echo "StrictModes no" >> /etc/ssh/sshd_config && \
  echo "MaxStartups 200:30:500" >> /etc/ssh/sshd_config

RUN adduser -D user && passwd -d user && mkdir /home/user/.ssh && chown user:nogroup /home/user/.ssh && chmod 700 /home/user/.ssh
VOLUME /home/user/.ssh
ADD harden.sh /usr/bin/harden.sh
RUN chmod 700 /usr/bin/harden.sh && /usr/bin/harden.sh
USER user
CMD ["/usr/sbin/sshd", "-D"]
