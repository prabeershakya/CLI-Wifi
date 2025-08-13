#! /bin/bash



echo "1) Connect to Wifi"
echo "2) Froget a Wifi"
echo "3) Change Wifi"
read -p "Select Among these: " choice

case $choice in

1)
  clear
  # Listing Networks 
  WIFI=$(nmcli --fields "BSSID,SSID,SECURITY,SIGNAL,BARS" device wifi list)
  echo "${WIFI}"


  # Prompt user to select
  read -p 'Network SSID: ' "SSID"

  IS_SECURE=$(echo "$WIFI" | grep -w "$SSID  ")
  # echo "$IS_SECURE"
  IS_SAVED=$(nmcli -t -f NAME connection show | grep -Fx "$SSID")

  # If wifi is saved Exit and echo Already Saved
  # echo "$IS_SAVED"
  if [[ "$SSID" == "$IS_SAVED" ]]; then
	  echo "Already Saved in Network Manager."
	  nmcli con up id $SSID
	  exit 1
  else

  # Verifying if the network exists 
	  if [ -z "$IS_SECURE" ]; then
		  echo -e "No such network Exists, \e[31mQuitting!!!\e[0m"
		  exit 1
	  else
		  echo "The network $SSID found, Procceding to Connect..."
	  fi

  # Checking if Network is Secure or not || Prompting Password
	  if [[ $IS_SECURE == *"WPA1"* || $IS_SECURE == *"WPA2"* ]]; then
	      read -p "Enter the Password: " pass
        nmcli device wifi connect "$SSID" password "$pass"
        nmcli con modify "$SSID" conenction.autoconnect yes 2> /dev/null
	  else
		  echo "This is a Open Network, Trying to Connect..."
      nmcli con up "$SSID"
		  exit 1
	  fi
  fi
;;

2) 
  read -p "Enter a SSID of Wifi: " wifi
  nmcli con delete "$wifi"
  ;;

3)
  read -p "Enter a know Wifi within a Range: " known_wifi
  nmcli con up "$known_wifi"
  ;;
*) 
  echo "Invalid Choice !"
  exit 1
  ;;

esac







