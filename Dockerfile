FROM kasmweb/core-ubuntu-noble:1.17.0-rolling-weekly
USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN yes | unminimize

# Update Ubuntu and software.
RUN apt update \
    && sudo apt upgrade -y

# Устанавливаем зависимости fonts-liberation xdg-utils
RUN apt install -y sudo wget gpg gedit rsync nano htop mc net-tools locales apt-transport-https fonts-liberation xdg-utils unzip zip tar gzip software-properties-common \
    bash-completion dnsutils nmap openssh-client git pkg-config cmake tree jq gnupg p7zip-full curl npm nodejs gnome-keyring && \
    echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/list/* && \
    sudo passwd -d kasm-user && \
    echo 'set -o history' >> $HOME/.bashrc && \
    echo 'shopt -s histappend' >> $HOME/.bashrc && \
    echo 'PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> $HOME/.bashrc && \
    echo 'export HISTSIZE=10000' >> $HOME/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> $HOME/.bashrc && \
    echo 'export HISTCONTROL=ignoredups:erasedups' >> $HOME/.bashrc && \
    echo "export HISTFILE=/home/kasm-user/.bash_history" >> $HOME/.bashrc && \
    echo 'alias ll="ls -lah"' >> $HOME/.bashrc && \
    # this is hook for "trust and launch window"
    echo 'gio set /usr/share/applications/google-chrome.desktop "metadata::trusted" yes' >> $HOME/.bashrc && \
    echo 'gio set /usr/share/applications/cursor.desktop "metadata::trusted" yes' >> $HOME/.bashrc && \
    echo 'gio set /usr/share/applications/filezilla.desktop "metadata::trusted" yes' >> $HOME/.bashrc && \
    echo 'gio set /usr/share/applications/windsurf.desktop "metadata::trusted" yes' >> $HOME/.bashrc && \
    echo 'if [ -n "$BASH_VERSION" ]; then' >> $HOME/.profile && \
    echo 'if [ -f "/home/kasm-user/.bashrc" ]; then' >> $HOME/.profile && \
    echo '    . /home/kasm-user/.bashrc"' >> $HOME/.profile && \
    echo 'fi fi' >> $HOME/.profile

# Chrome Install
RUN wget https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/chrome/install_chrome.sh -O /tmp/chrome.sh && bash /tmp/chrome.sh
RUN ln -sf /usr/share/applications/google-chrome.desktop $HOME/Desktop/google-chrome.desktop && chmod 777 $HOME/Desktop/google-chrome.desktop

# FileZilla Install
RUN mkdir -p $STARTUPDIR/install/filezilla/ && \
    wget https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/filezilla/filezilla.xml -O $STARTUPDIR/install/filezilla/filezilla.xml

RUN wget https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/filezilla/install_filezilla.sh -O /tmp/filezilla.sh && bash /tmp/filezilla.sh
RUN ln -sf /usr/share/applications/filezilla.desktop $HOME/Desktop/filezilla.desktop && chmod 777 $HOME/Desktop/filezilla.desktop

# Cursor Install
RUN wget https://api2.cursor.sh/updates/download/golden/linux-x64-deb/cursor/2.0 -O /tmp/cursor.deb && dpkg -i /tmp/cursor.deb
RUN sed -i 's|^Exec=\(.*cursor\)\(.*\)|Exec=\1 --no-sandbox --password-store=basic\2|' /usr/share/applications/cursor.desktop && \
    sed -i 's|^Exec=\(.*cursor\)\(.*\)|Exec=\1 --no-sandbox --password-store=basic\2|' /usr/share/applications/cursor-url-handler.desktop && \
    ln -sf /usr/share/applications/cursor.desktop $HOME/Desktop/cursor.desktop && chmod 777 $HOME/Desktop/cursor.desktop

# Windsurf Install
RUN wget -qO- "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | gpg --dearmor > /usr/share/keyrings/windsurf-stable.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/windsurf-stable.gpg] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" > /etc/apt/sources.list.d/windsurf.list && \
    apt-get update && \
    apt-get install -y windsurf && sleep 2 && \
    sed -i 's|^Exec=\(.*windsurf\)\(.*\)|Exec=\1 --no-sandbox --password-store=basic\2|' /usr/share/applications/windsurf.desktop && \
    sed -i 's|^Exec=\(.*windsurf\)\(.*\)|Exec=\1 --no-sandbox --password-store=basic\2|' /usr/share/applications/windsurf-url-handler.desktop && \
    ln -sf /usr/share/applications/windsurf.desktop $HOME/Desktop/windsurf.desktop && chmod 777 $HOME/Desktop/windsurf.desktop

# Other
RUN wget https://images.wallpaperscraft.com/image/single/branch_thuja_needles_144305_3840x2160.jpg -O /usr/share/backgrounds/bg_default.png && \
    ln -sf /usr/share/applications/xfce4-terminal.desktop $HOME/Desktop/terminal.desktop && chmod 777 $HOME/Desktop/terminal.desktop && \
    truncate -s 0 $HOME/.bash_history

RUN locale-gen ru_RU.UTF-8 && \
    update-locale LANG=ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8 \
    LANGUAGE=ru_RU:ru \
    LC_ALL=ru_RU.UTF-8

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME && chmod -R a+x $HOME

USER 1000
