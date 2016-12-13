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
function LtL {
	favorites=$(
python << EOF
from collections import OrderedDict
array = eval("$(gsettings get com.canonical.Unity.Launcher favorites)")
print(str(list(OrderedDict.fromkeys(array[:-3] + ["$1"] + array[-3:]))))
EOF
)
	gsettings set com.canonical.Unity.Launcher favorites "$favorites"
}
function DFI {
	desktop-file-install --dir=$HOME/.local/share/applications "$HOME/.local/share/applications/$1"
}
function DF {
	tput cuu1
	tput el
	CMD="$(declare -f L);$(declare -f LtL);$(declare -f DFI);$(declare -f DF);$(declare -f Q);trap Q INT;$(declare -f CCC);$(declare -f IO);$(declare -f WMB);$(declare -f WGET);$(declare -f TAR);$(declare -f CP);$(declare -f RM);$(declare -f UNZIP);$(declare -f DPKG);$(declare -f APTGET);$(declare -f $1);$1"
	gnome-terminal -e "bash -ic '${CMD//\'/\'\"\'\"\'}'"
}
function Q {
	tput clear
	tput reset
	exit
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
function TAR {
	( pv -n "$2" | tar -xzf - -C "$3" ) 2>&1 | whiptail --title "CInstala" --gauge "\nExtracting $1..." 0 0 0
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
	CCC "Setting up Environment...\n\n"
	WGET ".vimrc" https://gist.githubusercontent.com/t0rr3sp3dr0/7f9c29cc8ddda2becbab7f7a2a3cf8c9/raw/.vimrc $HOME/.vimrc
	cat << EOF > $HOME/.config/upstart/desktopClose.conf
description "Desktop Close Task"
start on session-end
task
script
	rm -fR $HOME/.*_history < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/.mozilla/firefox/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/.ssh/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/Desktop/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/Documents/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/Downloads/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/git/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/AndroidStudioProjects/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/ClionProjects/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/IdeaProjects/* < /dev/null > /dev/null 2>&1&
	rm -fR $HOME/PycharmProjects/* < /dev/null > /dev/null 2>&1&
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
}
function GSK {
	CCC "Generating SSH Key...\n\n"
	ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f $HOME/.ssh/id_rsa
	cat $HOME/.ssh/id_rsa.pub | xclip -selection c
	if (whiptail --yesno "$(L)" 0 0 --fb --title "Public SSH Key copied to clipboard! Would you like to upload it to GitHub?") then
	    firefox https://github.com/settings/keys < /dev/null > /dev/null 2>&1&
	fi
}
function IJSDK {
	CCC "Installing Java SE Development Kit...\n\n"
	WGET "Java SE Development Kit" http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz /tmp/jdk.tgz "Cookie: oraclelicense=accept-securebackup-cookie;"
	RM "old versions of Java SE Development Kit" $HOME/.local/jvm/jdk*
	TAR "Java SE Development Kit" /tmp/jdk.tgz $HOME/.local/jvm
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
	TAR "JavaFX Scene Builder" /tmp/scenebuilder.tgz $HOME/.local/opt
	RM "temporary files" /tmp/scenebuilder.tgz
	cd $HOME/.local/opt/JavaFXSceneBuilder*
	DIR=$(pwd)
	APP=$(ls JavaFXSceneBuilder* | awk '{printf("%s ", $1);}' | awk '{printf $1 ;}')
	cd $HOME
	$DIR/$APP < /dev/null > /dev/null 2>&1&
	WGET "Icon" https://cin.ufpe.br/~phts/CInstala/scenebuilder.png $DIR/app/scenebuilder.png
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
	DFI scenebuilder.desktop
	LtL scenebuilder.desktop
	WMB "JavaFX Scene Builder installed successfully!"
}
function IIIU {
	CCC "Installing IntelliJ IDEA Ultimate...\n\n"
	WGET "IntelliJ IDEA Ultimate" https://download.jetbrains.com/idea/ideaIU-2016.2.5.tar.gz /tmp/idea.tgz
	RM "old versions of IntelliJ IDEA Ultimate" $HOME/.local/opt/idea-*
	TAR "IntelliJ IDEA Ultimate" /tmp/idea.tgz $HOME/.local/opt
	export IDEA_JDK=$JAVA_HOME
	export IDEA_JDK_64=$IDEA_JDK
	printf "\nexport IDEA_JDK=\$JAVA_HOME\nexport IDEA_JDK_64=\$IDEA_JDK\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	cd $HOME/.local/opt/idea-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.IntelliJIdea$VER/config/options
	WGET "options" https://cin.ufpe.br/~phts/CInstala/options.tar.gz /tmp/options.tgz
	TAR "options" /tmp/options.tgz $HOME/.IntelliJIdea$VER/config/options/
	RM "temporary files" /tmp/idea.tgz /tmp/options.tgz
	$DIR/bin/idea.sh < /dev/null > /dev/null 2>&1&
	cat << EOF > $HOME/.local/share/applications/jetbrains-idea.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA
Icon=$DIR/bin/idea.png
Exec=bash -i "$DIR/bin/idea.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea
EOF
	DFI jetbrains-idea.desktop
	LtL jetbrains-idea.desktop
	WMB "IntelliJ IDEA Ultimate installed successfully!"
}
function IC {
	CCC "Installing CLion...\n\n"
	WGET "CLion" https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz /tmp/clion.tgz
	RM "old versions of CLion" $HOME/.local/opt/clion-*
	TAR "CLion" /tmp/clion.tgz $HOME/.local/opt
	export CL_JDK=$JAVA_HOME
	printf "\nexport CL_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	cd $HOME/.local/opt/clion-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.CLion$VER/config/options
	WGET "options" https://cin.ufpe.br/~phts/CInstala/options.tar.gz /tmp/options.tgz
	TAR "options" /tmp/options.tgz $HOME/.CLion$VER/config/options/
	RM "temporary files" /tmp/idea.tgz /tmp/options.tgz
	$DIR/bin/clion.sh < /dev/null > /dev/null 2>&1&
	cat << EOF > $HOME/.local/share/applications/jetbrains-clion.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=CLion
Icon=$DIR/bin/clion.svg
Exec=bash -i "$DIR/bin/clion.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-clion
EOF
	DFI jetbrains-clion.desktop
	LtL jetbrains-clion.desktop
	WMB "CLion installed successfully!"
}
function IPP {
	CCC "Installing PyCharm Professional...\n\n"
	WGET "PyCharm Professional" https://download.jetbrains.com/python/pycharm-professional-2016.2.3.tar.gz /tmp/pycharm.tgz
	RM "old versions of PyCharm Professional" $HOME/.local/opt/pycharm-*
	TAR "PyCharm Professional" /tmp/pycharm.tgz $HOME/.local/opt
	export PYCHARM_JDK=$JAVA_HOME
	printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	cd $HOME/.local/opt/pycharm-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.PyCharm$VER/config/options
	WGET "options" https://cin.ufpe.br/~phts/CInstala/options.tar.gz /tmp/options.tgz
	TAR "options" /tmp/options.tgz $HOME/.PyCharm$VER/config/options/
	RM "temporary files" /tmp/pycharm.tgz /tmp/options.tgz
	$DIR/bin/pycharm.sh < /dev/null > /dev/null 2>&1&
	cat << EOF > $HOME/.local/share/applications/jetbrains-pycharm.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Icon=$DIR/bin/pycharm.png
Exec=bash -i "$DIR/bin/pycharm.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOF
	DFI jetbrains-pycharm.desktop
	LtL jetbrains-pycharm.desktop
	WMB "PyCharm Professional installed successfully!"
}
function IAS {
	CCC "Installing Android Studio...\n\n"
	WGET "Android Studio" https://dl.google.com/dl/android/studio/ide-zips/2.2.2.0/android-studio-ide-145.3360264-linux.zip /tmp/studio.zip
	RM "old versions of Android Studio" $HOME/.local/opt/android-studio
	UNZIP /tmp/studio.zip $HOME/.local/opt
	RV "temporary files" /tmp/studio.zip
	export STUDIO_JDK=$JAVA_HOME
	printf "\nexport STUDIO_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	$HOME/.local/opt/android-studio/bin/studio.sh < /dev/null > /dev/null 2>&1&
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
	DFI jetbrains-studio.desktop
	LtL jetbrains-studio.desktop
	WMB "Android Studio installed successfully!"
}
function IV {
	CCC "Installing VIm...\n\n"
	bash <(curl https://raw.githubusercontent.com/vim-scripts/vim7-install.sh/master/vim7-install.sh)
	WMB "VIm installed successfully!"
	vim
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
	subl < /dev/null > /dev/null 2>&1&
	DFI sublime_text.desktop
	LtL sublime_text.desktop
	WMB "Sublime Text installed successfully!"
}
function IOCT {
	CCC "Installing OpenShift Client Tools...\n\n"
	gem install rhc
	gnome-terminal -e "bash -i rhc setup"
	CCC "OpenShift Client Tools installed successfully!\n\n"
}
function IA {
	CCC "Installing Atom...\n\n"
	WGET "Atom" https://atom-installer.github.com/v1.10.2/atom-amd64.deb /tmp/atom.deb
	dpkg -x /tmp/atom.deb /tmp/atom
	CP "Atom" /tmp/atom/usr/* $HOME/.local
	sed "s/\$USR_DIRECTORY/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/bin/atom > $HOME/.local/bin/atom
	sed "s/\/usr/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/share/applications/atom.desktop | sed "s/Icon=atom/Icon=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/share\/pixmaps\/atom.png/g" > $HOME/.local/share/applications/atom.desktop
	RM "temporary files" /tmp/atom*
	atom < /dev/null > /dev/null 2>&1&
	DFI atom.desktop
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
	$HOME/altera/13.1/quartus/bin/quartus --64bit < /dev/null > /dev/null 2>&1&
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
	DFI quartus.desktop
	LtL quartus.desktop
	WMB "Quartus II Web Edition installed successfully!"
}
function IGPP6 {
	CCC "Installing G++ 6...\n\n"
	WGET "G++ 6" http://mirrors.kernel.org/ubuntu/pool/main/g/gcc-6/g++-6_6.2.0-5ubuntu12_amd64.deb /tmp/g++.deb
	DPKG "G++ 6" /tmp/g++.deb /tmp/g++
	CP "G++ 6" /tmp/g++/usr/* $HOME/.local
	RM "temporary files" /tmp/g++
	printf "\nalias g++=g++-6\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	CCC "G++ 6 installed successfully!\n\n"
}
function ITW {
	CCC "Installing Tarski's World...\n\n"
	mkdir -p /tmp/tw
	curl 'https://ggweb.gradegrinder.net/downloader/TW$002fDedekind$002fTW-16_01-linux-x86_64-deb-installer.sh' -k | tail --lines=+161 > /tmp/tw/tw.tgz
	TAR "Tarski's World (part 1/6)" /tmp/tw/tw.tgz /tmp/tw
	DPKG "Tarski's World (part 2/6)" /tmp/tw/op-Tarski-common-15.01-0_all.deb /tmp/tw/deb
	DPKG "Tarski's World (part 3/6)" /tmp/tw/op-Tarski-doc-15.01-0_all.deb /tmp/tw/deb
	DPKG "Tarski's World (part 4/6)" /tmp/tw/op-jre-1.7.0-60_amd64.deb /tmp/tw/deb
	DPKG "Tarski's World (part 5/6)" /tmp/tw/op-submit-3.0-7_all.deb /tmp/tw/deb
	DPKG "Tarski's World (part 6/6)" /tmp/tw/op-tarski-7.2-3_all.deb /tmp/tw/deb
	CP "Tarski's World" /tmp/tw/deb/usr/* $HOME/.local
	sed "s/Exec=/Exec=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/bin\//g" /tmp/tw/deb/usr/share/applications/OP-tarski.desktop > $HOME/.local/share/applications/OP-tarski.desktop
	sed "s/Exec=/Exec=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/bin\//g" /tmp/tw/deb/usr/share/applications/OP-submit.desktop > $HOME/.local/share/applications/OP-submit.desktop
	ln -s "$HOME/.local/share/Tarski/TW Exercise Files" $HOME/Desktop
	RM "temporary files" /tmp/tw
	$HOME/.local/bin/tarski < /dev/null > /dev/null 2>&1&
	DFI OP-tarski.desktop
	DFI OP-submit.desktop
	LtL OP-tarski.desktop
	LtL OP-submit.desktop
	WMB "Tarski's World installed successfully!"
}
function IS {
	CCC "Installing SDKMAN!...\n\n"
	if [ -d "$SDKMAN_DIR" ]; then
		bash -i <(echo "sdk selfupdate force")
	else
		curl -s get.sdkman.io | bash
		source "$HOME/.sdkman/bin/sdkman-init.sh"
	fi
	CCC "SDKMAN! installed successfully!\n\n"
}
function EL {
	if [ $? -eq 0 ]
	then
		CCC "$1! Press any key to continue...\n\n"
	else
		CCC "Something went wrong! Please try again...\n\n"
	fi
}
function CS {
	IS
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
	trap Q INT
	mkdir -p $HOME/.config/upstart
	mkdir -p $HOME/.gem
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.local/jvm
	mkdir -p $HOME/.local/lib
	mkdir -p $HOME/.local/lib32
	mkdir -p $HOME/.local/lib64
	mkdir -p $HOME/.local/opt
	mkdir -p $HOME/.local/share/applications
	mkdir -p $HOME/.ssh
	mkdir -p $HOME/git
	export PATH=$PATH:$HOME/.local/bin
	export GEM_HOME=$HOME/.gem
	export LD_LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib32:$HOME/.local/lib64
	printf "\nexport PATH=\$PATH:$HOME/.local/bin\nexport GEM_HOME=$HOME/.gem\nexport LD_LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib32:$HOME/.local/lib64\n" >> $HOME/.bashrc
	source $HOME/.bashrc
	if [ -z "$(which xclip 2>/dev/null 2>/dev/null)" ]; then
		DIR=$(pwd)
		cd /tmp
		APTGET "xclip" xclip
		cd "$DIR"
		DPKG "xclip" /tmp/xclip* /tmp/xclip
		CP "xclip" /tmp/xclip/usr/* $HOME/.local
		RM "temporary files" /tmp/xclip*
	fi
	if [ -z "$(which pv 2>/dev/null 2>/dev/null)" ]; then
		DIR=$(pwd)
		cd /tmp
		APTGET "pv" pv
		cd "$DIR"
		DPKG "pv" /tmp/pv* /tmp/pv
		CP "pv" /tmp/pv/usr/* $HOME/.local
		RM "temporary files" /tmp/pv*
	fi
}
INIT
CCC "Hi, $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1 | cut -d ' ' -f 1)! It's $(date)\n\n"
while (( 1 ))
do
	PS3='Please select an option: '
	CSE='#'
	options=("Setup Environment" "Generate SSH Key" "SDKMAN!" "Install Java SE Development Kit 8" "Install JavaFX Scene Builder" "Install Android Studio" "Install CLion" "Install IntelliJ IDEA Ultimate" "Install PyCharm Professional" "Install Atom" "Install Sublime Text" "Install VIm" "Install Quartus II Web Edition" "Install Tarski's World" "Install G++ 6" "Install OpenShift Client Tools" "Quit")
	if [ "$(dnsdomainname 2>/dev/null 2>/dev/null)" == "windows.cin.ufpe.br" ]; then
		CSE="Setup Environment"
	fi
	select opt in "${options[@]}"
	do
		case $opt in
			$CSE)
				SE
				break
				;;
			"Generate SSH Key")
				DF GSK
				;;
			"SDKMAN!")
				CS
				break
				;;
			"Install Java SE Development Kit 8")
				DF IJSDK
				;;
			"Install JavaFX Scene Builder")
				DF IJSB
				;;
			"Install Android Studio")
				DF IAS
				;;
			"Install CLion")
				DF IC
				;;
			"Install IntelliJ IDEA Ultimate")
				DF IIIU
				;;
			"Install PyCharm Professional")
				DF IPP
				;;
			"Install Atom")
				DF IA
				;;
			"Install Sublime Text")
				DF IST
				;;
			"Install VIm")
				DF IV
				;;
			"Install Quartus II Web Edition")
				DF IQIWE
				;;
			"Install Tarski's World")
				DF ITW
				;;
			"Install G++ 6")
				IGPP6
				break
				;;
			"Install OpenShift Client Tools")
				IOCT
				break
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