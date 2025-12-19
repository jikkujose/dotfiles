# kodemachine control
kodemachine() {
    local vm="kodemachine"
    local ip="192.168.64.X"  # ← set after first boot

    case "$1" in
        start)
            if [[ "$2" == "--gui" ]]; then
                utmctl start "$vm"
            else
                utmctl start "$vm" --hide
            fi
            # Wait for SSH, then connect
            echo "Waiting for SSH..."
            until nc -z "$ip" 22 2>/dev/null; do sleep 1; done
            ssh kodeman@"$ip"
            ;;
        stop)
            utmctl stop "$vm"
            ;;
        pause)
            utmctl suspend "$vm"
            ;;
        ssh)
            ssh kodeman@"$ip"
            ;;
        ip)
            echo "$ip"
            ;;
        *)
            echo "usage: kodemachine {start [--gui]|stop|pause|ssh|ip}"
            ;;
    esac
}