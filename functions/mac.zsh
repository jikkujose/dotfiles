ip(){
	echo "Ethernet: `ipconfig getifaddr en0 \n`"
	echo "External: `curl -s http://ipecho.net/plain`"
  echo "WiFi    : `ifconfig | grep inet | grep broadc | cut -d ' ' -f 2`"
}

