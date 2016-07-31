#!/bin/bash
function CCC {
	clear && clear
	cat << EOF
CCCCCCCC  IIII
CC         II
CC         II
CC         II
CC         II   nnnn  ssss   t    aaaa  l  aaaa
CC         II   n  n  ss    ttt      a  l     a
CC         II   n  n    ss   t    aaaa  l  aaaa
CCCCCCCC  IIII  n  n  ssss   ttt  aaaa  l  aaaa

EOF
printf "$1"
}
function LtL {
	gsettings set com.canonical.Unity.Launcher favorites "$(
python << EOF
from collections import OrderedDict
array = eval("$(gsettings get com.canonical.Unity.Launcher favorites)")
print(str(list(OrderedDict.fromkeys(array[:-4] + ["$1"] + array[-4:]))))
EOF
)"
}
function SE {
	curl https://gist.githubusercontent.com/t0rr3sp3dr0/7f9c29cc8ddda2becbab7f7a2a3cf8c9/raw/.vimrc -o $HOME/.vimrc
	cat << EOF > $HOME/.config/upstart/desktopOpen.conf
description "Desktop Open Task"
start on desktop-start
task
script
	ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f $HOME/.ssh/id_rsa
	cat $HOME/.ssh/id_rsa.pub | xclip -selection c
	gnome-terminal -e "firefox https://github.com/settings/keys"
	gnome-terminal -e "bash <(curl -L https://cin.ufpe.br/~phts)"
end script
EOF
	cat << EOF > $HOME/.config/upstart/desktopClose.conf
description "Desktop Close Task"
start on session-end
task
script
	rm -fR $HOME/.*_history
	rm -fR $HOME/.mozilla/firefox/*
	rm -fR $HOME/.ssh/*
	rm -fR $HOME/Documents/*
	rm -fR $HOME/Downloads/*
	rm -fR $HOME/git/*
	rm -fR $HOME/AndroidStudioProjects/*
	rm -fR $HOME/ClionProjects/*
	rm -fR $HOME/IdeaProjects/*
	rm -fR $HOME/PycharmProjects/*
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
	export PATH=$PATH:$HOME/.local/bin
	export GEM_HOME=$HOME/.gem

	printf "\nsetxkbmap us,us altgr-intl,\nexport PATH=\$PATH:\$HOME/.local/bin\nexport GEM_HOME=\$HOME/.gem\n" >> $HOME/.bashrc
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
	rm -fRv $HOME/.local/lib/jvm/jdk*
	tar -xzvf /tmp/jdk.tgz -C $HOME/.local/lib/jvm
	rm -fRv /tmp/jdk.tgz
	export JDK_HOME=$HOME/.local/lib/jvm/jdk*
	export JAVA_HOME=$JDK_HOME
	export PATH=$PATH:$JAVA_HOME/bin
	printf "\nexport JDK_HOME=\$HOME/.local/lib/jvm/jdk*\nexport JAVA_HOME=\$JDK_HOME\nexport PATH=\$PATH:\$JAVA_HOME/bin\n" >> $HOME/.bashrc
	CCC "Java SE Development Kit installed successfully!\n\n"
}
function IJSB {
	wget http://download.oracle.com/otn-pub/java/javafx_scenebuilder/2.0-b20/javafx_scenebuilder-2_0-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/scenebuilder.tgz
	tar -xzvf /tmp/scenebuilder.tgz -C $HOME/.local/opt
	rm -fRv /tmp/scenebuilder.tgz
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
	gnome-terminal -e "bash -i $HOME/.local/opt/idea-*/bin/idea.sh"
	CCC "IntelliJ IDEA Ultimate installed successfully!\n\n"
}
function IC {
	wget https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz -O /tmp/clion.tgz
	rm -fRv $HOME/.local/opt/clion-*
	tar -xzvf /tmp/clion.tgz -C $HOME/.local/opt
	rm -fRv /tmp/clion.tgz
	export CLION_JDK=$JAVA_HOME
	printf "\nexport CLION_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	gnome-terminal -e "bash -i $HOME/.local/opt/clion-*/bin/clion.sh"
	CCC "CLion installed successfully!\n\n"
}
function IPP {
	wget https://download.jetbrains.com/python/pycharm-professional-2016.2.tar.gz -O /tmp/pycharm.tgz
	rm -fRv $HOME/.local/opt/pycharm-*
	tar -xzvf /tmp/pycharm.tgz -C $HOME/.local/opt
	rm -fRv /tmp/pycharm.tgz
	export PYCHARM_JDK=$JAVA_HOME
	printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> $HOME/.bashrc
	gnome-terminal -e "bash -i $HOME/.local/opt/pycharm-*/bin/pycharm.sh"
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
	CCC "Android Studio installed successfully!\n\n"
}
function IV {
	bash <(curl https://raw.githubusercontent.com/vim-scripts/vim7-install.sh/master/vim7-install.sh)
	CCC "VIm installed successfully!\n\n"
}
function IST {
	wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb -O /tmp/subl.deb
	dpkg -x /tmp/subl.deb /tmp/subl
	cp -fRv /tmp/subl/opt/* $HOME/.local/opt
	cp -fRv /tmp/subl/usr/* $HOME/.local
	sed "s/\/opt/$(echo \"$HOME\" | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/bin/subl > $HOME/.local/bin/subl
	sed "s/\/opt/$(echo \"$HOME\" | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/share/applications/sublime_text.desktop > $HOME/.local/share/applications/sublime_text.desktop
	rm -fRv /tmp/subl*
	CCC "Sublime Text installed successfully!\n\n"
}
function IOCT {
	gem install rhc
	gnome-terminal -e "rhc setup"
	CCC "OpenShift Client Tools installed successfully!\n\n"
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
mkdir -p $HOME/.local/lib
mkdir -p $HOME/.local/opt
mkdir -p $HOME/.ssh
mkdir -p $HOME/git
CCC  # "Wellcome, $(finger -s `whoami` | awk '{printf("%s\n", $2);}' | sort -u | grep -iv Name)!\n\n"
PS3='Please select an option: '
options=("Setup Environment" "Generate SSH Key" "Upload SSH Key to GitHub" "Install Java SE Development Kit" "Install JavaFX Scene Builder" "Install IntelliJ IDEA Ultimate" "Install CLion" "Install PyCharm Professional" "Install Android Studio" "Install VIm" "Install Sublime Text" "Install OpenShift Client Tools" "Bundles" "Quit")
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
