FROM debian:stable

ENV LC_ALL=C.UTF-8

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y vim
RUN apt-get install -y tmux
RUN apt-get install -y zsh
RUN curl -sSL https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz | tar -xzC /usr/local

ENV SHELL /bin/zsh
ENV TERM screen-256color

RUN useradd -ms /bin/zsh -G sudo unkiwii
USER unkiwii
WORKDIR /home/unkiwii

# configure go
RUN mkdir -p go/src
RUN mkdir -p go/bin
ENV PATH="${PATH}:/usr/local/go/bin:/home/unkiwii/go/bin"

# configure git
COPY --chown=unkiwii:unkiwii gitconfig .gitconfig
COPY --chown=unkiwii:unkiwii gitignore .gitignore

# configure vim
RUN mkdir .vim
COPY --chown=unkiwii:unkiwii vimrc .vimrc
COPY --chown=unkiwii:unkiwii vimrc.bundles .vimrc.bundles
# vim colors
RUN mkdir .vim/colors
COPY --chown=unkiwii:unkiwii mlessnau.vim .vim/colors/mlessnau.vim
# vim plugins
RUN mkdir .vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
# lo siguiente no funciona, ver como resolverlo
RUN vim +GoInstallBinaries +qall

# configure tmux
COPY --chown=unkiwii:unkiwii tmux.conf .tmux.conf

# configure zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY --chown=unkiwii:unkiwii zshrc .zshrc

CMD zsh
