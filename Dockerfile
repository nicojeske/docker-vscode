FROM jrei/systemd-ubuntu:18.04

USER root

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y wget gnupg2
RUN wget -q https://xpra.org/gpg.asc -O- | apt-key add -
RUN cd /etc/apt/sources.list.d;wget https://xpra.org/repos/bionic/xpra.list
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y xpra

#From cocalc-docker
# Microsoft's VS Code
RUN apt-get update && apt-get install -y curl && apt-get clean && \
     curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y code

RUN apt-get install -y libsecret-1-0 dbus-x11 gnome-keyring	

RUN apt-get install -y texlive texlive-lang-german texlive-latex-extra latexmk
RUN apt-get install -y xterm software-properties-common tasksel gnome-shell gnome-session gdm3

ADD vscode.sh /usr/local/bin/vscode
RUN chmod +x /usr/local/bin/vscode

CMD xpra start --bind-tcp=0.0.0.0:10000 --html=on --start-child=vscode --exit-with-children=no --daemon=no --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --sharing

