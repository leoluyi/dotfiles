# XRDP - How To Remote Connect to Unity Desktop on Ubuntu 16.04

- [XRDP - Custom install on Ubuntu 16.04.x with Unity](http://c-nergy.be/blog/?p=11719)
- [Connect to Unity Desktop on Ubuntu 16.04 via TigerVNC](http://c-nergy.be/blog/?p=9962)
- http://www.hiroom2.com/2016/08/28/ubuntu-16-04-remote-connect-to-unity-with-vnc-xrdp/
- http://www.wlintmp.net/2014/02/arch-linux-ibus.html

## Custom xRDP

### 0. Assumptions

Before running this script, be aware of the following assumptions

- We have tested the script on Ubuntu 16.04 Update 3 and Update 4. 
- The script should be working on Ubuntu 16.04 (whatever the Update version) 
- No additional desktop interface has been installed. **Unity Desktop** will be the default interface in the remote sessions
- This script configure the `.xsession` file for multipe users.

### 1. Install ubuntu-desktop first

```
# (Deprecated)
# If you want to switch back and forth from ubuntu-desktop, you have to install budgie-desktop first.
# 
# sudo add-apt-repository ppa:budgie-remix/ppa && sudo apt update
# sudo apt -y install budgie-desktop
```

Install `ubuntu-desktop`

```
$ sudo apt -y install ubuntu-desktop
```

### 2. Run xRDP install script

```
$ wget -qO ~/Downloads/install-xrdp-1.9.2.zip http://www.c-nergy.be/downloads/install-xrdp-1.9.2.zip && unzip install-xrdp-1.9.2.zip

$ wget -qO ~/Downloads/install-xrdp-1.9.3.sh https://gist.github.com/leoluyi/af9398e3e9f4e51ceebaf12a2a425fd9/raw/f4dfd2de9599f2d79f60073a21df67e065a92bde/install-xrdp-1.9.3.sh
$ chmod +x  ~/Downloads/install-xrdp-1.9.3.sh
$ ./install-xrdp-1.9.3.sh
```

### 3. Instal Gnome Tweak Tool (Optional)

```
$ sudo add-apt-repository ppa:tualatrix/ppa && sudo apt update

$ sudo apt install -y gnome-tweak-tool
$ sudo apt install -y unity-tweak-tool
$ sudo apt install -y ubuntu-tweak
```

### Issues detected 

#### Logout options

In this version, you can click on the logout option and this should be normally work out of the box. We have tried two three times and it seems to works (even do it's a little bit slow). If you have issues with logout actions, you can try to use the following command line (or make a custom shortcut that users can they use to logout in one step)

Find proscess id

```
$ ps aux | grep [x]orgxrdp
```

```
$ ps -ef h | grep xorgxrdp | grep `whoami` | tr -s " " | cut -d " " -f2 | xargs kill -9
```

#### Broken thinclient_drives mount

https://butui.me/post/little-issue-about-xrdp/

```
$ fusermount -u thinclient_drives
```

----------------------------------------------

## (Old Solution) Tigervnc

You will be able to access your Unity Desktop through Remote Desktop! No need to install alternate Desktop such as xfce, Mate, LXDE.

### Install Tigervnc

```
$ sudo apt install -y zip gdebi
$ sudo apt remove -y vnc4server  # Remove old vnc4server

$ wget http://www.c-nergy.be/downloads/tigervncserver_1.6.80-4_amd64.zip && unzip tigervncserver_1.6.80-4_amd64.zip
$ sudo gdebi tigervncserver_1.6.80-4_amd64.deb
$ sudo apt -y install xrdp
$ sudo systemctl restart xrdp.service
```
With this article's configuration, selecting "Sytem settings..." at the upper right will call gnome-control-center instead of unity-control-center. Add gnome-control-center which is symbolic link to unity-control-center.

```
$ sudo ln -s /usr/bin/unity-control-center /usr/bin/gnome-control-center
```

### Edit to use different Xsession Desktop for multi-users

edit file `sudo vim /etc/xrdp/startwm.sh` as following:

```
#!/bin/sh

if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi

# 修正中文輸入法
export CLUTTER_IM_MODULE=xim
export GTK_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export QT4_IM_MODULE=xim
ibus-daemon -xrd &

# Fix missing indicator panel
/usr/lib/gnome-session/gnome-session-binary --session=ubuntu &
/usr/lib/x86_64-linux-gnu/unity/unity-panel-service &
/usr/lib/unity-settings-daemon/unity-settings-daemon &

for indicator in /usr/lib/x86_64-linux-gnu/indicator-*;
do
  basename=`basename ${indicator}`
  dirname=`dirname ${indicator}`
  service=${dirname}/${basename}/${basename}-service
  ${service} &
done

# for multi-users
unity

. /etc/X11/Xsession
```


### Single user

Edit `~/.xsession` as following:

#### 1. Use budgie-desktop

```
budgie-desktop
```

#### 2. Use Unity desktop

```
# 修正中文輸入法
export CLUTTER_IM_MODULE=xim
export GTK_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export QT4_IM_MODULE=xim
ibus-daemon -xrd &

# Fix missing indicator panel
/usr/lib/gnome-session/gnome-session-binary --session=ubuntu &
/usr/lib/x86_64-linux-gnu/unity/unity-panel-service &
/usr/lib/unity-settings-daemon/unity-settings-daemon &

for indicator in /usr/lib/x86_64-linux-gnu/indicator-*; do
  basename=`basename ${indicator}`
  dirname=`dirname ${indicator}`
  service=${dirname}/${basename}/${basename}-service
  ${service} &
done

unity
```
