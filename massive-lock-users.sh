#!/bin/bash
# riesal@gmail.com

isLinux=$(uname -s)
users=( user1 user2 user3 user4 user5 etc )

clear

function ch_pass_linux()
{
  passwd -l $i # set lock
  chage -E 0 $i # set expiration immediately
  echo -e "\tUser $i has been LOCKED successfuly\n"
  locked_ok=$(grep $i /etc/shadow | cut -d':' -f2 | cut -d'*' -f2 | cut -c1-2)
  locked_ok++
}

function ch_pass_sunos()
{
  passwd -l $i # just set lock
}

echo -e "This script will lock the unused users from this server"
echo -e "It may take a while..\n"

if [[ "$isLinux" == "Linux" ]]; then
  isLinux=True
  for i in "${users[@]}"
  do
    ch_pass_linux
  done
elif [[ "$isLinux" == "SunOS" ]]; then
  ch_pass_sunos
else
  echo -e "\nSystem unrecognised!"
  exit 1
fi

echo -e "\nLocking completed, there are ${#users[@]} users in total."
echo -e "\nList of locked users.. \n"

if [[ $isLinux = True ]]; then
  for i in "${users[@]}"
  do
    grep $i /etc/shadow | cut -d':' -f2 | cut -d'*' -f2 | cut -c1-2
  done
else
  grep $i /etc/shadow | cut -d':' -f2 | cut -c1-2
fi

# grep $i /etc/shadow | cut -d':' -f2 | cut -d'*' -f2 | cut -c1-2
# grep $i /etc/shadow | cut -d':' -f2 | cut -c1-2
# declare -F ch_pass_linux &>/dev/null && echo "ch_pass_linux() found." || echo "ch_pass_linux() not found."
