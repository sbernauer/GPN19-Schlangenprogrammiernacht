#!/bin/bash

HOST="localhost"
FILES="../usernames.txt"

registerUser() {
    username=$1
    password=$(cksum <<< "$username" | cut -f 1 -d ' ')

    html=$(curl -s --cookie-jar cookie.txt "$HOST/signup/") || { echo "Failed to signup user $username with password $password"; return; }
    csrfMiddlewareToken=$(echo $html | grep -oP "'csrfmiddlewaretoken' value='\K[a-zA-Z0-9]*")

    curl -s -X POST -b cookie.txt -F "csrfmiddlewaretoken=$csrfMiddlewareToken" -F "username=$1" -F "password1=$password" -F "password2=$password" $HOST/signup/ > /dev/null
    echo "Registered Username: $username, password: $password" | tee -a register.log

}

registerAllUsers() {
    rm -f register.log
    cat "$FILES" | while read username
    do
        registerUser $username
    done
}

registerAllUsers
