#!/usr/bin/bash

declare GITHUB_EMAIL=$(git config user.email)
read -p "-- Your git EMAIL is: $GITHUB_EMAIL. Is it the same for github? y/N -> " \
	CHECK
if [ ! "${CHECK,,}" = "y" ] ; then 
	read -p "Enter your github EMAIL: " GITHUB_EMAIL
fi

echo ">>>> Generating ssh key."
ssh-keygen -t $1 -C "$GITHUB_EMAIL" 
echo ">>>> Restarting ssh agent."
eval "$(ssh-agent -s)"
ssh-add 

cat $HOME/.ssh/id_$1.pub | xclip -sel clip

if [[ $? -ne 0 ]] ; then
	echo ">>>> Xclip has returned an error.
>>>> To ensure you have xclip installed, run 'sudo dnf install xclip'"
	exit
fi

echo ">>>> Your public key has been copied to your clipboard."
echo ">>>> All you need to do now is go to github and paste it."
echo ">>>> Link: https://github.com/settings/ssh/new" 
