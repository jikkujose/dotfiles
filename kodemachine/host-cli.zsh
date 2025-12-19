# kodemachine/host-cli.zsh
# Source this in your ~/.zshrc on host mac

kodemachine() {
    local vm="kodemachine"
    local ip="192.168.64.X"  # ← UPDATE THIS after first boot
    local vm_path="$HOME/Library/Containers/com.utmapp.UTM/Data/Documents/${vm}.utm"

    case "$1" in
        start)
            if [[ "$2" == "--gui" ]]; then
                utmctl start "$vm"
            else
                utmctl start "$vm" --hide
            fi
            echo "⏳ waiting for ssh..."
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
        status)
            utmctl status "$vm"
            ;;
        stats)
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  kodemachine stats"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "  status: $(utmctl status "$vm" 2>/dev/null || echo "unknown")"
            echo ""
            echo "  disk usage:"
            if [[ -d "$vm_path" ]]; then
                du -sh "$vm_path"/*.qcow2 2>/dev/null | while read size file; do
                    echo "    $(basename "$file"): $size"
                done
                echo ""
                echo "  total: $(du -sh "$vm_path" | cut -f1)"
            else
                echo "    vm not found at $vm_path"
            fi
            echo ""
            echo "  host free: $(df -h / | tail -1 | awk '{print $4}')"
            echo ""
            ;;
        --help|-h|help)
            echo "kodemachine - software-defined workstation"
            echo ""
            echo "usage: kodemachine <command> [options]"
            echo ""
            echo "commands:"
            echo "  start        start headless + ssh"
            echo "  start --gui  start with gui window + ssh"
            echo "  stop         shutdown vm"
            echo "  pause        suspend (instant resume)"
            echo "  ssh          ssh into running vm"
            echo "  ip           show vm ip address"
            echo "  status       show vm state"
            echo "  stats        show disk usage & status"
            echo "  --help       show this help"
            echo ""
            echo "workflow:"
            echo "  kodemachine start       # morning"
            echo "  kodemachine pause       # end of day"
            echo "  kodemachine stop        # weekly/moving qcow2"
            echo ""
            ;;
        *)
            kodemachine --help
            ;;
    esac
}