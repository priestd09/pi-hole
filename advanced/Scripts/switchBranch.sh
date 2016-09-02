#!/usr/bin/env bash
# Pi-hole: A black hole for Internet advertisements
# (c) 2015, 2016 by Jacob Salmela
# Network-wide ad blocking via your Raspberry Pi
# http://pi-hole.net
# Whitelists domains
#
# Pi-hole is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.

#rootcheck
if [[ $EUID -eq 0 ]];then
	echo "::: You are root."
else
	echo "::: sudo will be used."
	# Check if it is actually installed
	# If it isn't, exit because the install cannot complete
	if [ -x "$(command -v sudo)" ];then
		export SUDO="sudo"
	else
		echo "::: Please install sudo or run this script as root."
		exit 1
	fi
fi

function helpFunc()
{
	echo "::: Switches to another branch of Pi-hole"
	echo ":::"
	echo "::: Usage: pihole -sw [ -m | -d ]"
	echo ":::"
	echo "::: Options:"
	echo ":::  -m, --master			Switch to the official release"
	echo ":::  -d, --dev			Bleeding edge. Liable to break. But you'll be cool. So cool."
	exit 1
}

piholeDir=/etc/.pihole/
webDir=/var/www/html/admin/

function masterFunc{
    echo "::: Switching to master branch"
    cd ${piholeDir}
    ${SUDO} git reset --hard
    ${SUDO} git checkout master
    ${SUDO} git pull

    cd ${webDir}
    ${SUDO} git reset --hard
    ${SUDO} git checkout master
    ${SUDO} git pull

    ${SUDO} pihole -up
}

function devFunc{
echo "::: Switching to master branch"
    cd ${piholeDir}
    ${SUDO} git reset --hard
    ${SUDO} git checkout development
    ${SUDO} git pull

    cd ${webDir}
    ${SUDO} git reset --hard
    ${SUDO} git checkout devel
    ${SUDO} git pull

    ${SUDO} pihole -up
}

}if [[ $# = 0 ]]; then
	helpFunc
fi

###################################################

for var in "$@"
do
  case "$var" in
    "-m"| "--master"  ) masterFunc;;
    "-d" | "--dev"   ) devFunc;;
    "-h" | "--help"      ) helpFunc;;
  esac
done
