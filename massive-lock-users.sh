#!/bin/bash
# riesal@gmail.com

isLinux=$(uname -s)
users=( user1 user2 user3 user4 user5 etc )

clear

function ch_pass_linux()
{
  passwd -l $i > /dev/null 2>&1 # set lock
  chage -E 0 $i > /dev/null 2>&1 # set expiration immediately
}

function ch_pass_sunos()
{
  passwd -l $i > /dev/null 2>&1 # just set lock
}

echo -e "This script will lock ${#users[@]} unused users from this server.\n"

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

echo -e "Locking and expiring password is completed,\nthere are ${#users[@]} users in total."
echo -e "\nList of locked & expired users password.."

if [[ $isLinux = False ]]; then
for i in "${users[@]}"
do
  a=$(grep $i /etc/shadow | cut -d':' -f2 | cut -d'*' -f2 | cut -c1-2)
  if [[ "$a" == "LK" ]]; then
    echo -e "\tUser $i is already locked."
  fi
done
else
for i in "${users[@]}"
do

  a=$(grep $i /etc/shadow | cut -d':' -f2 | cut -c1-2)
  b=$(grep $i /etc/shadow | tail -c 3 | cut -c1)
    if [[ "$a" == "!!" && "$b" == "0" ]]; then
      echo -e "\t$i"
    fi
done
fi

# grep $i /etc/shadow | cut -d':' -f2 | cut -d'*' -f2 | cut -c1-2
# grep $i /etc/shadow | cut -d':' -f2 | cut -c1-2
# declare -F ch_pass_linux &>/dev/null && echo "ch_pass_linux() found." || echo "ch_pass_linux() not found."
