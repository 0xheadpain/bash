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

echo -e $blue"[*] We Use (waybackurls, gau) For Find vulns...!!\n"$white

clear

echo -e $pruple"[*] Type This In Terminal >>> (cat live-subdomain.txt | waybackurls | tee urls-waybackurls.txt) \n"

echo -e "[*] Type This In Terminal >>> (cat live-subdomain.txt | gau | tee urls-gau.txt) \n"$white

read -p $red"Do You Understand..? (Y/n): " response
$white
if [[ "$response" == "y" || "$response" == "" || "$response" == "Y" ]]; then
  count=1

while [ $count -le 1 ]; do

    konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash"

    clear

    echo -e $pruple"[*] Type This In Terminal >>> (cat live-subdomain.txt | waybackurls | tee urls-waybackurls.txt) \n"

    echo -e "[*] Type This In Terminal >>> (cat live-subdomain.txt | gau | tee urls-gau.txt) \n"$white

    sort -u urls-waybackurls.txt urls-gau.txt | tee url.txt

    cat url.txt | grep "=" | tee params.txt

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

echo -e $pruple"[*] Type This For $blue (XSS) $pruple In Terminal >>> (cat params.txt | gf xss | tee vulns/potential-xss.txt) \n $red IF This Done Type This \n $pruple (cat potential-xss.txt | xargs -n1 -P 20 kxss > vulns/reflected-xss.txt) \n"

echo -e "[*] Type This $blue (LFI) $pruple In Terminal >>> (cat params.txt | gf lfi | tee vulns/lfi.txt) \n"$white

echo -e "[*] Type This $blue (SQLI) $pruple In Terminal >>> (cat params.txt | gf sqli | tee vulns/sqli.txt) \n"$white

echo -e "[*] Type This $blue (UPLOUD-FILE) $pruple In Terminal >>> (cat params.txt | gf upload-fields | tee vulns/upload-fields.txt) \n"$white

echo -e "[*] Type This $blue (REDIRECT) $pruple In Terminal >>> (cat params.txt | grep '=http' | qsreplace 'https://evil.com' | httpx-toolkit -silent -fr -location | grep 'evil.com' | tee vulns/openredirect.txt) \n"$white

read -p $red"Do You Understand..? (Y/n): " response
$white
if [[ "$response" == "y" || "$response" == "" || "$response" == "Y" ]]; then
  count=1

while [ $count -le 1 ]; do

    konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" | konsole -e bash -c "sleep 1; xdotool type ''; xdotool key Return; exec bash" 

    clear

    echo $red"[-] I Know You Didn't UndersTanding...!!\n"$white

    echo -e $pruple"[*] Type This For $blue (XSS) $pruple In Terminal >>> (cat params.txt | gf xss | tee vulns/potential-xss.txt) \n $red IF This Done Type This \n $pruple (cat potential-xss.txt | xargs -0 -P 20 kxss > vulns/reflected-xss.txt) \n"

    echo -e "[*] Type This $blue (LFI) $pruple In Terminal >>> (cat params.txt | gf lfi | tee vulns/lfi.txt) \n"$white

    echo -e "[*] Type This $blue (SQLI) $pruple In Terminal >>> (cat params.txt | gf sqli | tee vulns/sqli.txt) \n"$white

    echo -e "[*] Type This $blue (UPLOUD-FILE) $pruple In Terminal >>> (cat params.txt | gf upload-fields | tee vulns/upload-fields.txt) \n"$white

    echo -e "[*] Type This $blue (REDIRECT) $pruple In Terminal >>> (cat params.txt | grep '=http' | qsreplace 'https://evil.com' | httpx-toolkit -silent -fr -location | grep 'evil.com' | tee vulns/openredirect.txt) \n"$white

    count=$((count + 1))
done
elif [[ "$response" == "n" ]]; then
  exit
else
  echo "Invalid input. Please enter 'y' or 'n'."
fi

echo -e $green"[+] All Tasks Done..!!"$white
