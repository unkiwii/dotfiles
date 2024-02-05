# Install process

1. login as root
2. apt install doas git
3. echo 'permit persist [username] as root' > /etc/doas.conf
4. login as [username]
5. git clone https://github.com/unkiwii/dotfiles
6. sh dotfiles/install.sh
