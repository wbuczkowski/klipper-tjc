CONFIG_DIR=/home/pi/klipper_config/tjc_display
SUPPORT_FILE=$CONFIG_DIR/support.txt


echo -e "---------------------------------------"
echo -e "Klipper for TJC Support file generator"
echo -e "---------------------------------------"
echo -e "\n"
echo -e "This script will collect information for getting help"
echo -e "\nYou will be asked to enter sudo password"


date=$(date +"%D %T")
echo -e "Date: $date" > $SUPPORT_FILE

user=$(whoami)
echo -e "User: $user" >> $SUPPORT_FILE


echo -e "Git Revision (local):" >> $SUPPORT_FILE
git rev-parse HEAD >> $SUPPORT_FILE

echo -e "Git Revision (github):" >> $SUPPORT_FILE
git ls-remote origin -h refs/heads/master >> $SUPPORT_FILE

echo -e "\nsystem throttled?"
echo -e "\nThrottled State:" >> $SUPPORT_FILE
vcgencmd get_throttled >> $SUPPORT_FILE

echo -e "\nSerial interfaces"
echo -e "\nSerial interfaces:" >> $SUPPORT_FILE
ls -la /dev/serial/* >> $SUPPORT_FILE

echo -e "\n" >> $SUPPORT_FILE
python3 src/printout_common_config.py -c $CONFIG_DIR >> $SUPPORT_FILE
echo -e "\n" >> $SUPPORT_FILE

echo -e "\n'systemctl status klipper_tjc.service'"
echo -e "Systemd service status:" >> $SUPPORT_FILE
systemctl status klipper_tjc >> $SUPPORT_FILE

echo -e "\njournalctl -u klipper_tjc"
echo -e "\nLog Ausgaben:" >> $SUPPORT_FILE
journalctl -u klipper_tjc >> $SUPPORT_FILE


