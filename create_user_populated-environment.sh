#!/bin/bash

if [[ $# -lt '2' ]] || [[ $# -ge '3' ]]
then
	echo -e "$0 PASSWD-location SHADOW-location"
	exit 1 
fi

echo -e "\nCria os usuários para ambientes onde o /home já exista, cria os usuário com suas respectivas senhas\nUID/GID, home e shell que estavam sendo usados anteriormente.\n\n"

local_passwd="$1"
local_shadow="$2"

users="$(sort <<< "$(grep -E ':x:[0-9]{4,}' passwd)")"

# Rmover o X do passwd
var_passwd="$(sed 's/:x:/:/' <<< "$users")"

# Ajeita tudo
export IFS=:

while read nome uid gid display_name home shell
do

	echo "useradasd -d $home -s $shell -u $uid -g $gid -c \"$display_name\" -p \"$(grep "$nome" $local_shadow | cut -d : -f 2)\" $nome"
done <<< "$var_passwd" | tr -d ','

