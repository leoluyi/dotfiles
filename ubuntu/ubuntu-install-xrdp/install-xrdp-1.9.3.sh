#!/usr/bin/env bash

################################################################
# Script_Name : install-xrdp-1.9.3.sh
# Description : Perform an automated custom installation of xrdp
# on ubuntu 16.04.4
# Date : March 2018
# written by : Griffon
# Web Site :http://www.c-nergy.be - http://www.c-nergy.be/blog
# Version : 1.9.2
# Disclaimer : Script provided AS IS. Use it at your own risk....
##################################################################

#----------------------------------------------------------------#
# Step 0 - Try to Detect Ubuntu Version and Unity....
#----------------------------------------------------------------#
clear

#Checking Ubuntu Version

echo
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;32m Dectecting Ubuntu Version and Desktop in use...\e[0m"
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"

version=$(lsb_release -d | awk -F":" '/Description/ {print $2}')

if [[ $version = *"Ubuntu 16.04"* ]]; then
  echo
  /bin/echo -e "\e[1;33m  Ubuntu Version :$version\e[0m"

else
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  /bin/echo -e "\e[1;31mYour system is not running Ubuntu 16.04 Edition.\e[0m"
  /bin/echo -e "\e[1;31mThe script has been tested only on Ubuntu 16.04.x...\e[0m"
  /bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  echo
  exit
fi

#Checking if Unity Desktop in Use

if [ "$XDG_CURRENT_DESKTOP" = "Unity" ]; then
  /bin/echo -e "\e[1;33m  Desktop interface Detected....:  $XDG_CURRENT_DESKTOP\e[0m"
  echo
else
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  /bin/echo -e "\e[1;31mYour system is not running Unity Desktop Interface.\e[0m"
  /bin/echo -e "\e[1;31mThe script has been written to enable Unity Desktop in remote session...\e[0m"
  /bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  exit
fi


#---------------------------------------------------#
# Step 1 - Download XRDP Binaries...
#---------------------------------------------------#

/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;32m Downloading xRDP binaries and tools...\e[0m"
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
/bin/echo -e "\e[1;33m  Installing Git....Proceeding  \e[0m"
echo
sudo apt-get update -y && sudo apt-get -qq -y install git
echo

CWD=$(pwd)
# tmp_dir="./xrdp_temp"
# mkdir -p ${tmp_dir}
tmp_dir=$(mktemp -d)
cd ${tmp_dir}

## -- Download the xrdp latest files
echo
/bin/echo -e "\e[1;33m  Preparing download xrdp package...Proceeding\e[0m"
echo
git clone https://github.com/neutrinolabs/xrdp.git
echo
/bin/echo -e "\e[1;33m  Preparing download xorgxrdp package...Proceeding\e[0m"
echo
git clone https://github.com/neutrinolabs/xorgxrdp.git


#---------------------------------------------------#
# Step 2 - Install Prereqs...
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m  Installing Prereqs....Proceeding\e[0m"
echo
sudo apt-get -y install libx11-dev libxfixes-dev libssl-dev libpam0g-dev libtool libjpeg-dev flex bison gettext autoconf libxml-parser-perl libfuse-dev xsltproc libxrandr-dev python-libxml2 nasm xserver-xorg-dev fuse


#---------------------------------------------------#
# Step 3 - Check if Fontutil.h file exists...
#---------------------------------------------------#

#checking if file exists...
echo
/bin/echo -e "\e[1;33m  Checking fontutil.h file....Proceeding\e[0m"
echo

file="/usr/include/X11/fonts/fontutil.h"

if [ -f "$file" ]; then
  echo
  /bin/echo -e "\e[1;37m     Fontutil.h exist...Moving Next step      \e[0m"
  echo
else
  echo
  /bin/echo -e "\e[1;37m     Fontutil.h will be created by script...Proceeding  \e[0m"

  echo
  cat >/usr/include/X11/fonts/fontutil.h <<EOF
#ifndef _FONTUTIL_H_
#define _FONTUTIL_H_

#include <X11/fonts/FSproto.h>

extern int FontCouldBeTerminal(FontInfoPtr);
extern int CheckFSFormat(fsBitmapFormat, fsBitmapFormatMask, int *, int *,
                 int *, int *, int *);
extern void FontComputeInfoAccelerators(FontInfoPtr);

extern void GetGlyphs ( FontPtr font, unsigned long count,
                unsigned char *chars, FontEncoding fontEncoding,
                unsigned long *glyphcount, CharInfoPtr *glyphs );
extern void QueryGlyphExtents ( FontPtr pFont, CharInfoPtr *charinfo,
                    unsigned long count, ExtentInfoRec *info );
extern Bool QueryTextExtents ( FontPtr pFont, unsigned long count,
                       unsigned char *chars, ExtentInfoRec *info );
extern Bool ParseGlyphCachingMode ( char *str );
extern void InitGlyphCaching ( void );
extern void SetGlyphCachingMode ( int newmode );
extern int add_range ( fsRange *newrange, int *nranges, fsRange **range,
                   Bool charset_subset );

#endif /* _FONTUTIL_H_ */
EOF

fi

#---------------------------------------------------#
# Step 4 - compiling...
#---------------------------------------------------#
# -- Compiling xrdp package first

echo
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;32mXRDP Compilation about to start !...                    \e[0m"
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo


cd "${CWD}" && cd ${tmp_dir}/xrdp
sudo ./bootstrap
sudo ./configure --enable-fuse --enable-jpeg
sudo make

#-- check if no error during compilation

if [ $? -eq 0 ]; then
  echo
  /bin/echo -e "\e[1;37m-----------------------------------\e[0m"
  /bin/echo -e "\e[1;37mMake Operation Successful !        \e[0m"
  /bin/echo -e "\e[1;37m-----------------------------------\e[0m"
  echo
else
  echo
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  /bin/echo -e "\e[1;31mError while executing make.\e[0m"
  /bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
  /bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
  echo
  exit
fi

sudo make install

# -- Compiling xorgxrdp package first

echo
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;32mxorgxrdp Compilation about to start !...                    \e[0m"
/bin/echo -e "\e[1;32m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo

cd ${tmp_dir}/xorgxrdp
sudo ./bootstrap
sudo ./configure
sudo make

# check if no error during compilation
if [ $? -eq 0 ]
then
echo
/bin/echo -e "\e[1;37m-----------------------------------\e[0m"
/bin/echo -e "\e[1;37mMake Operation Successful ! \e[0m"
/bin/echo -e "\e[1;37m-----------------------------------\e[0m"
echo
else
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;31mError while executing make.\e[0m"
/bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
exit
fi
sudo make install

#---------------------------------------------------#
# Step 5 - create policies exceptions ....
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m  Creating Polkit file...Proceeding\e[0m"
echo

sudo bash -c "cat >/etc/polkit-1/localauthority.conf.d/02-allow-colord.conf" <<EOF

polkit.addRule(function(action, subject) {
if ((action.id == "org.freedesktop.color-manager.create-device" ||
action.id == "org.freedesktop.color-manager.create-profile" ||
action.id == "org.freedesktop.color-manager.delete-device" ||
action.id == "org.freedesktop.color-manager.delete-profile" ||
action.id == "org.freedesktop.color-manager.modify-device" ||
action.id == "org.freedesktop.color-manager.modify-profile") &&
subject.isInGroup("{users}")) {
return polkit.Result.YES;
}
});
EOF

#---------------------------------------------------#
# Step 6 - configure Xwrapper file  ....
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m  Configuring Xwrapper(optional)...Proceeding\e[0m"
echo

sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#---------------------------------------------------#
# Step 7 - Populate the .xsession file multi-users  #
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m  Configuring startwm.sh for multi-users login...Proceeding\e[0m"
echo

sudo sed -i.bak "/# auth /a cat >~/.xsession << EOF\nexport CLUTTER_IM_MODULE=xim\nexport GTK_IM_MODULE=ibus\nexport XMODIFIERS=\"@im=ibus\"\nexport QT_IM_MODULE=ibus\nexport QT4_IM_MODULE=xim\nibus-daemon -xrd &\n# Unity Xrdp multi-users \n/usr/lib/gnome-session/gnome-session-binary --session=ubuntu &\n/usr/lib/x86_64-linux-gnu/unity/unity-panel-service &\n/usr/lib/unity-settings-daemon/unity-settings-daemon &\nfor indicator in /usr/lib/x86_64-linux-gnu/indicator-*;\ndo\nbasename='basename \\\\\${indicator}'\ndirname='dirname \\\\\${indicator}'\nservice=\\\\\${dirname}/\\\\\${basename}/\\\\\${basename}-service\n\\\\\${service} &\ndone\nunity\nEOF" /etc/xrdp/startwm.sh

#---------------------------------------------------#
# Step 8 - create services ....
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m  Creating xRDP Services...Proceeding\e[0m"
echo

sudo systemctl daemon-reload
sudo systemctl enable xrdp.service
sudo systemctl enable xrdp-sesman.service
sudo systemctl start xrdp

#---------------------------------------------------#
# Step 9 - install additional pacakge ....
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m  Installing xserver-xorg-core pacakges...Proceeding\e[0m"
echo
sudo apt-get -y install xserver-xorg-core

echo
/bin/echo -e "\e[1;33m  checking Virtualization Platform...Proceeding\e[0m"
echo

vmversion=$(sudo dmidecode -s system-product-name)
echo $vmversion
if [ "$vmversion" = "VirtualBox" ]
then
    sudo apt-get -y install xserver-xorg-input-all
else
    echo "no additional package needed"
fi

/bin/echo -e "\e[1;33m  Installing ibus pacakges...Proceeding\e[0m"
sudo apt-get install ibus ibus-gtk ibus-gtk3 ibus-qt4 ibus-chewing

/bin/echo -e "\e[1;32m----------------------------------------------------------\e[0m"
/bin/echo -e "\e[1;32mInstallation Completed\e[0m"
/bin/echo -e "\e[1;32mPlease test your xRDP configuration....\e[0m"
# /bin/echo -e "\e[1;32mCheck c-nergy.be website for latest version of the script\e[0m"
# /bin/echo -e "\e[1;32mwritten by Griffon - March 2018 - Version 1.9.2\e[0m"
/bin/echo -e "\e[1;32m----------------------------------------------------------\e[0m"
echo

cd "${CWD}"
