#!/bin/bash

HOST="localhost"

CODE=$(cat << EOF
--- MY CODE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function init()
    self.colors = { 0xFF0000, 0x808080 }
end

function step()
    return -0.05
end

EOF
)

registerUser() {
    username=$1
    password=$(cksum <<< "$username" | cut -f 1 -d ' ')

    html=$(curl -s --cookie-jar cookie.txt "$HOST/signup/") || { echo "Failed to signup user $username with password $password"; return; }
    csrfMiddlewareToken=$(echo $html | grep -oP "'csrfmiddlewaretoken' value='\K[a-zA-Z0-9]*")

    curl -s -X POST -b cookie.txt -F "csrfmiddlewaretoken=$csrfMiddlewareToken" -F "username=$1" -F "password1=$password" -F "password2=$password" $HOST/signup/ > /dev/null
    echo "Registered Username: $username, password: $password"

    html=$(curl -s --cookie-jar cookie.txt "$HOST/login/")
    csrfMiddlewareToken=$(echo $html | grep -oP "'csrfmiddlewaretoken' value='\K[a-zA-Z0-9]*")

    curl -s -X POST -b cookie.txt --cookie-jar cookie.txt -F "csrfmiddlewaretoken=$csrfMiddlewareToken" -F "username=$username" -F "password=$password" "$HOST/login/?next=/snake/edit/latest" > /dev/null
    echo "Logged in user $username with password $password"

    echo -e "\e[42mTrying to join\e[49m"
    html=$(curl -s -b cookie.txt --cookie-jar cookie.txt "$HOST/snake/edit/latest")
    csrfMiddlewareToken=$(echo $html | grep -oP "'csrfmiddlewaretoken' value='\K[a-zA-Z0-9]*")

    curl -s -X POST -b cookie.txt --header "X-CSRFToken: $csrfMiddlewareToken" --header "X-Requested-With: XMLHttpRequest" -F "action=run" -F "code=$CODE" -F "comment=null" -F "parent=6" "localhost/snake/edit/latest" --trace-ascii /dev/stdout # > /dev/null
    #curl -v --request POST -b cookie.txt --header "X-CSRFToken: $csrfMiddlewareToken" --header "X-Requested-With: XMLHttpRequest" --data '{"action":"run","code":"'"$CODE"'", "comment":null,"parent":null}' "localhost/snake/edit/latest" --trace-ascii /dev/stdout
    #curl -v -X POST -b cookie.txt --header "X-CSRFToken: $csrfMiddlewareToken" --header "X-Requested-With: XMLHttpRequest" "localhost/snake/restart"
    #curl -v -X POST -b cookie.txt --header "X-CSRFToken: $csrfMiddlewareToken" --header "X-Requested-With: XMLHttpRequest" -F "action=run" -F "code=$CODE" -F "comment=null" -F "parent=null" "localhost/snake/edit/latest"
    #curl -v -X POST -b cookie.txt --header "X-CSRFToken: $csrfMiddlewareToken" --header "X-Requested-With: XMLHttpRequest" -F "action=restart" -F "code=$CODE" -F "comment=null" -F "parent=null" "localhost/snake/edit/latest"
}

registerAllUsers() {
    cat usernames/survivers.txt usernames/killers.txt usernames/feeders.txt | while read username
    do
        registerUser $username
    done
}

#registerAllUsers
registerUser Malte
