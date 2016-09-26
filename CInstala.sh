#!/bin/bash
function CCC {
	clear && clear
	cat << EOF
CCCCCCCC  IIII
CC         II
CC         II
CC         II
CC         II   nnnn  ssss   t    aaaa  ll   aaaa
CC         II   n  n  ss    ttt      a   l      a
CC         II   n  n    ss   t    aaaa   l   aaaa
CCCCCCCC  IIII  n  n  ssss   ttt  aaaa   ll  aaaa

                                          by @t0rr3sp3dr0

EOF
printf "$1"
}
function LtL {
	favorites=$(
python << EOF
from collections import OrderedDict
array = eval("$(gsettings get com.canonical.Unity.Launcher favorites)")
print(str(list(OrderedDict.fromkeys(array[:-3] + ["$1"] + array[-3:]))))
EOF
)
	gsettings reset com.canonical.Unity.Launcher favorites
	gsettings set com.canonical.Unity.Launcher favorites "$favorites"
	compiz --display :0 --replace < /dev/null > /dev/null 2>&1& disown
}
function SE {
	# wget https://cin.ufpe.br/~phts/CInstala/background.jpg -O $HOME/.background
	# gsettings set org.gnome.desktop.background picture-uri file://$HOME/.background
	wget https://gist.githubusercontent.com/t0rr3sp3dr0/7f9c29cc8ddda2becbab7f7a2a3cf8c9/raw/.vimrc -O $HOME/.vimrc
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
	gsettings reset org.gnome.desktop.background picture-uri < /dev/null > /dev/null 2>&1&
end script
EOF
	find $HOME -type d -print0 | xargs -0 chmod 700
	find $HOME -type f -print0 | xargs -0 chmod 600
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
	setxkbmap us,us altgr-intl,
	printf "\nsetxkbmap us,us altgr-intl,\n" >> $HOME/.bashrc
	CCC "Environment setted up with success!\n\n"
}
function GSK {
	ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f $HOME/.ssh/id_rsa
	wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xclip/xclip_0.12+svn84-4_amd64.deb -O /tmp/xclip.deb
	dpkg -x /tmp/xclip.deb /tmp/xclip
	cp -fRv /tmp/xclip/usr/* $HOME/.local
	rm -fRv /tmp/xclip*
	cat $HOME/.ssh/id_rsa.pub | xclip -selection c
	CCC "Public SSH Key copied to clipboard!\n\n"
}
function USKtG {
	gnome-terminal -e "firefox https://github.com/settings/keys"
	echo
}
function IJSDK {
	wget http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/jdk.tgz
	rm -fRv $HOME/.local/jvm/jdk*
	tar -xzvf /tmp/jdk.tgz -C $HOME/.local/jvm
	rm -fRv /tmp/jdk.tgz
	export JDK_HOME=$HOME/.local/jvm/jdk*
	export JAVA_HOME=$JDK_HOME
	export PATH=$PATH:$JAVA_HOME/bin
	printf "\nexport JDK_HOME=\$HOME/.local/jvm/jdk*\nexport JAVA_HOME=\$JDK_HOME\nexport PATH=\$PATH:\$JAVA_HOME/bin\n" >> $HOME/.bashrc
	CCC "Java SE Development Kit installed successfully!\n\n"
}
function IJSB {
	wget http://download.oracle.com/otn-pub/java/javafx_scenebuilder/2.0-b20/javafx_scenebuilder-2_0-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/scenebuilder.tgz
	tar -xzvf /tmp/scenebuilder.tgz -C $HOME/.local/opt
	rm -fRv /tmp/scenebuilder.tgz
	cd $HOME/.local/opt/JavaFXSceneBuilder*
	DIR=$(pwd)
	APP=$(ls JavaFXSceneBuilder* | awk '{printf("%s ", $1);}' | awk '{printf $1 ;}')
	cd $HOME
	gnome-terminal -e "$DIR/$APP"
	wget https://cin.ufpe.br/~phts/CInstala/scenebuilder.png -O $DIR/app/scenebuilder.png
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
	chmod +x $HOME/.local/share/applications/scenebuilder.desktop
	LtL scenebuilder.desktop < /dev/null > /dev/null 2>&1&
	CCC "JavaFX Scene Builder installed successfully!\n\n"
}
function IIIU {
	wget https://download-cf.jetbrains.com/idea/ideaIU-2016.2.tar.gz -O /tmp/idea.tgz
	rm -fRv $HOME/.local/opt/idea-*
	tar -xzvf /tmp/idea.tgz -C $HOME/.local/opt
	rm -fRv /tmp/idea.tgz
	export IDEA_JDK=$JAVA_HOME
	export IDEA_JDK_64=$IDEA_JDK
	printf "\nexport IDEA_JDK=\$JAVA_HOME\nexport IDEA_JDK_64=\$IDEA_JDK\n" >> $HOME/.bashrc
	cd $HOME/.local/opt/idea-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.IntelliJIdea$VER/config/options
	wget https://cin.ufpe.br/~phts/CInstala/options.tar.gz -O /tmp/options.tgz
	tar -xzvf /tmp/options.tgz -C $HOME/.IntelliJIdea$VER/config/options/
	gnome-terminal -e "bash -i $DIR/bin/idea.sh"
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
	chmod +x $HOME/.local/share/applications/jetbrains-idea.desktop
	LtL jetbrains-idea.desktop < /dev/null > /dev/null 2>&1&
	CCC "IntelliJ IDEA Ultimate installed successfully!\n\n"
}
function IC {
	wget https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz -O /tmp/clion.tgz
	rm -fRv $HOME/.local/opt/clion-*
	tar -xzvf /tmp/clion.tgz -C $HOME/.local/opt
	rm -fRv /tmp/clion.tgz
	export CL_JDK=$JAVA_HOME
	printf "\nexport CL_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	cd $HOME/.local/opt/clion-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.CLion$VER/config/options
	wget https://cin.ufpe.br/~phts/CInstala/options.tar.gz -O /tmp/options.tgz
	tar -xzvf /tmp/options.tgz -C $HOME/.CLion$VER/config/options/
	gnome-terminal -e "bash -i $DIR/bin/clion.sh"
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
	chmod +x $HOME/.local/share/applications/jetbrains-clion.desktop
	LtL jetbrains-clion.desktop < /dev/null > /dev/null 2>&1&
	CCC "CLion installed successfully!\n\n"
}
function IPP {
	wget https://download.jetbrains.com/python/pycharm-professional-2016.2.tar.gz -O /tmp/pycharm.tgz
	rm -fRv $HOME/.local/opt/pycharm-*
	tar -xzvf /tmp/pycharm.tgz -C $HOME/.local/opt
	rm -fRv /tmp/pycharm.tgz
	export PYCHARM_JDK=$JAVA_HOME
	printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	cd $HOME/.local/opt/pycharm-*
	DIR=$(pwd)
	VER=$(pwd | sed -e 's/\/.*\-//g')
	cd $HOME
	mkdir -p $HOME/.PyCharm$VER/config/options
	wget https://cin.ufpe.br/~phts/CInstala/options.tar.gz -O /tmp/options.tgz
	tar -xzvf /tmp/options.tgz -C $HOME/.PyCharm$VER/config/options/
	gnome-terminal -e "bash -i $DIR/bin/pycharm.sh"
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
	chmod +x $HOME/.local/share/applications/jetbrains-pycharm.desktop
	LtL jetbrains-pycharm.desktop < /dev/null > /dev/null 2>&1&
	CCC "PyCharm Professional installed successfully!\n\n"
}
function IAS {
	wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip -O /tmp/studio.zip
	rm -fRv $HOME/.local/opt/android-studio
	unzip /tmp/studio.zip -d $HOME/.local/opt
	rm -fRv /tmp/studio.zip
	export STUDIO_JDK=$JAVA_HOME
	printf "\nexport STUDIO_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	gnome-terminal -e "bash -i $HOME/.local/opt/android-studio/bin/studio.sh"
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
	chmod +x $HOME/.local/share/applications/jetbrains-studio.desktop
	LtL jetbrains-studio.desktop < /dev/null > /dev/null 2>&1&
	CCC "Android Studio installed successfully!\n\n"
}
function IV {
	bash <(curl https://raw.githubusercontent.com/vim-scripts/vim7-install.sh/master/vim7-install.sh)
	CCC "VIm installed successfully!\n\n"
}
function IST {
	wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb -O /tmp/subl.deb
	dpkg -x /tmp/subl.deb /tmp/subl
	cp -fRv /tmp/subl/opt/* $HOME/.local/opt
	cp -fRv /tmp/subl/usr/* $HOME/.local
	sed "s/\/opt/$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/bin/subl > $HOME/.local/bin/subl
	sed "s/\/opt/$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/share/applications/sublime_text.desktop > $HOME/.local/share/applications/sublime_text.desktop
	rm -fRv /tmp/subl*
	gnome-terminal -e "bash -i subl"
	LtL sublime_text.desktop < /dev/null > /dev/null 2>&1&
	CCC "Sublime Text installed successfully!\n\n"
}
function IOCT {
	gem install rhc
	gnome-terminal -e "bash -i rhc setup"
	CCC "OpenShift Client Tools installed successfully!\n\n"
}
function IA {
	wget https://atom-installer.github.com/v1.10.2/atom-amd64.deb -O /tmp/atom.deb
	dpkg -x /tmp/atom.deb /tmp/atom
	cp -fRv /tmp/atom/usr/* $HOME/.local
	sed "s/\$USR_DIRECTORY/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/bin/atom > $HOME/.local/bin/atom
	sed "s/\/usr/$(echo $HOME | sed -e 's/\//\\\//g')\/.local/g" /tmp/atom/usr/share/applications/atom.desktop | sed "s/Icon=atom/Icon=$(echo $HOME | sed -e 's/\//\\\//g')\/.local\/share\/pixmaps\/atom.png/g" > $HOME/.local/share/applications/atom.desktop
	rm -fRv /tmp/atom*
	gnome-terminal -e "bash -i atom"
	LtL atom.desktop < /dev/null > /dev/null 2>&1&
	CCC "Atom installed successfully!\n\n"
}
function EL {
	if [ $? -eq 0 ]
	then
		CCC "$1! Press any key to continue...\n\n"
	else
		CCC "Something went wrong! Please try again...\n\n"
	fi
}
mkdir -p $HOME/.config/upstart
mkdir -p $HOME/.gem
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/jvm
mkdir -p $HOME/.local/opt
mkdir -p $HOME/.local/share/applications
mkdir -p $HOME/.ssh
mkdir -p $HOME/git
export PATH=$PATH:$HOME/.local/bin
export GEM_HOME=$HOME/.gem
printf "\nexport PATH=\$PATH:\$HOME/.local/bin\nexport GEM_HOME=\$HOME/.gem\n" >> $HOME/.bashrc
CCC  # "Wellcome, $(finger -s `whoami` | awk '{printf("%s\n", $2);}' | sort -u | grep -iv Name)!\n\n"
PS3='Please select an option: '
options=("Setup Environment" "Generate SSH Key" "Upload SSH Key to GitHub" "Install Java SE Development Kit" "Install JavaFX Scene Builder" "Install IntelliJ IDEA Ultimate" "Install CLion" "Install PyCharm Professional" "Install Android Studio" "Install VIm" "Install Sublime Text" "Install OpenShift Client Tools" "Install Atom" "Bundles" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Setup Environment")
			SE
			;;
		"Generate SSH Key")
			GSK
			;;
		"Upload SSH Key to GitHub")
			USKtG
			;;
		"Install Java SE Development Kit")
			IJSDK
			;;
		"Install JavaFX Scene Builder")
			IJSB
			;;
		"Install IntelliJ IDEA Ultimate")
			IIIU
			;;
		"Install CLion")
			IC
			;;
		"Install PyCharm Professional")
			IPP
			;;
		"Install Android Studio")
			IAS
			;;
		"Install VIm")
			IV
			;;
		"Install Sublime Text")
			IST
			;;
		"Install OpenShift Client Tools")
			IOCT
			;;
		"Install Atom")
			IA
			;;
		"Bundles")
			CCC
			options=("LookMobile" "Singularity" "Back")
			select opt in "${options[@]}"
			do
				case $opt in
					"LookMobile")
						CCC
						options=("Setup Environment" "Clone Repositories" "Back")
						select opt in "${options[@]}"
						do
							case $opt in
								"Setup Environment")
									SE
									GSK
									USKtG
									IJSDK
									IJSB
									IIIU
									IC
									IPP
									EL "Done"
									read

									break
									;;
								"Clone Repositories")
									CCC
									options=("Náutico (Android)" "Náutico (BackEnd)" "LookEsporte" "Back")
									select opt in "${options[@]}"
									do
										case $opt in
											"LookEsporte")
												git clone git@github.com:t0rr3sp3dr0/lookEsporte-Python.git $HOME/git/lookEsporte-Python
												EL "Done"
												read

												break
												;;
											"Náutico (Android)")
												git clone git@github.com:t0rr3sp3dr0/N-utico-Android.git $HOME/git/N-utico-Android
												EL "Done"
												read

												break
												;;
											"Náutico (BackEnd)")
												git clone git@github.com:t0rr3sp3dr0/N-utico-BackEnd.git $HOME/git/N-utico-BackEnd
												EL "Done"
												read

												break
												;;
											"Back")
												break
												;;
											*)
												printf "\nInvalid Option!\n\n"
												;;
										esac
									done

									break
									;;
								"Back")
									break
									;;
								*)
									printf "\nInvalid Option!\n\n"
									;;
							esac
						done

						break
						;;
					"Singularity")
						CCC
						options=("Setup Environment" "Clone Repositories" "Back")
						select opt in "${options[@]}"
						do
							case $opt in
								"Setup Environment")
									SE
									GSK
									USKtG
									IJSDK
									IJSB
									IIIU
									IC
									IPP
									EL "Done"
									read

									break
									;;
								"Clone Repositories")
									CCC
									options=("BuildWare" "Direct" "Back")
									select opt in "${options[@]}"
									do
										case $opt in
											"BuildWare")
												git clone git@github.com:t0rr3sp3dr0/buildWare-JavaFX.git $HOME/git/buildWare-JavaFX
												EL "Done"
												read

												break
												;;
											"Direct")
												git clone git@github.com:lvrma/Direct-Singularity.git $HOME/git/Direct-Singularity
												EL "Done"
												read

												break
												;;
											"Back")
												break
												;;
											*)
												printf "\nInvalid Option!\n\n"
												;;
										esac
									done

									break
									;;
								"Back")
									break
									;;
								*)
									printf "\nInvalid Option!\n\n"
									;;
							esac
						done

						break
						;;
					"Back")
						break
						;;
					*)
						printf "\nInvalid Option!\n\n"
						;;
				esac
			done

			CCC
			;;
		"Quit")
			clear && clear
			break
			;;
		*)
			printf "\nInvalid Option!\n\n"
			;;
	esac
done
