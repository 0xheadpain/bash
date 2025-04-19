#!/bin/bash

clear

black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
pruple='\033[0;35m'
lpurp='\033[1;35m'
white='\033[1;37m'

echo -e $lpurp"
 ██▒   █▓ █    ██  ██▓     ███▄    █  ██▀███  ▓█████  ▄████▄   ▒█████   ███▄    █ 
▓██░   █▒ ██  ▓██▒▓██▒     ██ ▀█   █ ▓██ ▒ ██▒▓█   ▀ ▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █ 
 ▓██  █▒░▓██  ▒██░▒██░    ▓██  ▀█ ██▒▓██ ░▄█ ▒▒███   ▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒
  ▒██ █░░▓▓█  ░██░▒██░    ▓██▒  ▐▌██▒▒██▀▀█▄  ▒▓█  ▄ ▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒
   ▒▀█░  ▒▒█████▓ ░██████▒▒██░   ▓██░░██▓ ▒██▒░▒████▒▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░
   ░ ▐░  ░▒▓▒ ▒ ▒ ░ ▒░▓  ░░ ▒░   ▒ ▒ ░ ▒▓ ░▒▓░░░ ▒░ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
   ░ ░░  ░░▒░ ░ ░ ░ ░ ▒  ░░ ░░   ░ ▒░  ░▒ ░ ▒░ ░ ░  ░  ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░
     ░░   ░░░ ░ ░   ░ ░      ░   ░ ░   ░░   ░    ░   ░        ░ ░ ░ ▒     ░   ░ ░ 
      ░     ░         ░  ░         ░    ░        ░  ░░ ░          ░ ░           ░ 
     ░                                               ░                            
"$white

target=$1

if [ $target = '-h' ]; then

echo -e $blue"The Help Option...!"$white
echo -e "=============================\n"
echo -e $pruple"./main.sh target.com\n"
echo -e $lpurp"./main.sh domain.dns\n"$white
echo -e "============================="
echo -e $blue"This Tool Created By$red head_pain"

exit

fi

mkdir vuln-recon

cd vuln-recon

echo -e $black"[*] We Use (subfinder) For Find Subdomain...!!\n"$white

subfinder -d $target -o subdomain.txt

if [ ! -s subdomain.txt ]; then
    echo -e $red"[/] The (subfinder) Didnt Find Any Bug....."$white
    exit
fi

echo -e $pruple"[+] The (subfinder) Done...!!\n"$white

echo -e $black"[*] We Use (httpx-toolkit) For Find Live-Subdomain...!!\n"$white

cat subdomain.txt | httpx-toolkit > live-subdomain.txt

if [ ! -s live-subdomain.txt ]; then
    echo -e $red"[/] The (httpx-toolkit) Didnt Find Any Bug....."$white
    exit
fi

echo -e $lpurp"[+] The (httpx-toolkit) Done...!!\n"$white

echo -e $blue"[*] We Use (waybackurls) For Find vulns...!!\n"$white

echo -e $black"[*] If The Tool Done Close The Terminal...!!\n"$white

konsole -e bash -c "sleep 1; xdotool type 'cat live-subdomain.txt | waybackurls | gf xss | kxss | tee xss.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat live-subdomain.txt | waybackurls | gf lfi | tee lfi.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat live-subdomain.txt | waybackurls | gf sqli | tee sqli.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat live-subdomain.txt | waybackurls | gf upload-fields | tee upload-fields.txt'; xdotool key Return; exec bash"

echo -e $pruple"[+] The (waybackurls) Done...!!\n"$white

echo -e $green"[/] All Works Is Done...!!"$white
