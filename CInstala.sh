#!/bin/bash

# UTILITIES BEGIN
function L {
	cat << EOF
   ██████╗ ██╗
  ██╔════╝ ██║
  ██║      ██║ ███╗   ██╗ ███████╗ ████████╗  █████╗  ██╗       █████╗ 
  ██║      ██║ ████╗  ██║ ██╔════╝ ╚══██╔══╝ ██╔══██╗ ██║      ██╔══██╗
  ██║      ██║ ██╔██╗ ██║ ███████╗    ██║    ███████║ ██║      ███████║
  ██║      ██║ ██║╚██╗██║ ╚════██║    ██║    ██╔══██║ ██║      ██╔══██║
  ╚██████╗ ██║ ██║ ╚████║ ███████║    ██║    ██║  ██║ ███████╗ ██║  ██║
   ╚═════╝ ╚═╝ ╚═╝  ╚═══╝ ╚══════╝    ╚═╝    ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝
                                              Developed by Pedro Tôrres
EOF
}
function DFI {
	gtk-update-icon-cache -f $HOME/.local/share/icons/hicolor >/dev/null 2>&1
	desktop-file-install --dir=$HOME/.local/share/applications "$HOME/.local/share/applications/$1"
}
function LtL {
	DFI $1
	favorites=$(
python << EOF
from collections import OrderedDict
array = eval("$(gsettings get com.canonical.Unity.Launcher favorites)")
print(str(list(OrderedDict.fromkeys(array[:-3] + ["$1"] + array[-3:]))))
EOF
)
	gsettings set com.canonical.Unity.Launcher favorites "$favorites"
}
function DF {
	tput cuu1
	tput el
	CMD="$(declare -f L);$(declare -f DFI);$(declare -f LtL);$(declare -f DF);$(declare -f Q);$(declare -f NULL);trap NULL INT;$(declare -f CCC);$(declare -f IO);$(declare -f EL);$(declare -f WMB);$(declare -f WGET);$(declare -f TGZ);$(declare -f TXZ);$(declare -f CP);$(declare -f RM);$(declare -f UNZIP);$(declare -f DPKG);$(declare -f APTGET);$(declare -f $1);$1"
	gnome-terminal -e "bash -ic '${CMD//\'/\'\"\'\"\'}'"
}
function Q {
	resize -s 24 80 >/dev/null 2>&1
	source $HOME/.bashrc
	tput clear
	tput reset
	exit
}
function NULL {
	:
}
# UTILITIES END

# LEGACY TUI BEGIN
function CCC {
	tput clear
	tput reset
	tput bold
	printf "\n$(L)\n\n\e[1;49;32m$1\e[0m"
}
function IO {
	tput bold
	tput sc
	for i in `seq 1 $(tput lines)`; do
		tput el
		printf '\033[B'
	done
	printf "\e[7;49;31m"
	printf "Invalid Option"
	for i in `seq 1 $(expr $(tput cols) - 14)`; do
		printf ' '
	done
	printf "\e[0m"
	tput rc
	tput cuu1
	tput el
	tput sgr 0
}
function EL {
	if [ $? -eq 0 ]
	then
		CCC "$1! Press any key to continue...\n\n"
	else
		CCC "Something went wrong! Please try again...\n\n"
	fi
}
# LEGACY TUI END

# WHIPTAIL TUI BEGIN
function WMB {
	whiptail --msgbox "$(L)" 0 0 0 --fb --title "$*"
}
function WGET {
	{ 
		while read line
		do 
			remaining=$(echo "$line" | grep '%' | rev | cut -d ' ' -f 1 | rev)
			echo XXX
			echo "$line" | grep '%' | cut -d '%' -f 1 | rev | cut -d ' ' -f 1 | rev
			echo "\nDownloading $1...\n$remaining remaining"
			echo XXX
		done < <(wget "$2" -O "$3" --header "$4" 2>&1)
	} | whiptail --title "CInstala" --gauge "\nDownloading $1...\n " 0 0 0
}
function TGZ {
	( pv -n "$2" | tar -xzf - -C "$3" ) 2>&1 | whiptail --title "CInstala" --gauge "\nExtracting $1..." 0 0 0
}
function TXZ {
	( pv -n "$2" | tar -xJf - -C "$3" ) 2>&1 | whiptail --title "CInstala" --gauge "\nExtracting $1..." 0 0 0
}
function CP {
	( cp -fRv ${@:2} | pv -elnps $(find ${@:2:(( $# - 2 ))} | wc -l) ) 2>&1 | whiptail --title "CInstala" --gauge "\nCopying $1..." 0 0 0
}
function RM {
	( rm -fRv ${@:2} | pv -elnps $(find ${@:2} | wc -l) ) 2>&1 | whiptail --title "CInstala" --gauge "\nRemoving $1..." 0 0 0
}
function UNZIP {
	( unzip "$2" -d "$3" | pv -elnps $(unzip -l "$2" | wc -l) ) 2>&1 | whiptail --title "CInstala" --gauge "\nExtracting $1..." 0 0 0
}
function DPKG {
	( dpkg --vextract "$2" "$3" | pv -elnps $(dpkg -c "$2" | wc -l) ) 2>&1 | whiptail --title "CInstala" --gauge "\nExtracting $1..." 0 0 0
}
function APTGET {
	( apt-get download -q ${@:2} | pv -elnps $# ) 2>&1 | whiptail --title "CInstala" --gauge "\nDownloading $1..." 0 0 0
}
# WHIPTAIL TUI END

function SE {
	trap NULL INT
	CCC "Setting up Environment...\n\n"
	WGET ".vimrc" https://gist.githubusercontent.com/t0rr3sp3dr0/7f9c29cc8ddda2becbab7f7a2a3cf8c9/raw/.vimrc $HOME/.vimrc
	cat << EOF > $HOME/.config/upstart/desktopClose.conf
description "Desktop Close Task"
start on session-end
task
script
	rm -fR $HOME/.*_history < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/.mozilla/firefox/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/.ssh/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/Desktop/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/Documents/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/Downloads/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/git/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/AndroidStudioProjects/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/ClionProjects/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/IdeaProjects/* < /dev/null > /dev/null 2>&1 &
	rm -fR $HOME/PycharmProjects/* < /dev/null > /dev/null 2>&1 &
end script
EOF
	chmod 700 $HOME
	gsettings reset com.canonical.Unity.Launcher favorites
	gsettings set com.canonical.Unity.Launcher favorites "$(
python << EOF
array = eval("$(gsettings get com.canonical.Unity.Launcher favorites)")
print(str(array[:3] + array[8:]))
EOF
)"
	LtL application://gnome-terminal.desktop
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
	gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
	gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
	gsettings set org.gnome.desktop.screensaver lock-enabled false
	gsettings set org.gnome.desktop.session idle-delay 0
	if [ -z "$(xrandr | head -2 | tail -1 | grep -e '1600x900' -e '1920x1080' 2>/dev/null)" ]; then
		if [ "$(hostname | cut -c 3)" == "1" ] || [ "$(hostname | cut -c 3)" == "2" ]; then
			params=$(cvt 1600 900 60 | tail -1 | sed s/^[^' ']*//)
		else
			params=$(cvt 1920 1080 60 | tail -1 | sed s/^[^' ']*//)
		fi
		name_mode=$(echo $params | grep -P '"([^"]*)"' -o)
		inf=$(xrandr | head -2 | tail -1 | grep -P '(^[^'\ ']*)' -o)
		cat << EOF >> $HOME/.profile
xrandr --newmode $params
xrandr --addmode $inf $name_mode
xrandr --output $inf --mode $name_mode
EOF
	fi
	printf "\nsetxkbmap us,us altgr-intl,\n" >> $HOME/.bashrc
	source $HOME/.profile
	CCC "Environment setted up with success!\n\n"
	trap Q INT
}
function GSK {
	CCC "Generating SSH Key...\n\n"
	if [ -z "$(which puttygen 2>/dev/null)" ]
	then
		DIR=$(pwd)
		cd /tmp
		APTGET "PuTTY Tools" putty-tools
		cd "$DIR"
		DPKG "PuTTY Tools" /tmp/putty-tools* /tmp/putty-tools
		CP "PuTTY Tools" /tmp/putty-tools/usr/* $HOME/.local
		RM "temporary files" /tmp/putty-tools*
	fi
	if [ -z "$(which xclip 2>/dev/null)" ]
	then
		DIR=$(pwd)
		cd /tmp
		APTGET "xclip" xclip
		cd "$DIR"
		DPKG "xclip" /tmp/xclip* /tmp/xclip
		CP "xclip" /tmp/xclip/usr/* $HOME/.local
		RM "temporary files" /tmp/xclip*
	fi
	ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f $HOME/.ssh/id_rsa
	puttygen $HOME/.ssh/id_rsa -o $HOME/.ssh/id_rsa.ppk
	cat $HOME/.ssh/id_rsa.pub | xclip -selection c
	if (whiptail --yesno "$(L)" 0 0 --fb --title "Public SSH Key copied to clipboard! Would you like to upload it to GitHub?") then
		firefox https://github.com/settings/keys < /dev/null > /dev/null 2>&1 &
	fi
}
function IJSDK {
	CCC "Installing Java SE Development Kit...\n\n"
	WGET "Java SE Development Kit" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz /tmp/jdk.tgz "Cookie: oraclelicense=accept-securebackup-cookie;"
	RM "old versions of Java SE Development Kit" $HOME/.local/jvm/jdk*
	TGZ "Java SE Development Kit" /tmp/jdk.tgz $HOME/.local/jvm
	RM "temporary files" /tmp/jdk.tgz
	export JDK_HOME=$HOME/.local/jvm/jdk*
	export JAVA_HOME=$JDK_HOME
	export PATH=$PATH:$JAVA_HOME/bin
	printf "\nexport JDK_HOME=$HOME/.local/jvm/jdk*\nexport JAVA_HOME=\$JDK_HOME\nexport PATH=\$PATH:\$JAVA_HOME/bin\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	WMB "Java SE Development Kit installed successfully!"
}
function IJSB {
	CCC "Installing JavaFX Scene Builder...\n\n"
	WGET "JavaFX Scene Builder" http://download.oracle.com/otn-pub/java/javafx_scenebuilder/2.0-b20/javafx_scenebuilder-2_0-linux-x64.tar.gz /tmp/scenebuilder.tgz "Cookie: oraclelicense=accept-securebackup-cookie;"
	TGZ "JavaFX Scene Builder" /tmp/scenebuilder.tgz $HOME/.local/opt
	RM "temporary files" /tmp/scenebuilder.tgz
	cd $HOME/.local/opt/JavaFXSceneBuilder*
	DIR=$(pwd)
	APP=$(ls JavaFXSceneBuilder* | awk '{printf("%s ", $1);}' | awk '{printf $1 ;}')
	cd $HOME
	$DIR/$APP < /dev/null > /dev/null 2>&1 &
	WGET "icon" https://cin.ufpe.br/~phts/CInstala/scenebuilder.png $DIR/app/scenebuilder.png
	cat << EOF > $HOME/.local/share/applications/scenebuilder.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Scene Builder
Icon=$DIR/app/scenebuilder.png
Exec=$DIR/$APP %f
Categories=Development;
Terminal=false
EOF
	LtL scenebuilder.desktop
	WMB "JavaFX Scene Builder installed successfully!"
}
function ITBA {
	CCC "Installing JetBrains Toolbox...\n\n"
	WGET "JetBrains Toolbox" "https://data.services.jetbrains.com/products/download?code=TBA&platform=linux" /tmp/tba.tgz
	TGZ "JetBrains Toolbox" /tmp/tba.tgz /tmp
	CP "JetBrains Toolbox" /tmp/jetbrains-toolbox-*/jetbrains-toolbox $HOME/.local/bin
	RM "temporary files" /tmp/tba.tgz /tmp/jetbrains-toolbox-*
	jetbrains-toolbox < /dev/null > /dev/null 2>&1 &
	WMB "JetBrains Toolbox installed successfully!"
}
function IAS {
	CCC "Installing Android Studio...\n\n"
	WGET "Android Studio" $(curl -Ls https://developer.android.com/r/studio-ui/download-stable.html | grep 'linux.zip' | grep 'android-studio-ide' | head -1 | cut -d \" -f2) /tmp/studio.zip
	RM "old versions of Android Studio" $HOME/.local/opt/android-studio
	UNZIP "Android Studio" /tmp/studio.zip $HOME/.local/opt
	RM "temporary files" /tmp/studio.zip
	source $HOME/.bashrc
	$HOME/.local/opt/android-studio/bin/studio.sh < /dev/null > /dev/null 2>&1 &
	cat << EOF > $HOME/.local/share/applications/jetbrains-studio.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=$HOME/.local/opt/android-studio/bin/studio.png
Exec=bash -i "$HOME/.local/opt/android-studio/bin/studio.sh" %f
Comment=Develop with pleasure!
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-studio
EOF
	LtL jetbrains-studio.desktop
	WMB "Android Studio installed successfully!"
}
function IST {
	CCC "Installing Sublime Text...\n\n"
	WGET "Sublime Text" https://download.sublimetext.com/sublime-text_build-3126_amd64.deb /tmp/subl.deb
	DPKG "Sublime Text" /tmp/subl.deb /tmp/subl
	CP "Sublime Text (part 1/2)" /tmp/subl/opt/* $HOME/.local/opt
	CP "Sublime Text (part 2/2)" /tmp/subl/usr/* $HOME/.local
	sed "s/\/opt/$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/bin/subl > $HOME/.local/bin/subl
	sed "s/\/opt/$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/share/applications/sublime_text.desktop > $HOME/.local/share/applications/sublime_text.desktop
	RM "temporary files" /tmp/subl*
	subl < /dev/null > /dev/null 2>&1 &
	LtL sublime_text.desktop
	WMB "Sublime Text installed successfully!"
}
function IA {
	CCC "Installing Atom...\n\n"
	WGET "Atom" https://atom-installer.github.com/v1.10.2/atom-amd64.deb /tmp/atom.deb
	dpkg -x /tmp/atom.deb /tmp/atom
	CP "Atom" /tmp/atom/usr/* $HOME/.local
	sed "s/\$USR_DIRECTORY/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/bin/atom > $HOME/.local/bin/atom
	sed "s/\/usr/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/share/applications/atom.desktop | sed "s/Icon=atom/Icon=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/share\/pixmaps\/atom.png/g" > $HOME/.local/share/applications/atom.desktop
	RM "temporary files" /tmp/atom*
	atom < /dev/null > /dev/null 2>&1 &
	LtL atom.desktop
	WMB "Atom installed successfully!"
}
function IQIWE {
	CCC "Installing Quartus II Web Edition...\n\n"
	mkdir -p /tmp/quartus
	WGET "Quartus II Web Edition (part 1/4)" http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/QuartusSetupWeb-13.1.0.162.run /tmp/quartus/quartus.run
	WGET "Quartus II Web Edition (part 2/4)" http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/max_web-13.1.0.162.qdz /tmp/quartus/max_web-13.1.0.162.qdz
	WGET "Quartus II Web Edition (part 3/4)" http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_installers/ModelSimSetup-13.1.0.162.run /tmp/quartus/modelsim.run
	DIR=$(pwd)
	cd /tmp/quartus
	APTGET "Quartus II Web Edition (part 4/4)" libxft2:i386 lib32ncurses5
	cd "$DIR"
	DPKG "Quartus II Web Edition (part 1/2)" /tmp/quartus/lib32ncurses5* /tmp/quartus
	DPKG "Quartus II Web Edition (part 2/2)" /tmp/quartus/libxft2* /tmp/quartus
	CP "Quartus II Web Edition (part 1/2)" /tmp/quartus/usr/* $HOME/.local
	CP "Quartus II Web Edition (part 2/2)" /tmp/quartus/usr/lib/i386-linux-gnu/* $HOME/.local/lib
	chmod +x /tmp/quartus/quartus.run
	/tmp/quartus/quartus.run
	chmod +x /tmp/quartus/modelsim.run
	/tmp/quartus/modelsim.run
	$HOME/altera/13.1/quartus/bin/quartus --64bit < /dev/null > /dev/null 2>&1 &
	RM "temporary files" /tmp/quartus
	cat << EOF > $HOME/.local/share/applications/quartus.desktop
[Desktop Entry]
Type=Application
Version=0.9.4
Name=Quartus II 13.1 (64-bit) Web Edition
Comment=Quartus II 13.1 (64-bit)
Icon=$HOME/altera/13.1/quartus/adm/quartusii.png
Exec=bash -i "$HOME/altera/13.1/quartus/bin/quartus" --64bit %f
Terminal=false
Path=$HOME/altera/13.1
EOF
	LtL quartus.desktop
	WMB "Quartus II Web Edition installed successfully!"
}
function ITW {
	CCC "Installing Tarski's World...\n\n"
	mkdir -p /tmp/tw
	curl 'https://ggweb.gradegrinder.net/downloader/TW$002fDedekind$002fTW-16_01-linux-x86_64-deb-installer.sh' -k | tail --lines=+161 > /tmp/tw/tw.tgz
	TGZ "Tarski's World (part 1/6)" /tmp/tw/tw.tgz /tmp/tw
	DPKG "Tarski's World (part 2/6)" /tmp/tw/op-Tarski-common-* /tmp/tw/deb
	DPKG "Tarski's World (part 3/6)" /tmp/tw/op-Tarski-doc-* /tmp/tw/deb
	DPKG "Tarski's World (part 4/6)" /tmp/tw/op-jre-* /tmp/tw/deb
	DPKG "Tarski's World (part 5/6)" /tmp/tw/op-submit-* /tmp/tw/deb
	DPKG "Tarski's World (part 6/6)" /tmp/tw/op-tarski-* /tmp/tw/deb
	CP "Tarski's World" /tmp/tw/deb/usr/* $HOME/.local
	sed "s/Exec=/Exec=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/bin\//g" /tmp/tw/deb/usr/share/applications/OP-tarski.desktop > $HOME/.local/share/applications/OP-tarski.desktop
	sed "s/Exec=/Exec=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/bin\//g" /tmp/tw/deb/usr/share/applications/OP-submit.desktop > $HOME/.local/share/applications/OP-submit.desktop
	ln -s "$HOME/.local/share/Tarski/TW Exercise Files" $HOME/Desktop
	RM "temporary files" /tmp/tw
	tarski < /dev/null > /dev/null 2>&1 &
	LtL OP-tarski.desktop
	LtL OP-submit.desktop
	WMB "Tarski's World installed successfully!"
}
function ISK {
	if (whiptail --yesno "$(L)" 0 0 --fb --title "Which version of Skype would you like to install?" --yes-button "Beta" --no-button "Stable") then
		CCC "Installing Skype for Linux Beta...\n\n"
		mkdir -p /tmp/skype
		WGET "Skype for Linux Beta" https://repo.skype.com/latest/skypeforlinux-64.deb /tmp/skype/skype.deb
		DPKG "Skype for Linux Beta" /tmp/skype/skype.deb /tmp/skype/deb
		CP "Skype for Linux Beta (part 1/2)" /tmp/skype/deb/usr/* $HOME/.local
		CP "Skype for Linux Beta (part 2/2)" /tmp/skype/deb/opt/* $HOME/.local/opt
		sed "s/\/usr/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/skype/deb/usr/share/applications/skypeforlinux.desktop > $HOME/.local/share/applications/skypeforlinux.desktop
		RM "temporary files" /tmp/skype
		skypeforlinux < /dev/null > /dev/null 2>&1 &
		LtL skypeforlinux.desktop
		WMB "Skype for Linux Beta installed successfully!"
	else
		CCC "Installing Skype...\n\n"
		mkdir -p /tmp/skype
		WGET "Skype (part 1/2)" https://download.skype.com/linux/skype-ubuntu-precise_4.3.0.37-1_i386.deb /tmp/skype/skype.deb
		DIR=$(pwd)
		cd /tmp/skype
		APTGET "Skype (part 2/2)" libxv1:i386 libxss1:i386 libqtdbus4:i386 libqtwebkit4:i386 libqt4-xml:i386 libqtgui4:i386 libqt4-network:i386 libqtcore4:i386 libqt4-opengl:i386 libaudio2:i386
		cd "$DIR"
		DPKG "Skype (part 1/11)" /tmp/skype/skype.deb /tmp/skype/deb
		DPKG "Skype (part 2/11)" /tmp/skype/libaudio2_* /tmp/skype/deb
		DPKG "Skype (part 3/11)" /tmp/skype/libqt4-network_* /tmp/skype/deb
		DPKG "Skype (part 4/11)" /tmp/skype/libqt4-opengl_* /tmp/skype/deb
		DPKG "Skype (part 5/11)" /tmp/skype/libqt4-xml_* /tmp/skype/deb
		DPKG "Skype (part 6/11)" /tmp/skype/libqtcore4_* /tmp/skype/deb
		DPKG "Skype (part 7/11)" /tmp/skype/libqtdbus4_* /tmp/skype/deb
		DPKG "Skype (part 8/11)" /tmp/skype/libqtgui4_* /tmp/skype/deb
		DPKG "Skype (part 9/11)" /tmp/skype/libqtwebkit4_* /tmp/skype/deb
		DPKG "Skype (part 10/11)" /tmp/skype/libxss1_* /tmp/skype/deb
		DPKG "Skype (part 11/11)" /tmp/skype/libxv1_* /tmp/skype/deb
		CP "Skype (part 1/2)" /tmp/skype/deb/usr/* $HOME/.local
		CP "Skype (part 2/2)" /tmp/skype/deb/etc/* $HOME/.local/etc
		sed 's/Exec=skype %U/Exec=bash -ic "skype %U"/g' /tmp/skype/deb/usr/share/applications/skype.desktop | sed "s/Icon=skype.png/Icon=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/share\/pixmaps\/skype.png/g" > $HOME/.local/share/applications/skype.desktop
		RM "temporary files" /tmp/skype
		skype < /dev/null > /dev/null 2>&1 &
		LtL skype.desktop
		WMB "Skype installed successfully!"
	fi
}
function IM {
	CCC "Installing Mars...\n\n"
	mkdir -p $HOME/.local/opt/mars
	WGET "Mars" http://courses.missouristate.edu/KenVollmar/MARS/MARS_4_5_Aug2014/Mars4_5.jar $HOME/.local/opt/mars/Mars4_5.jar
	unzip -p $HOME/.local/opt/mars/Mars4_5.jar images/MarsThumbnail.gif > $HOME/.local/opt/mars/MarsThumbnail.gif
	java -jar "$HOME/.local/opt/mars/Mars4_5.jar" < /dev/null > /dev/null 2>&1 &
	cat << EOF > $HOME/.local/share/applications/mars.desktop
[Desktop Entry]
Type=Application
Version=4.5
Name=Mars
Comment=Mips Assembler and Runtime Simulator
Icon=$HOME/.local/opt/mars/MarsThumbnail.gif
Exec=java -jar "$HOME/.local/opt/mars/Mars4_5.jar"
Terminal=false
EOF
	LtL mars.desktop
	WMB "Mars installed successfully!"
}
function ISP {
	CCC "Installing Spotify...\n\n"
	mkdir -p /tmp/spotify
	WGET "Spotify (part 1/2)" http://repository.spotify.com/pool/non-free/s/spotify/spotify-client-0.9.17_0.9.17.8.gd06432d.31-1_amd64.deb /tmp/spotify/spotify.deb
	DIR=$(pwd)
	cd /tmp/spotify
	APTGET "Spotify (part 2/2)" libgcrypt11
	cd "$DIR"
	DPKG "Spotify (part 1/2)" /tmp/spotify/spotify.deb /tmp/spotify/deb
	DPKG "Spotify (part 2/2)" /tmp/spotify/libgcrypt11_* /tmp/spotify/deb
	CP "Spotify (part 1/3)" /tmp/spotify/deb/usr/* $HOME/.local
	CP "Spotify (part 2/3)" /tmp/spotify/deb/opt/* $HOME/.local/opt
	CP "Spotify (part 3/3)" /tmp/spotify/deb/lib/* $HOME/.local/lib
	ln -s $HOME/.local/MobileSim/MobileSim $HOME/.local/bin/MobileSim
	sed "s/Icon=spotify-client/Icon=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/opt\/spotify\/spotify-client\/Icons\/spotify-linux-512.png/g" /tmp/spotify/deb/opt/spotify/spotify-client/spotify.desktop > $HOME/.local/share/applications/spotify.desktop
	unlink $HOME/.local/bin/spotify
	ln -s $HOME/.local/opt/spotify/spotify-client/spotify $HOME/.local/bin/spotify
	RM "temporary files" /tmp/spotify
	spotify < /dev/null > /dev/null 2>&1 &
	LtL spotify.desktop
	WMB "Spotify installed successfully!"
}
function ITGPL {
	CCC "Installing The Go Programming Language...\n\n"
	WGET "The Go Programming Language" https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz /tmp/go.tgz
	TGZ "The Go Programming Language" /tmp/go.tgz $HOME/.local
	RM "temporary files" /tmp/go.tgz
	printf '\nexport GOROOT=$HOME/.local/go\nexport PATH=$PATH:$GOROOT/bin\n' >> $HOME/.bashrc
	source $HOME/.bashrc
	WMB "The Go Programming Language installed successfully!"
}
function ISB {
	CCC "Installing DB Browser for SQLite...\n\n"
	mkdir -p /tmp/sqlitebrowser
	DIR=$(pwd)
	cd /tmp/sqlitebrowser
	APTGET "DB Browser for SQLite" sqlitebrowser libqcustomplot1.3 libqt5scintilla2.12
	cd "$DIR"
	DPKG "DB Browser for SQLite (part 1/4)" /tmp/sqlitebrowser/sqlitebrowser_* /tmp/sqlitebrowser/deb
	DPKG "DB Browser for SQLite (part 2/4)" /tmp/sqlitebrowser/libqcustomplot1.3_* /tmp/sqlitebrowser/deb
	DPKG "DB Browser for SQLite (part 3/4)" /tmp/sqlitebrowser/libqt5scintilla2-12v5_* /tmp/sqlitebrowser/deb
	DPKG "DB Browser for SQLite (part 4/4)" /tmp/sqlitebrowser/libqt5scintilla2-12v5-dbg_* /tmp/sqlitebrowser/deb
	CP "DB Browser for SQLite" /tmp/sqlitebrowser/deb/usr/* $HOME/.local
	RM "temporary files" /tmp/sqlitebrowser
	sqlitebrowser < /dev/null > /dev/null 2>&1 &
	LtL sqlitebrowser.desktop
	WMB "DB Browser for SQLite installed successfully!"
}
function IPR {
	CCC "Installing Pioneer Robots SDK!...\n\n"
	mkdir -p /tmp/prsdk
	DIR=$(pwd)
	cd /tmp/prsdk
	WGET "Pioneer Robots SDK (part 1/4)" http://robots.mobilerobots.com/ARIA/download/current/libaria_2.9.1+ubuntu16_amd64.deb /tmp/prsdk/libaria.deb
	WGET "Pioneer Robots SDK (part 2/4)" http://robots.mobilerobots.com/ARIA/download/current/libaria-java_2.9.1+ubuntu16_amd64.deb /tmp/prsdk/libaria-java.deb
	WGET "Pioneer Robots SDK (part 3/4)" http://robots.mobilerobots.com/ARIA/download/current/libaria-python_2.9.1+ubuntu16_amd64.deb /tmp/prsdk/libaria-python.deb
	WGET "Pioneer Robots SDK (part 4/4)" http://robots.mobilerobots.com/MobileSim/download/current/mobilesim_0.7.5+ubuntu12_i386.deb /tmp/prsdk/mobilesim.deb
	cd "$DIR"
	DPKG "Pioneer Robots SDK (part 1/4)" /tmp/prsdk/libaria.deb /tmp/prsdk/deb
	DPKG "Pioneer Robots SDK (part 2/4)" /tmp/prsdk/libaria-java.deb /tmp/prsdk/deb
	DPKG "Pioneer Robots SDK (part 3/4)" /tmp/prsdk/libaria-python.deb /tmp/prsdk/deb
	DPKG "Pioneer Robots SDK (part 4/4)" /tmp/prsdk/mobilesim.deb /tmp/prsdk/deb
	CP "Pioneer Robots SDK (part 1/2)" /tmp/prsdk/deb/etc/* $HOME/.local/etc
	CP "Pioneer Robots SDK (part 2/2)" /tmp/prsdk/deb/usr/local/* $HOME/.local
	CP "Pioneer Robots SDK (part 2/2)" /tmp/prsdk/deb/usr/share/* $HOME/.local/share
	ln -s $HOME/.local/Aria/lib/libAria.so $HOME/.local/lib/libAria.so
	ln -s $HOME/.local/Aria/lib/libArNetworking.so $HOME/.local/lib/libArNetworking.so
	ln -s $HOME/.local/MobileSim/MobileSim $HOME/.local/bin/MobileSim
	cat << EOF > $HOME/.local/share/applications/MobileSim.desktop
[Desktop Entry]
Version=1.0
Type=Application
Encoding=UTF-8
Name=MobileSim
Comment=Simulate MobileRobots/ActivMedia robots in their environment, for use with ARIA
Icon=$HOME/.local/MobileSim/icon.png
Path=$HOME/.local/bin
Exec=bash -ic "$HOME/.local/MobileSim/MobileSim"
Categories=Application;Science;
X-Desktop-File-Install-Version=0.22
EOF
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/Aria/lib
	export LIBRARY_PATH=$LD_LIBRARY_PATH
	export MOBILESIM=$HOME/.local/MobileSim
	export CPATH=$CPATH:$HOME/.local/Aria/include
	export CLASSPATH=$CLASSPATH:$HOME/.local/Aria/java/Aria.jar
	printf "\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/Aria/lib\nexport LIBRARY_PATH=$LD_LIBRARY_PATH\nexport MOBILESIM=$HOME/.local/MobileSim\nexport CPATH=$CPATH:$HOME/.local/Aria/include\nexport CLASSPATH=$CLASSPATH:$HOME/.local/Aria/java/Aria.jar\n" >> $HOME/.bashrc
	RM "temporary files" /tmp/prsdk
	MobileSim < /dev/null > /dev/null 2>&1 &
	LtL MobileSim.desktop
	WMB "Pioneer Robots SDK installed successfully!"

}
function IEC {
	CCC "Installing ERRCASE...\n\n"
	WGET "ERRCASE" https://gist.githubusercontent.com/t0rr3sp3dr0/6a8aee5e209af173d2908b073ecea720/raw/eercase.zip /tmp/eercase.zip
	UNZIP "ERRCASE" /tmp/eercase.zip $HOME/.local/opt
	mv $HOME/.local/opt/eercase* $HOME/.local/opt/eercase
	ln -s $HOME/.local/opt/eercase/eercase $HOME/.local/bin
	cat << EOF > $HOME/.local/share/applications/enhanced_entity-relationship__eer__case.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=EERCASE - Enhanced Entity-Relationship (EER) CASE 
Icon=enhanced_entity-relationship__eer__case.png
Path=$HOME
Exec=$HOME/.local/bin/eercase
StartupNotify=false
StartupWMClass=Enhanced Entity-Relationship (EER) CASE
OnlyShowIn=Unity;
X-UnityGenerated=true
EOF
	RM "temporary files" /tmp/eercase.zip
	DIR=$(pwd)
	cd $HOME
	eercase < /dev/null > /dev/null 2>&1 &
	cd "$DIR"
	LtL enhanced_entity-relationship__eer__case.desktop
	WMB "ERRCASE installed successfully!"
}
function INJ {
	CCC "Installing Node.js...\n\n"
	WGET "Node.js" https://nodejs.org/dist/v6.11.3/node-v6.11.3-linux-x64.tar.xz /tmp/node.txz
	TXZ "Node.js" /tmp/node.txz /tmp
	CP "Node.js (part 1/4)" /tmp/node*/bin $HOME/.local
	CP "Node.js (part 2/4)" /tmp/node*/include $HOME/.local
	CP "Node.js (part 3/4)" /tmp/node*/lib $HOME/.local
	CP "Node.js (part 4/4)" /tmp/node*/share $HOME/.local
	RM "temporary files" /tmp/node*
	WMB "Node.js installed successfully!"
}
function IVSC {
	CCC "Installing Visual Studio Code...\n\n"
	mkdir -p /tmp/code
	WGET "Visual Studio Code" https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable /tmp/code.deb
	DPKG "Visual Studio Code" /tmp/code.deb /tmp/code
	CP "Visual Studio Code" /tmp/code/usr/* $HOME/.local
	sed "s/\/usr/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/code/usr/share/applications/code.desktop > $HOME/.local/share/applications/code.desktop
	ln -s $HOME/.local/share/code/code $HOME/.local/bin
	RM "temporary files" /tmp/code*
	code < /dev/null > /dev/null 2>&1 &
	LtL code.desktop
	WMB "Visual Studio Code installed successfully!"
}
function CS {
	CCC "Installing SDKMAN!...\n\n"
	if [ -d "$SDKMAN_DIR" ]; then
		bash -i <(echo "sdk selfupdate force")
	else
		curl -s get.sdkman.io | bash
		source "$HOME/.sdkman/bin/sdkman-init.sh"
	fi
	CCC "SDKMAN! installed successfully!\n\n"
	IFS=$'\n'
	PS3='Please select an option: '
	list=$(curl -s "${SDKMAN_LEGACY_API}/candidates/list")
	commands=(`echo "$list" | grep "sdk" | cut -d "\$" -f2 | sed 's/^.//'`)
	options=(`echo "$list" | grep -A1 "\-\-" | grep -v "\-\-" | cut -d "(" -f1 | sed -e 's/^/Install /' | sed 's/.$//'`)
	options+=('Back')
	select opt in "${options[@]}"
	do
		case $opt in
			"Back")
				CCC "Hi, $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f 1)! It's $(date)\n\n"
				return
				;;
			*)
				for ((i=0; i<${#options[@]}; i++))
				do 
					if [ "${options[$i]}" = "$opt" ]; then
						CCC "Which version of $(echo ${options[$i]} | cut -d " " -f2-) you would like to install?\n\n"

						unset IFS
						PS3='Please select a version: '
						versions=(`curl -s "${SDKMAN_LEGACY_API}/candidates/$(echo ${commands[$i]} | cut -d ' ' -f3)/list" | grep "\."`)
						versions=(`for e in ${versions[@]}; do echo $e; done | sort`)
						versions+=('Back')
						select option in "${versions[@]}"
						do
							case $option in
								"Back")
									CCC "Hi, $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f 1)! It's $(date)\n\n"
									return
									;;
								*)
									for ((j=0; j<${#versions[@]}; j++)); do 
										if [ "${versions[$j]}" = "$option" ]; then
											CCC "Installing $(echo ${options[$i]} | cut -d " " -f2-) v$(echo ${versions[$j]})...\n\n"
											
											bash -i <(echo ${commands[$i]}" "${versions[$j]})

											CCC "$(echo ${options[$i]} | cut -d " " -f2-) v$(echo ${versions[$j]}) installed successfully!\n\n"
											PS3='Please select an option: '
											return
										fi
									done
									IO
									;;
							esac
						done
					fi
				done
				IO
				;;
		esac
	done
}
function INIT {
	trap NULL INT
	mkdir -p $HOME/.config/upstart
	mkdir -p $HOME/.gem
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.local/etc
	mkdir -p $HOME/.local/jvm
	mkdir -p $HOME/.local/lib
	mkdir -p $HOME/.local/lib/i386-linux-gnu
	mkdir -p $HOME/.local/lib/x86_64-linux-gnu
	mkdir -p $HOME/.local/opt
	mkdir -p $HOME/.local/share/applications
	mkdir -p $HOME/.ssh
	mkdir -p $HOME/git
	ln -s $HOME/.local/lib/i386-linux-gnu $HOME/.local/lib32 >/dev/null 2>&1
	if [ $? == 1 ]
	then
		cp -fR $HOME/.local/lib32/* $HOME/.local/lib/i386-linux-gnu >/dev/null 2>&1
		if [ $? == 0 ]
		then
			rm -fR $HOME/.local/lib32
			ln -s $HOME/.local/lib/i386-linux-gnu $HOME/.local/lib32
		fi
	fi
	ln -s $HOME/.local/lib/x86_64-linux-gnu $HOME/.local/lib64 >/dev/null 2>&1
	if [ $? == 1 ]
	then
		cp -fR $HOME/.local/lib64/* $HOME/.local/lib/x86_64-linux-gnu >/dev/null 2>&1
		if [ $? == 0 ]
		then
			rm -fR $HOME/.local/lib64
			ln -s $HOME/.local/lib/x86_64-linux-gnu $HOME/.local/lib64
		fi
	fi
	export PATH=$PATH:$HOME/.local/bin
	export GEM_HOME=$HOME/.gem
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib:$HOME/.local/lib32:$HOME/.local/lib64
	export LIBRARY_PATH=$LD_LIBRARY_PATH
	printf "\nexport PATH=\$PATH:$HOME/.local/bin\nexport GEM_HOME=$HOME/.gem\nexport LD_LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib32:$HOME/.local/lib64\nexport LIBRARY_PATH=$LD_LIBRARY_PATH\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	if [ -z "$(which pv 2>/dev/null)" ]
	then
		DIR=$(pwd)
		cd /tmp
		APTGET "pv" pv
		cd "$DIR"
		DPKG "pv" /tmp/pv* /tmp/pv
		CP "pv" /tmp/pv/usr/* $HOME/.local
		RM "temporary files" /tmp/pv*
	fi
	trap Q INT
	resize -s 26 80 >/dev/null 2>&1
}
INIT
CCC "Hi, $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f 1)! It's $(date)\n\n"
while (( 1 ))
do
	PS3='Please select an option: '
	CSE='#'
	options=("Setup Environment" "SDKMAN!" "Generate SSH Key" "Install Android Studio" "Install JetBrains Toolbox" "Install Atom" "Install Sublime Text" "Install Visual Studio Code" "Install Mars" "Install Quartus II Web Edition" "Install Tarski's World" "Install DB Browser for SQLite" "Install Pioneer Robots SDK" "Install EERCASE" "Install Go" "Install Java SE Development Kit" "Install JavaFX Scene Builder" "Install Node.js" "Install Skype" "Install Spotify" "Quit")
	if [ "$(dnsdomainname 2>&1)" == "windows.cin.ufpe.br" ]; then
		CSE="Setup Environment"
	fi
	select opt in "${options[@]}"
	do
		case $opt in
			$CSE)
				SE
				break
				;;
			"SDKMAN!")
				CS
				break
				;;
			"Generate SSH Key")
				DF GSK
				;;
			"Install Android Studio")
				DF IAS
				;;
			"Install JetBrains Toolbox")
				DF ITBA
				;;
			"Install Atom")
				DF IA
				;;
			"Install Sublime Text")
				DF IST
				;;
			"Install Visual Studio Code")
				DF IVSC
				;;
			"Install Mars")
				DF IM
				;;
			"Install Quartus II Web Edition")
				DF IQIWE
				;;
			"Install Tarski's World")
				DF ITW
				;;
			"Install DB Browser for SQLite")
				DF ISB
				;;
			"Install Pioneer Robots SDK")
				DF IPR
				;;
			"Install EERCASE")
				DF IEC
				;;
			"Install Go")
				DF ITGPL
				;;
			"Install Java SE Development Kit")
				DF IJSDK
				;;
			"Install JavaFX Scene Builder")
				DF IJSB
				;;
			"Install Node.js")
				DF INJ
				;;
			"Install Skype")
				DF ISK
				;;
			"Install Spotify")
				DF ISP
				;;
			"Quit")
				Q
				;;
			*)
				IO
				;;
		esac
	done
done
