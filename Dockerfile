FROM debian:stable

ENV LC_ALL=C.UTF-8
ENV PATH="${PATH}:/usr/local/bin:/usr/local/go/bin:/home/unkiwii/go/bin"

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    tmux \
    zsh \
    autojump \
    unzip \
    man \
 && rm -rf /var/lib/apt/lists/*

# add nodejs repo and install nodejs (and npm)
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

# install go
RUN curl -sSL https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz | tar -xzC /usr/local

# install prettyping: a 'ping' replacement
RUN mkdir -p /usr/local/bin
RUN curl -sLo /usr/local/bin/prettyping https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping \
    && chmod a+x /usr/local/bin/prettyping

# install bat: a 'cat' replacement
RUN curl -sLo bat_0.9.0_amd64.deb https://github.com/sharkdp/bat/releases/download/v0.9.0/bat_0.9.0_amd64.deb \
    && dpkg -i bat_0.9.0_amd64.deb \
    && rm bat_0.9.0_amd64.deb

# install exa: a 'ls' replacement
RUN curl -sLo exa.zip https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip \
    && unzip -d /tmp/exa exa.zip \
    && mv /tmp/exa/exa* /usr/local/bin/exa \
    && rm -rf /tmp/exa \
    && rm exa.zip

# install tldr: a nice (and short) 'man'
RUN npm install -g tldr
RUN tldr --update

ENV SHELL /bin/zsh
ENV TERM screen-256color

RUN useradd -ms /bin/zsh -G sudo unkiwii
USER unkiwii
WORKDIR /home/unkiwii

# configure git
RUN ln -s ~/dotfiles/gitconfig .gitconfig
RUN ln -s ~/dotfiles/gitignore .gitignore

# configure vim
RUN mkdir -p .vim/colors
RUN mkdir -p .vim/bundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
COPY --chown=unkiwii:unkiwii vim/vimrc /home/unkiwii/.vimrc
COPY --chown=unkiwii:unkiwii vim/vimrc.bundles /home/unkiwii/.vimrc.bundles
COPY --chown=unkiwii:unkiwii vim/mlessnau.vim /home/unkiwii/.vim/colors/mlessnau.vim
RUN vim +PluginInstall +qall
RUN rm ~/.vimrc
RUN rm ~/.vimrc.bundles
RUN rm ~/.vim/colors/mlessnau.vim
RUN ln -s ~/dotfiles/vim/vimrc .vimrc
RUN ln -s ~/dotfiles/vim/vimrc.bundles .vimrc.bundles
RUN ln -s ~/dotfiles/vim/mlessnau.vim .vim/colors/mlessnau.vim

# configure tmux
RUN ln -s ~/dotfiles/tmux.conf .tmux.conf

# configure zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
 && rm .zshrc
RUN ln -s ~/dotfiles/zshrc .zshrc
RUN ln -s ~/dotfiles/zshrc.local .zshrc.local

# cleanup
RUN find -type d -name ".git" | xargs rm -rf

CMD ["zsh"]
