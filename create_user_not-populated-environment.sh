#!/bin/bash

if [[ $# -lt '1' ]] || [[ $# -ge '2' ]]
then
	echo -e "$0 PASSWD-location SHADOW-location"
	exit 1 
fi

echo -e "\nCria os usuários para ambientes, precisa ter somente o /etc/passwd.\n\n"

local_passwd="$1"

users="$(sort <<< "$(grep -E ':x:[0-9]{4,}' "$local_passwd")")"

# Rmover o X do passwd
var_passwd="$(sed 's/:x:/:/' <<< "$users")"

# Ajeita tudo
export IFS=:

while read nome uid gid display_name home shell
do

	echo "useradasd -m -s $shell -c \"$display_name\" -p \"$(openssl passwd -6 "MudePorFav0r123")\" $nome"
done <<< "$var_passwd" | tr -d ','

