#!/bin/bash
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
PS3='Please select an option: '
options=("Setup Environment" "Generate SSH Key" "Upload SSH Key to GitHub" "Install Java SE Development Kit" "Install JavaFX Scene Builder" "Install IntelliJ IDEA Ultimate" "Install CLion" "Install PyCharm Professional" "Install Android Studio" "Install VIm" "Install Sublime Text" "Install OpenShift Client Tools" "Bundles" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Setup Environment")
			mkdir -p $HOME/.local/bin
			mkdir -p $HOME/.local/opt
			mkdir -p $HOME/git
			mkdir -p $HOME/.gem
			gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
			gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
			gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
			setxkbmap us,us altgr-intl,
			export PATH=$PATH:$HOME/.local/bin
			export GEM_HOME=$HOME/.gem
			printf "\nsetxkbmap us,us altgr-intl,\nexport PATH=\$PATH:\$HOME/.local/bin\nexport GEM_HOME=\$HOME/.gem\n" >> ~/.bashrc
			clear && clear
			printf "Environment setted up with success!\n\n"
			;;
		"Upload SSH Key to GitHub")
			gnome-terminal -e "firefox https://github.com/settings/keys"
			echo
			;;
		"Generate SSH Key")
			ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f ~/.ssh/id_rsa
			wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xclip/xclip_0.12+svn84-4_amd64.deb -O /tmp/xclip.deb
			dpkg -x /tmp/xclip.deb /tmp/xclip
			cp -fRv /tmp/xclip/usr/* ~/.local
			rm -fRv /tmp/xclip*
			cat $HOME/.ssh/id_rsa.pub | xclip -selection c
			clear && clear
			printf "Public SSH Key copied to clipboard!\n\n"
			;;
		"Install Java SE Development Kit")
			wget http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/jdk.tgz
			tar -xzvf /tmp/jdk.tgz -C $HOME/.local/opt
			rm -fRv /tmp/jdk.tgz
			export JDK_HOME=$HOME/.local/opt/jdk1.8.0_102
			export JAVA_HOME=$JDK_HOME
			export PATH=$PATH:$JAVA_HOME/bin
			printf "\nexport JDK_HOME=\$HOME/.local/opt/jdk1.8.0_102\nexport JAVA_HOME=\$JDK_HOME\nexport PATH=\$PATH:\$JAVA_HOME/bin\n" >> ~/.bashrc
			clear && clear
			printf "Java SE Development Kit installed successfully!\n\n"
			;;
		"Install JavaFX Scene Builder")
			wget http://download.oracle.com/otn-pub/java/javafx_scenebuilder/2.0-b20/javafx_scenebuilder-2_0-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/scenebuilder.tgz
			tar -xzvf /tmp/scenebuilder.tgz -C $HOME/.local/opt
			rm -fRv /tmp/scenebuilder.tgz
			clear && clear
			printf "JavaFX Scene Builder installed successfully!\n\n"
			;;
		"Install IntelliJ IDEA Ultimate")
			wget https://download-cf.jetbrains.com/idea/ideaIU-2016.2.tar.gz -O /tmp/idea.tgz
			tar -xzvf /tmp/idea.tgz -C $HOME/.local/opt
			rm -fRv /tmp/idea.tgz
			export IDEA_JDK=$JAVA_HOME
			export IDEA_JDK_64=$IDEA_JDK
			printf "\nexport IDEA_JDK=\$JAVA_HOME\nexport IDEA_JDK_64=\$IDEA_JDK\n" >> ~/.bashrc
			gnome-terminal -e "sh $HOME/.local/opt/idea-IU-162.1121.32/bin/idea.sh"
			clear && clear
			printf "IntelliJ IDEA Ultimate installed successfully!\n\n"
			;;
		"Install CLion")
			wget https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz -O /tmp/clion.tgz
			tar -xzvf /tmp/clion.tgz -C $HOME/.local/opt
			rm -fRv /tmp/clion.tgz
			export CLION_JDK=$JAVA_HOME
			printf "\nexport CLION_JDK=\$JAVA_HOME\n" >> ~/.bashrc
			gnome-terminal -e "sh $HOME/.local/opt/clion-2016.2/bin/clion.sh"
			clear && clear
			printf "CLion installed successfully!\n\n"
			;;
		"Install PyCharm Professional")
			wget https://download.jetbrains.com/python/pycharm-professional-2016.1.4.tar.gz -O /tmp/pycharm.tgz
			tar -xzvf /tmp/pycharm.tgz -C $HOME/.local/opt
			rm -fRv /tmp/pycharm.tgz
			export PYCHARM_JDK=$JAVA_HOME
			printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> ~/.bashrc
			gnome-terminal -e "sh $HOME/.local/opt/pycharm-2016.1.4/bin/pycharm.sh"
			clear && clear
			printf "PyCharm Professional installed successfully!\n\n"
			;;
		"Install Android Studio")
			wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip -O /tmp/studio.zip
			unzip /tmp/studio.zip -d $HOME/.local/opt
			rm -fRv /tmp/studio.zip
			export STUDIO_JDK=$JAVA_HOME
			printf "\nexport STUDIO_JDK=\$JAVA_HOME\n" >> ~/.bashrc
			gnome-terminal -e "sh $HOME/.local/opt/android-studio/bin/studio.sh"
			clear && clear
			printf "Android Studio installed successfully!\n\n"
			;;
		"Install VIm")
			bash <(curl https://raw.githubusercontent.com/vim-scripts/vim7-install.sh/master/vim7-install.sh)
			clear && clear
			printf "VIm installed successfully!\n\n"
			;;
		"Install Sublime Text")
			wget https://download.sublimetext.com/sublime-text_build-3114_amd64.deb -O /tmp/subl.deb
			dpkg -x /tmp/subl.deb /tmp/subl
			cp -fRv /tmp/subl/opt/* $HOME/.local/opt
			cp -fRv /tmp/subl/usr/* $HOME/.local
			sed "s/\/opt/$(echo \"$HOME\" | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/bin/subl > $HOME/.local/bin/subl
			sed "s/\/opt/$(echo \"$HOME\" | sed -e 's/\//\\\//g')\/.local\/opt/g" /tmp/subl/usr/share/applications/sublime_text.desktop > $HOME/.local/share/applications/sublime_text.desktop
			rm -fRv /tmp/subl*
			clear && clear
			printf "Sublime Text installed successfully!\n\n"
			;;
		"Install OpenShift Client Tools")
			gem install --user-install rhc
			gnome-terminal -e "rhc setup"
			clear && clear
			printf "Install OpenShift Client Tools installed successfully!\n\n"
			;;
		"Bundles")
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
			options=("LookMobile" "Singularity" "Back")
			select opt in "${options[@]}"
			do
				case $opt in
					"LookMobile")
						mkdir -p $HOME/.local/bin
						mkdir -p $HOME/.local/opt
						mkdir -p $HOME/git
						mkdir -p $HOME/.gem
						gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
						gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
						gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
						setxkbmap us,us altgr-intl,
						export PATH=$PATH:$HOME/.local/bin
						export GEM_HOME=$HOME/.gem
						printf "\nsetxkbmap us,us altgr-intl,\nexport PATH=\$PATH:\$HOME/.local/bin\nexport GEM_HOME=\$HOME/.gem\n" >> ~/.bashrc
						clear && clear
						printf "Environment setted up with success!\n\n"

						ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f ~/.ssh/id_rsa
						wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xclip/xclip_0.12+svn84-4_amd64.deb -O /tmp/xclip.deb
						dpkg -x /tmp/xclip.deb /tmp/xclip
						cp -fRv /tmp/xclip/usr/* ~/.local
						rm -fRv /tmp/xclip*
						cat $HOME/.ssh/id_rsa.pub | xclip -selection c
						printf "\nPublic SSH Key copied to clipboard!\n"

						gnome-terminal -e "firefox https://github.com/settings/keys"

						wget https://download.jetbrains.com/python/pycharm-professional-2016.1.4.tar.gz -O /tmp/pycharm.tgz
						tar -xzvf /tmp/pycharm.tgz -C $HOME/.local/opt
						rm -fRv /tmp/pycharm.tgz
						export PYCHARM_JDK=$JAVA_HOME
						printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> ~/.bashrc
						gnome-terminal -e "sh $HOME/.local/opt/pycharm-2016.1.4/bin/pycharm.sh"
						clear && clear
						printf "PyCharm Professional installed successfully!\n\n"

						wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip -O /tmp/studio.zip
						unzip /tmp/studio.zip -d $HOME/.local/opt
						rm -fRv /tmp/studio.zip
						export STUDIO_JDK=$JAVA_HOME
						printf "\nexport STUDIO_JDK=\$JAVA_HOME\n" >> ~/.bashrc
						gnome-terminal -e "sh $HOME/.local/opt/android-studio/bin/studio.sh"
						clear && clear
						printf "Android Studio installed successfully!\n\n"

						gem install --user-install rhc
						gnome-terminal -e "rhc setup"
						clear && clear
						printf "Install OpenShift Client Tools installed successfully!\n\n"

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
						options=("Náutico (Android)" "Náutico (BackEnd)" "LookEsporte" "None")
						select opt in "${options[@]}"
						do
							case $opt in
								"LookEsporte")
									git clone git@github.com:t0rr3sp3dr0/lookEsporte-Python.git $HOME/git/lookEsporte-Python
									printf "\nDone!\n"

									break
									;;
								"Náutico (Android)")
									git clone git@github.com:t0rr3sp3dr0/N-utico-Android.git $HOME/git/N-utico-Android
									printf "\nDone!\n"

									break
									;;
								"Náutico (BackEnd)")
									git clone git@github.com:t0rr3sp3dr0/N-utico-BackEnd.git $HOME/git/N-utico-BackEnd
									printf "\nDone!\n"

									break
									;;
								"None")
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
						mkdir -p $HOME/.local/bin
						mkdir -p $HOME/.local/opt
						mkdir -p $HOME/git
						mkdir -p $HOME/.gem
						gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
						gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
						gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
						setxkbmap us,us altgr-intl,
						export PATH=$PATH:$HOME/.local/bin
						export GEM_HOME=$HOME/.gem
						printf "\nsetxkbmap us,us altgr-intl,\nexport PATH=\$PATH:\$HOME/.local/bin\nexport GEM_HOME=\$HOME/.gem\n" >> ~/.bashrc
						clear && clear
						printf "Environment setted up with success!\n\n"

						ssh-keygen -t rsa -b 4096 -C $LOGNAME"@cin.ufpe.br" -N "" -f ~/.ssh/id_rsa
						wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xclip/xclip_0.12+svn84-4_amd64.deb -O /tmp/xclip.deb
						dpkg -x /tmp/xclip.deb /tmp/xclip
						cp -fRv /tmp/xclip/usr/* ~/.local
						rm -fRv /tmp/xclip*
						cat $HOME/.ssh/id_rsa.pub | xclip -selection c
						printf "\nPublic SSH Key copied to clipboard!\n"

						gnome-terminal -e "firefox https://github.com/settings/keys"

						wget http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/jdk.tgz
						tar -xzvf /tmp/jdk.tgz -C $HOME/.local/opt
						rm -fRv /tmp/jdk.tgz
						export JDK_HOME=$HOME/.local/opt/jdk1.8.0_102
						export JAVA_HOME=$JDK_HOME
						export PATH=$PATH:$JAVA_HOME/bin
						printf "\nexport JDK_HOME=\$HOME/.local/opt/jdk1.8.0_102\nexport JAVA_HOME=\$JDK_HOME\nexport PATH=\$PATH:\$JAVA_HOME/bin\n" >> ~/.bashrc
						printf "\nJava SE Development Kit installed successfully!\n"

						wget http://download.oracle.com/otn-pub/java/javafx_scenebuilder/2.0-b20/javafx_scenebuilder-2_0-linux-x64.tar.gz --header "Cookie: oraclelicense=accept-securebackup-cookie;" -O /tmp/scenebuilder.tgz
						tar -xzvf /tmp/scenebuilder.tgz -C $HOME/.local/opt
						rm -fRv /tmp/scenebuilder.tgz
						clear && clear
						printf "\nJavaFX Scene Builder installed successfully!\n"

						wget https://download-cf.jetbrains.com/idea/ideaIU-2016.2.tar.gz -O /tmp/idea.tgz
						tar -xzvf /tmp/idea.tgz -C $HOME/.local/opt
						rm -fRv /tmp/idea.tgz
						export IDEA_JDK=$JAVA_HOME
						export IDEA_JDK_64=$IDEA_JDK
						printf "\nexport IDEA_JDK=\$JAVA_HOME\nexport IDEA_JDK_64=\$IDEA_JDK\n" >> ~/.bashrc
						gnome-terminal -e "sh $HOME/.local/opt/idea-IU-162.1121.32/bin/idea.sh"
						printf "\nIntelliJ IDEA Ultimate installed successfully!\n"

						wget https://download.jetbrains.com/cpp/CLion-2016.2.tar.gz -O /tmp/clion.tgz
						tar -xzvf /tmp/clion.tgz -C $HOME/.local/opt
						rm -fRv /tmp/clion.tgz
						export CLION_JDK=$JAVA_HOME
						printf "\nexport CLION_JDK=\$JAVA_HOME\n" >> ~/.bashrc
						gnome-terminal -e "sh $HOME/.local/opt/clion-2016.2/bin/clion.sh"
						clear && clear
						printf "CLion installed successfully!\n\n"

						wget https://download.jetbrains.com/python/pycharm-professional-2016.1.4.tar.gz -O /tmp/pycharm.tgz
						tar -xzvf /tmp/pycharm.tgz -C $HOME/.local/opt
						rm -fRv /tmp/pycharm.tgz
						export PYCHARM_JDK=$JAVA_HOME
						printf "\nexport PYCHARM_JDK=\$JAVA_HOME\n" >> ~/.bashrc
						gnome-terminal -e "sh $HOME/.local/opt/pycharm-2016.1.4/bin/pycharm.sh"
						clear && clear
						printf "PyCharm Professional installed successfully!\n\n"

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
						options=("BuildWare" "Direct" "None")
						select opt in "${options[@]}"
						do
							case $opt in
								"BuildWare")
									git clone git@github.com:t0rr3sp3dr0/buildWare-JavaFX.git $HOME/git/buildWare-JavaFX
									printf "\nDone!\n"

									break
									;;
								"Direct")
									git clone git@github.com:lvrma/Direct-Singularity.git $HOME/git/Direct-Singularity
									printf "\nDone!\n"

									break
									;;
								"None")
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


1) Setup Environment		      8) Install PyCharm Professional
2) Generate SSH Key		      9) Install Android Studio
3) Upload SSH Key to GitHub	     10) Install VIm
4) Install Java SE Development Kit   11) Install Sublime Text
5) Install JavaFX Scene Builder	     12) Install OpenShift Client Tools
6) Install IntelliJ IDEA Ultimate    13) Bundles
7) Install CLion		     14) Quit
EOF
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