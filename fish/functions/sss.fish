# Deploy to surge.sh
function sss
    surge . "https://$argv[1].surge.sh"
end
