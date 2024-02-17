# Install process

After installing a distro without any Desktop Environment:
```sh
su -

# let the user run sudo commands
usermod -a -G sudo [username]

# remove any cd/dvd reference there
vi /etc/apt/sources.list

apt install doas git
echo 'permit persist [username] as root' > /etc/doas.conf
exit   # from the root session

git clone https://github.com/unkiwii/dotfiles && sh dotfiles/install.sh
```
