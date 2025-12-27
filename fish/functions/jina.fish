# Fetch URL content via Jina AI reader
function jina
    if test -z "$argv[1]"
        echo "Usage: jina <URL>"
        return 1
    end
    curl -s "https://r.jina.ai/$argv[1]"
end
