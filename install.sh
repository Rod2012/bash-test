#!/bin/bash

# create the /opt/directory

if [ $(id -u) -ne 0 ]; then
    echo "You need to be root to run this script"
    exit 1
fi

working_path="/opt/automata"

mkdir -p $working_path
chown root:root -R  $working_path
chmod 775 -R $working_path

cd $working_path

wget -qO - https://raw.githubusercontent.com/egzakutacno/myria_automata/main/automata02.sh

wget -q https://raw.githubusercontent.com/egzakutacno/myria_automata/main/myCronTimeCheckerHK.service

wget -q https://raw.githubusercontent.com/egzakutacno/myria_automata/main/myCronTimeCheckerHK.timer

cp myCronTimeCheckerHK.* /etc/systemd/system

systemctl start myCronTimeCheckerHK.timer

systemctl enable --now myCronTimeCheckerHK.timer

systemctl enable myCronTimeCheckerHK.timer

exit 0