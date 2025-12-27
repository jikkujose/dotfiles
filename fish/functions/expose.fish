# Expose local port via localhost.run
function expose
    if test -z "$argv[1]"
        echo "Usage: expose <port>"
        return 1
    end
    set -l port $argv[1]
    ssh -R 80:localhost:$port nokey@localhost.run 2>&1 | awk '/https:\/\/[a-zA-Z0-9]+\.lhr\.life/ {print $NF; fflush(); exit}'
end
