#!/bin/bash

echo "#####################################"
echo "TJC for Klipper (MainsailOS Install)"
echo "#####################################"

#Check that script is exectuted in klipper-tjc folder
if [ "${0%/*}" != "." ]
    then echo "The script needs to be runned from 'klipper-tjc' folder"
    exit
fi

#Install python3-venv
echo -e "\nInstalling python3-venv package"
sudo apt-get install python3-venv -y

echo -e "\nCreating Python Virtual Environment"

if [ -d ./venv ]; then
    echo "Found existing Python Virtual Environment"
    echo "Removing it..."
    rm -rf ./venv
fi

python3 -m venv venv
echo "Created Python Virtual Environment"


echo -e "\nActivating Python Virtual Environment"
source ./venv/bin/activate

echo -e "\nInstalling python dependencies"
pip3 install -r requirements.txt

echo -e "\nCopying config to klipper_config"
conf_dir=/home/$(whoami)/printer_data/config/tjc_display
mkdir -p $conf_dir
cp config/* $conf_dir

echo -e "\nCreating systemd service (autostart)"

#replace variables in template
cp klipper_tjc.service.templ klipper_tjc.service.tmp
tjc_dir=$(pwd)
user=$(whoami)
#set klipper-tjc folder in service
sed -i "s|<tjc_dir>|$tjc_dir|g" klipper_tjc.service.tmp
sed -i "s|<config_dir>|$conf_dir|g" klipper_tjc.service.tmp
sed -i "s|<user>|$user|g" klipper_tjc.service.tmp

echo -e "\nInstalling TJC for Klipper Service"
sudo cp klipper_tjc.service.tmp /etc/systemd/system/klipper_tjc.service
rm klipper_tjc.service.tmp

echo -e "\nReloading systemd services..."
sudo systemctl daemon-reload

echo -e "\nEnabling klipper_tjc.service"
sudo systemctl enable klipper_tjc.service

echo -e "\nStarting initial configuration"
echo -e "\n"
python3 src/config_edit.py -c $conf_dir

echo -e "\nDisplay should be available in arround 15 seconds"
sudo systemctl start tjc

echo -e "\nYou also need to include the 'tjc_display_macros.cfg' file in your printer.cfg"

exit


