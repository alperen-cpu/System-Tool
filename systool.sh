#!/bin/bash
####################################################################
# Alperen Sah Abursum (alperensah {at} outlook.com) - Oct 7, 2022
####################################################################
#simple menu driven shell script to to get information about your Linux server

# Define variables
LSB=/usr/bin/lsb_release

# Purpose: Display pause prompt
# $1-> Message (optional)
function pause() {
    local message="$@"
    [ -z $message ] && message="Devam etmek için [Enter] tuşuna basın..."
    read -p "$message" readEnterKey
}

# Purpose - Display a menu on screen
function show_menu() {
    date
    echo "---------------------------"
    echo " Ana Menü "
    echo "---------------------------"
    echo "1. İşletim Sistemi Bilgisi"
    echo "2. Ram Bilgisi"
    echo "3. Disk Bilgisi"
    echo "4. Docker Kur"
    echo "5. Yazılım Paketlerini Kur"
    echo "6. Çıkış"
}

# Purpose - Display header message
# $1 - message
function write_header() {
    local h="$@"
    echo "---------------------------------------------------------------"
    echo " ${h}"
    echo "---------------------------------------------------------------"
}

# Purpose - Get info about your operating system
function os_info() {
    write_header " Sistem Bilgisi "
    echo "İşletim Sistemi Bilgisi : $(uname)"
    [ -x $LSB ] && $LSB -a || echo "$LSB komut yüklü değil (set \$LSB variable)"
    pause
}

# Purpose - Display used and free memory info
function mem_info() {
    write_header " Boş ve kullanılan Ram "
    free -m
    
    echo "*********************************"
    echo "*** Ram istatistik ***"
    echo "*********************************"
    vmstat
    echo "***********************************"
    echo "*** Top 5 Ram Tüketen ***"
    echo "***********************************"
    ps auxf | sort -nr -k 4 | head -5
    pause
}

# purpose - Get Disk Usage Information
function disk_info() {
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
    partition=$(echo $output | awk '{print $2}')
    write_header " Disk Kullanım Bilgisi"
    if [ "$EXCLUDE_LIST" != "" ]; then
        df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}'
    else
        df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}'
    fi
    pause
}

# purpose - Docker Install and Setup
function docker_setup() {
    apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
  docker --version
}

# purpose - PHP and NodeJS select version system install
function software_setup() {
    write_header " Yazılım Paketlerini Kur"
    txtpur=$(tput setaf 5)
    txtrst=$(tput sgr0)

while :; do  
        echo ""
        echo "1. PHP Kur"
        echo "9. NodeJS Kur"
        echo "14. ${txtpur}Ana Menüye Dön <--${txtrst}"
        echo ""
        
        read processmenuchoice
        case $processmenuchoice in

            1)
            PHP_VERSION=8.1
            PHP_VERSION2=8.0
            PHP_VERSION3=7.4
            PHP_VERSION4=7.3
            PHP_VERSION5=7.2
            PHP_VERSION6=7.1
            PHP_VERSION7=7.0
            echo ""
            echo "İlgili PHP Versiyonu Seçiniz:"
            echo ""
            echo "2. PHP $PHP_VERSION Kur"
            echo "3. PHP $PHP_VERSION2 Kur"
            echo "4. PHP $PHP_VERSION3 Kur"
            echo "5. PHP $PHP_VERSION4 Kur"
            echo "6. PHP $PHP_VERSION5 Kur"
            echo "7. PHP $PHP_VERSION6 Kur"
            echo "8. PHP $PHP_VERSION7 Kur"

            read phpsubmenu
            case $phpsubmenu in
            #PHP8.1
            2)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            apt-get install software-properties-common -y
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt-get install php$PHP_VERSION php$PHP_VERSION-fpm -y && echo " " && service php$PHP_VERSION-fpm status
            service php$PHP_VERSION-fpm start
            php -v
            ;;
            #PHP8.0
            3)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION2 php$PHP_VERSION2-fpm -y && echo " " && service php$PHP_VERSION2-fpm status
            php -v
            ;;
            #PHP7.4
            4)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION3 php$PHP_VERSION3-fpm -y && echo " " && service php$PHP_VERSION3-fpm status
            php -v
            ;;
            #PHP7.3
            5)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION4 php$PHP_VERSION4-fpm -y && echo " " && service php$PHP_VERSION4-fpm status
            php -v
            ;;
            #PHP7.2
            6)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION5 php$PHP_VERSION5-fpm -y && echo " " && service php$PHP_VERSION5-fpm status
            php -v
            ;;
            #PHP7.1
            7)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION6 php$PHP_VERSION6-fpm -y && echo " " && service php$PHP_VERSION6-fpm status
            php -v
            ;;
            #PHP7.0
            8)
            apt update -y
            apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
            if cat /etc/apt/sources.list.d/php.list
            then
            echo ""
            else
            echo ""
            wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
            fi
            apt update -y
            apt install php$PHP_VERSION7 php$PHP_VERSION7-fpm -y && echo " " && service php$PHP_VERSION7-fpm status
            php -v
            ;;
            esac
            ;;
            ################## NodeJS ##################
            9)
            NodeJS_VERSION=18.x
            NodeJS_VERSION2=17.x
            NodeJS_VERSION3=16.x
            NodeJS_VERSION4=15.x
            echo " "
            echo "İlgili NodeJS Versiyonu Seçiniz:"
            echo "Not: Yüklenicek olan NodeJS, Npm paketi ile gelmektedir."
            echo " "
            echo "10. NodeJS $NodeJS_VERSION Kur"
            echo "11. NodeJS $NodeJS_VERSION2 Kur"
            echo "12. NodeJS $NodeJS_VERSION3 Kur"
            echo "13. NodeJS $NodeJS_VERSION4 Kur"
            echo " "
            read nodejssubmenu
            case $nodejssubmenu in
#NodeJS 18
            10)
            apt update -y
            curl -sL https://deb.nodesource.com/setup_18.x | bash -
            apt install nodejs -y
            echo " "
            npm -v && node -v
            ;;
#NodeJS 17
            11)
            apt update -y
            curl -sL https://deb.nodesource.com/setup_17.x | bash -
            apt install nodejs -y
            echo " "
            npm -v && node -v
            ;;
#NodeJS 16
            12)
            apt update -y
            curl -sL https://deb.nodesource.com/setup_16.x | bash -
            apt install nodejs -y
            echo " "
            npm -v && node -v
            ;;
#NodeJS 15
            13)
            apt update -y
            curl -sL https://deb.nodesource.com/setup_15.x | bash -
            apt install nodejs -y
            echo " "
            npm -v && node -v
            ;;

            esac
            ;;
         
            14)
            clear && echo "" && echo "Ana menüye dönmek istediğinizden emin misiniz? ${txtcyn}y/n${txtrst}" && echo ""
            read exitays
            case $exitays in
            y | Y)
            clear && exit
            ;;
            n | N)
            clear && echo "" && echo "İşlem Devam Ediyor." && echo "" && echo "${txtcyn}(Devam etmek için ENTER'a basın.)${txtrst}" && read
            ;;
            *)
            clear && echo "" && echo "${txtred}Lütfen geçerli bir seçim yapın.${txtrst}" && echo "" && echo "${txtcyn}(Devam etmek için ENTER'a basın.)${txtrst}" && read
            ;;
            esac
            ;;
        esac
        
    done
    pause
}

######################
# Purpose - Get input via the keyboard and make a decision using case..esac
function read_input() {
    local c
    read -p "Bir seçim gir [ 1 -6 ] " c
    case $c in
        1) os_info ;;
        2) mem_info ;;
        3) disk_info ;;
        4) docker_setup ;;
        5) software_setup ;;
        6)
            echo "Bye!"
            exit 0
        ;;
        *)
            echo "Lütfen yalnızca 1 ila 6 seçenek arasından seçim yapın."
            pause
        ;;
    esac
}


# CTRL+C, CTRL+Z disable
#trap '' SIGINT SIGQUIT SIGTSTP

# main logic
while true; do
    clear
    show_menu  # display memu
    read_input # wait for user input
done
