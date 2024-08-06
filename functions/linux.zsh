ww() {
    if [ -z "$1" ]; then
        echo "Usage: ww <domain>"
        return 1
    fi
    whois "$1" | grep "Registrant Name"
}
