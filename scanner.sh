#!/bin/bash

# Arg check
if [ -z "$1" ]; then
    echo "Uso: $0 <IP> [--save]"
    exit 1
fi

IP="$1"
SAVE=false

# Save flag
if [ "$2" == "--save" ]; then
    SAVE=true
fi

if ! sudo -v >/dev/null 2>&1; then
    echo "[-] Needed sudo verified"
    exit 1
fi


spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r[*] 👀📌... %c " "${spinstr:$i:1}"
            sleep $delay
        done
    done
    printf "\r"
}

spinner2() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r[*] ✏️📘... %c " "${spinstr:$i:1}"
            sleep $delay
        done
    done
    printf "\r"
}

# Open port scan 
echo "[*] Scanning open ports in $IP..."
if $SAVE; then
    /usr/bin/sudo /usr/bin/nmap --open -Pn -sS --min-rate 2500 -p- "$IP" \
        > $PWD/simplescan.txt 2>/dev/null &
    pid=$!
    spinner $pid
    wait $pid
    PORTS=$(grep "open" simplescan.txt | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
else
    /usr/bin/sudo /usr/bin/nmap --open -Pn -sS --min-rate 2500 -p- "$IP" \
        2>/dev/null \
        | tee >(grep "open" | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//' > /tmp/ports.tmp) &
    pid=$!
    spinner $pid
    wait $pid
    PORTS=$(cat /tmp/ports.tmp)
    rm -f /tmp/ports.tmp
fi


if [ -z "$PORTS" ]; then
    echo "[-] No open ports $IP"
    exit 1
fi


echo "[*] Script/Version scan"

if $SAVE; then
    /usr/bin/sudo /usr/bin/nmap -sCV --open -p "$PORTS" "$IP" \
        > $PWD/detailedscan.txt 2>/dev/null &
    pid=$!
    spinner2 $pid
    wait $pid
    echo "[+] Saved in ($PWD) simplescan.txt & detailedscan.txt"
else
    /usr/bin/sudo /usr/bin/nmap -sCV --open -p "$PORTS" "$IP" 2>/dev/null &
    pid=$!
    spinner2 $pid
    wait $pid
fi
