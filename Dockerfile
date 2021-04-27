FROM jrei/systemd-ubuntu:18.04

USER root

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y wget gnupg2 curl apt-transport-https libsecret-1-0 dbus-x11 gnome-keyring	  \
    && wget -q https://xpra.org/gpg.asc -O- | apt-key add -  \
    && cd /etc/apt/sources.list.d;wget https://xpra.org/repos/bionic/xpra.list  \
    && apt update  \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y xpra  \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y code \
    && apt-get install --no-install-recommends -y texlive texlive-lang-german texlive-latex-extra latexmk \
    && apt-get install --no-install-recommends -y xterm software-properties-common tasksel gnome-shell gnome-session gdm3 xdg-utils gnome-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD vscode.sh /usr/local/bin/vscode
RUN chmod +x /usr/local/bin/vscode

CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --start=vscode --daemon=no --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --sharing

