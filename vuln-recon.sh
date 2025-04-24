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

subfinder -d $target | tee subdomain.txt

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

echo -e $blue"[*] We Use (waybackurls, gau) For Find vulns...!!\n"$white

clear

echo -e $pruple"[*] Type This In Terminal >>> (cat live-subdomain.txt | waybackurls | tee urls-waybackurls.txt) \n"

echo -e "[*] Type This In Terminal >>> (cat live-subdomain.txt | gau | tee urls-gau.txt) \n"$white

read -p "Do You Understand..? (Y/n): " response

if [[ "$response" == "y" || "$response" == "" || "$response" == "Y" ]]; then
  count=1

while [ $count -le 1 ]; do

    konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash"

    clear

    echo -e $pruple"[*] Type This In Terminal >>> (cat live-subdomain.txt | waybackurls | tee urls-waybackurls.txt) \n"

    echo -e "[*] Type This In Terminal >>> (cat live-subdomain.txt | gau | tee urls-gau.txt) \n"$white

    sort -u urls-waybackurls.txt urls-gau.txt | tee url.txt

    cat url.txt | grep "=" | tee params.txt

    if [ ! -s params.txt ]; then
    echo -e $red"[/] The (waybackurls, gau) Didnt Find Any Bug....."$white
    exit
    fi

    count=$((count + 1))
done
elif [[ "$response" == "n" ]]; then
  exit
else
  echo "Invalid input. Please enter 'y' or 'n'."
fi

echo -e $lpurp"[+] The (waybackurls, gau) Done...!!\n"$white

mkdir vulns

echo -e $blue"[*] We Use (gf -list) For Find vulns...!!\n"$white

clear


konsole -e bash -c "sleep 1; xdotool type 'cat params.txt | gf lfi | tee vulns/lfi.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat params.txt | gf sqli | tee vulns/sqli.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat params.txt | gf upload-fields | tee vulns/upload-fields.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat params.txt | grep '=http' | qsreplace 'https://evil.com' | httpx-toolkit -silent -fr -location | grep 'evil.com' | tee vulns/openredirect.txt'; xdotool key Return; exec bash"

konsole -e bash -c "sleep 1; xdotool type 'cat params.txt | gf xss | tee vulns/potential-xss.txt && cat vulns/potential-xss.txt | gf xss | kxss | tee vulns/live-xss.txt'; xdotool key Return; exec bash"

clear

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
\n"$white

echo -e $green"[+] Thank You For Use Tool...!!"$white
