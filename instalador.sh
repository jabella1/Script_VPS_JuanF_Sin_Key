#!/bin/bash
clear && clear
rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/Africa/Algiers /etc/localtime &>/dev/null

apt install net-tools -y &>/dev/null
myip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1)
myint=$(ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}')
rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/Africa/Algiers /etc/localtime &>/dev/null
rm -rf /usr/local/lib/systemubu1 &>/dev/null
rm -rf /etc/versin_script &>/dev/null
v1=$(curl -sSL "https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/SCRIPT-v8.5x/Version")
echo "$v1" >/etc/versin_script
[[ ! -e /etc/versin_script ]] && echo 1 >/etc/versin_script
v22=$(cat /etc/versin_script)
vesaoSCT="\033[1;31m [ \033[1;32m($v22)\033[1;97m\033[1;31m ]"
### COLORS AND BAR
msg() {
   BRAN='\033[1;37m' && RED='\e[31m' && GREEN='\e[32m' && YELLOW='\e[33m'
  BLUE='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && BLACK='\e[1m' && SEMCOR='\e[0m'
  case $1 in
  -ne) cor="${RED}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -ama) cor="${YELLOW}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verm) cor="${YELLOW}${BLACK}[!] ${RED}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -azu) cor="${MAG}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verd) cor="${GREEN}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -bra) cor="${RED}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -nazu) cor="${COLOR[6]}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -gri) cor="\e[5m\033[1;100m" && echo -ne "${cor}${2}${SEMCOR}" ;;
  "-bar2" | "-bar") cor="${RED}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
  esac
}
fun_bar() {
  comando="$1"
  _=$(
    $comando >/dev/null 2>&1
  ) &
  >/dev/null
  pid=$!
  while [[ -d /proc/$pid ]]; do
    echo -ne " \033[1;33m["
    for ((i = 0; i < 20; i++)); do
      echo -ne "\033[1;31m##"
      sleep 0.5
    done
    echo -ne "\033[1;33m]"
    sleep 1s
    echo
    tput cuu1
    tput dl1
  done
  echo -e " \033[1;33m[\033[1;31m########################################\033[1;33m] - \033[1;32m100%\033[0m"
  sleep 1s
}

print_center() {
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(((54 - ${#line}) / 2))
    for ((i = 0; i < $x; i++)); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<<$(echo -e "$text")
}

title() {
  clear
  msg -bar
  if [[ -z $2 ]]; then
    print_center -azu "$1"
  else
    print_center "$1" "$2"
  fi
  msg -bar
}



stop_install() {
  title "INSTALACION CANCELADA"
  exit
}

time_reboot() {
  print_center -ama "REINICIANDO VPS EN $1 SEGUNDOS"
  REBOOT_TIMEOUT="$1"

  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  reboot
}

os_system() {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')

  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}

repo() {
  link="https://raw.githubusercontent.com/khaledagn/Multi-Script/main/Source-List/20.04.list"
  case $1 in
  8 | 9 | 10 | 11 | 16.04 | 18.04 | 20.04 | 20.10 | 21.04 | 21.10 | 22.04) wget -O /etc/apt/sources.list ${link} &>/dev/null ;;
  esac
}

dependencias() {
  soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl screen cron iptables lsof pv boxes nano at mlocate gawk grep bc jq curl npm nodejs socat netcat netcat-traditional net-tools cowsay figlet lolcat"

  for i in $soft; do
    leng="${#i}"
    puntos=$((21 - $leng))
    pts="."
    for ((a = 0; a < $puntos; a++)); do
      pts+="."
    done
    msg -nazu "    instalando $i$(msg -ama "$pts")"
    if apt install $i -y &>/dev/null; then
      msg -verd " INSTALADO by @JuanFCol"
    else
      msg -verm2 " ERROR"
      sleep 2
      tput cuu1 && tput dl1
      print_center -ama "aplicando correcciones a $i"
      dpkg --configure -a &>/dev/null
      sleep 2
      tput cuu1 && tput dl1

      msg -nazu "    instalando $i$(msg -ama "$pts")"
      if apt install $i -y &>/dev/null; then
        msg -verd " INSTALADO by @JuanFCol"
      else
        msg -verm2 " ERROR"
      fi
    fi
  done
}

post_reboot() {
  echo 'wget -O /root/install.sh "https://raw.githubusercontent.com/jabella1/Script_VPS_JuanF_Sin_Key/main/instalador.sh"; clear; sleep 2; chmod +x /root/install.sh; /root/install.sh --continue' >>/root/.bashrc
  title -verd "COMPLETED SYSTEM UPGRADE"
  print_center -ama "LA INSTALACION CONTINUARA\nDESPUES DE REINICIAR!!!"
  msg -bar
}

install_start() {
  msg -bar

  echo -e "\e[1;97m           \e[5m\033[1;100m   SYSTEM UPDATE   \033[1;37m"
  msg -bar
  print_center -ama "Los paquetes del sistema se están actualizando.\n Puede llevar un tiempo y solicitar algunas confirmaciones.\n"
  msg -bar3
  msg -ne "\n Desea continuar? [Y/N]: "
  read opcion
  [[ "$opcion" != @(y|Y) ]] && stop_install
  clear && clear
  msg -bar
  echo -e "\e[1;97m           \e[5m\033[1;100m   ACTUALIZACION DEL SISTEMA  \033[1;37m"
  msg -bar
  os_system
  apt update -y
  apt upgrade -y
}

install_continue() {
  os_system
  msg -bar
  echo -e "      \e[5m\033[1;100m   COMPLETANDO PAQUETES PARA EL SCRIPT   \033[1;37m"
  msg -bar
  print_center -ama "$distro $vercion"
  print_center -verd "INSTALANDO DEPENDENCIAS"
  msg -bar3
  dependencias
  msg -bar3
  print_center -azu "REMOVIENDO PAQUETES OBSOLETOS"
  apt autoremove -y &>/dev/null
  sleep 2
  tput cuu1 && tput dl1
  msg -bar
  print_center -ama "Si algunas de las dependencias fallan!!!\ncuando haya terminado, puede intentar instalarlas\nmanualmente usando el siguiente comando\napt install package_name"
  msg -bar
  read -t 60 -n 1 -rsp $'\033[1;39m       << Presione enter para continuar >>\n'
}

while :; do
  case $1 in
  -s | --start) install_start && post_reboot && time_reboot "15" ;;
  -c | --continue)
    #rm /root/install-without-key.sh &>/dev/null
    sed -i '/installer/d' /root/.bashrc
    install_continue
    break
    ;;
  # -u | --update)
  #   install_start
  #   install_continue
  #   break
  # ;;
  *) exit ;;
  esac
done

clear && clear
msg -bar2
echo -e " \e[5m\033[1;100m   =====>> ►► 🐲 SCRIPT by. @JuanFCol  🐲 ◄◄ <<=====   \033[1;37m"
msg -bar2
print_center -ama "SCRIPTS DISPONIBLES"
msg -bar
#-BASH SOPORTE ONLINE
wget https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/LINKS-LIBRARIES/SPR.sh -O /usr/bin/SPR >/dev/null 2>&1
chmod +x /usr/bin/SPR

#LATAM ADMRufu 31-03-2022
install_ADMRufu() {
  clear && clear
  msg -bar
  echo -ne "\033[1;97m Digite su slogan: \033[1;32m" && read slogan
  tput cuu1 && tput dl1
  echo -e "$slogan"
  msg -bar
  clear && clear
  mkdir /etc/ADMRufu >/dev/null 2>&1
  cd /etc
  wget https://github.com/jabella1/Script_VPS_Mejorado/raw/main/ADMRufu.tar.xz >/dev/null 2>&1
  tar -xf ADMRufu.tar.xz >/dev/null 2>&1
  chmod +x ADMRufu.tar.xz >/dev/null 2>&1
  rm -rf ADMRufu.tar.xz
  cd
  chmod -R 755 /etc/ADMRufu
  ADMRufu="/etc/ADMRufu" && [[ ! -d ${ADMRufu} ]] && mkdir ${ADMRufu}
  ADM_inst="${ADMRufu}/install" && [[ ! -d ${ADM_inst} ]] && mkdir ${ADM_inst}
  SCPinstal="$HOME/install"
  rm -rf /usr/bin/menuu
  rm -rf /usr/bin/adm
  rm -rf /usr/bin/ADMRufu
  echo "$slogan" >/etc/ADMRufu/tmp/message.txt
  echo "${ADMRufu}/menuu" >/usr/bin/menuu && chmod +x /usr/bin/menuu
  echo "${ADMRufu}/menuu" >/usr/bin/adm && chmod +x /usr/bin/adm
  echo "${ADMRufu}/menuu" >/usr/bin/ADMRufu && chmod +x /usr/bin/ADMRufu
  [[ -z $(echo $PATH | grep "/usr/games") ]] && echo 'if [[ $(echo $PATH|grep "/usr/games") = "" ]]; then PATH=$PATH:/usr/games; fi' >>/etc/bash.bashrc
  echo '[[ $UID = 0 ]] && screen -dmS up /etc/ADMRufu/chekup.sh' >>/etc/bash.bashrc
  echo 'v=$(cat /etc/ADMRufu/vercion)' >>/etc/bash.bashrc
  echo '[[ -e /etc/ADMRufu/new_vercion ]] && up=$(cat /etc/ADMRufu/new_vercion) || up=$v' >>/etc/bash.bashrc
  echo -e "[[ \$(date '+%s' -d \$up) -gt \$(date '+%s' -d \$(cat /etc/ADMRufu/vercion)) ]] && v2=\"Nueva Vercion disponible: \$v >>> \$up\" || v2=\"Script Vercion: \$v\"" >>/etc/bash.bashrc
  echo '[[ -e "/etc/ADMRufu/tmp/message.txt" ]] && mess1="$(less /etc/ADMRufu/tmp/message.txt)"' >>/etc/bash.bashrc
  echo '[[ -z "$mess1" ]] && mess1="@Rufu99"' >>/etc/bash.bashrc
  echo 'clear && echo -e "\n$(figlet -f big.flf "  ADMRufu")\n        RESELLER : $mess1 \n\n   Para iniciar ADMRufu escriba:  menuu \n\n   $v2\n\n"|lolcat' >>/etc/bash.bashrc

  update-locale LANG=en_US.UTF-8 LANGUAGE=en
  clear && clear
  msg -bar
  echo -e "\e[1;92m             >> INSTALACION COMPLETADA <<" && msg bar2
  echo -e "      COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
  echo -e "                      \033[1;41m  menuu  \033[0;37m" && msg -bar2
}


#VPS-AGN 8.6 OFFICIAL
install_official() {
  clear && clear
  msg -bar
  echo -ne "\033[1;97m Digite su Eslogan: \033[1;32m" && read slogan
  tput cuu1 && tput dl1
  echo -e "$slogan"
  msg -bar
  clear && clear
  mkdir /etc/VPS-AGN >/dev/null 2>&1
  cd /etc
  wget https://github.com/jabella1/SCRIPT-v8.5x-JuanF-tar.xz/raw/main/VPS-AGN.tar.xz >/dev/null 2>&1
  tar -xf VPS-AGN.tar.xz >/dev/null 2>&1
  chmod +x VPS-AGN.tar.xz >/dev/null 2>&1
  rm -rf VPS-AGN.tar.xz
  cd
  chmod -R 755 /etc/VPS-AGN
  rm -rf /etc/VPS-AGN/MEUIPvps
  echo "/etc/VPS-AGN/men" >/usr/bin/men && chmod +x /usr/bin/men
  echo "/etc/VPS-AGN/men" >/usr/bin/VPSAGN && chmod +x /usr/bin/VPSAGN
  wget https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/LINKS-LIBRARIES/monitor.sh -P /bin/
  echo "$slogan" >/etc/VPS-AGN/message.txt
  [[ ! -d /usr/local/lib ]] && mkdir /usr/local/lib
  [[ ! -d /usr/local/lib/ubuntn ]] && mkdir /usr/local/lib/ubuntn
  [[ ! -d /usr/local/lib/ubuntn/apache ]] && mkdir /usr/local/lib/ubuntn/apache
  [[ ! -d /usr/local/lib/ubuntn/apache/ver ]] && mkdir /usr/local/lib/ubuntn/apache/ver
  [[ ! -d /usr/share ]] && mkdir /usr/share
  [[ ! -d /usr/share/mediaptre ]] && mkdir /usr/share/mediaptre
  [[ ! -d /usr/share/mediaptre/local ]] && mkdir /usr/share/mediaptre/local
  [[ ! -d /usr/share/mediaptre/local/log ]] && mkdir /usr/share/mediaptre/local/log
  [[ ! -d /usr/share/mediaptre/local/log/lognull ]] && mkdir /usr/share/mediaptre/local/log/lognull
  [[ ! -d /etc/VPS-AGN/B-VPS-AGNuser ]] && mkdir /etc/VPS-AGN/B-VPS-AGNuser
  [[ ! -d /usr/local/protec ]] && mkdir /usr/local/protec
  [[ ! -d /usr/local/protec/rip ]] && mkdir /usr/local/protec/rip
  [[ ! -d /etc/protecbin ]] && mkdir /etc/protecbin
  cd
  [[ ! -d /etc/VPS-AGN/v2ray ]] && mkdir /etc/VPS-AGN/v2ray
  [[ ! -d /etc/VPS-AGN/Slow ]] && mkdir /etc/VPS-AGN/Slow
  [[ ! -d /etc/VPS-AGN/Slow/install ]] && mkdir /etc/VPS-AGN/Slow/install
  [[ ! -d /etc/VPS-AGN/Slow/Key ]] && mkdir /etc/VPS-AGN/Slow/Key
  touch /usr/share/lognull &>/dev/null
  wget -O /bin/resetsshdrop https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/LINKS-LIBRARIES/resetsshdrop &>/dev/null
  chmod +x /bin/resetsshdrop
  grep -v "^PasswordAuthentication" /etc/ssh/sshd_config >/tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
  echo "PasswordAuthentication yes" >>/etc/ssh/sshd_config
  rm -rf /usr/local/lib/systemubu1 &>/dev/null
  rm -rf /etc/versin_script &>/dev/null
  v1=$(curl -sSL "https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/SCRIPT-v8.5x/Version")
  echo "$v1" >/etc/versin_script
  wget -O /etc/versin_script_new https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/SCRIPT-v8.5x/Version &>/dev/null
  echo '#!/bin/sh -e' >/etc/rc.local
  sudo chmod +x /etc/rc.local
  echo "sudo resetsshdrop" >>/etc/rc.local
  echo "sleep 2s" >>/etc/rc.local
  echo "exit 0" >>/etc/rc.local
  echo 'clear' >>.bashrc
  echo 'echo ""' >>.bashrc
  echo 'echo -e "\t\033[91m __      _______   _____              " ' >>.bashrc
  echo 'echo -e "\t\033[91m \ \    / /  __ \ / ____|        " ' >>.bashrc
  echo 'echo -e "\t\033[91m  \ \  / /| |__) | (___   " ' >>.bashrc
  echo 'echo -e "\t\033[91m   \ \/ / |  ___/ \___ \  " ' >>.bashrc
  echo 'echo -e "\t\033[91m    \  /  | |     ____) |     " ' >>.bashrc
  echo 'echo -e "\t\033[91m     \/   |_|    |_____/    " ' >>.bashrc
  echo 'wget -O /etc/versin_script_new https://raw.githubusercontent.com/khaledagn/VPS-AGN_English_Official/master/SCRIPT-v8.5x/Version &>/dev/null' >>.bashrc
  echo 'echo "" ' >>.bashrc
  echo 'mess1="$(less /etc/VPS-AGN/message.txt)" ' >>.bashrc
  echo 'echo "" ' >>.bashrc
  echo 'echo -e "\t\033[92mAUTOR : Juan F. "' >>.bashrc
  echo 'echo -e "\t\033[92mTELEGRAM : @JuanFCol "' >>.bashrc
  echo 'echo -e "\t\e[1;33mVERSION: \e[1;31m$(cat /etc/versin_script_new)"' >>.bashrc
  echo 'echo "" ' >>.bashrc
  echo 'echo -e "\t\033[97mPARA MOSTRAR EL PANEL DIGITA: men "' >>.bashrc
  echo 'echo ""' >>.bashrc
  rm -rf /usr/bin/pytransform &>/dev/null
  rm -rf VPS-AGN.sh
  rm -rf lista-arq
  service ssh restart &>/dev/null
  clear && clear
  msg -bar
  echo -e "\e[1;92m             >> INSTALACION COMPLETA. <<" && msg bar2
  echo -e "      DIGITE EL SIGUIENTE COMANDO PARA ACCEDER AL PANEL "
  echo -e "                      \033[1;41m  men  \033[0;37m" && msg -bar2
}

#MENUS
/bin/cp /etc/skel/.bashrc ~/
/bin/cp /etc/skel/.bashrc /etc/bash.bashrc
echo -ne " \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m > \e[1;97m INSTALAR 8.5x OFFICIAL By. @JuanFCol \e[97m \n"
echo -ne " \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m > \033[1;97m INSTALAR ADMRufu MOD \e[97m \n"
msg -bar
echo -ne "\033[1;97mINGRESE SOLO EL NUMERO ACORDE A SU OPCION:\e[32m "
read opcao
case $opcao in
1)
  install_official
  ;;
2)
  install_ADMRufu
  ;;
esac
exit
