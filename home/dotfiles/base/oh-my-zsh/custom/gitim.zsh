rm /srv/srv 2> /dev/null || true
# not inside screen
if [[ -z "$STY" ]]; then
    if [ $(ls /srv | wc -l) = "0"  ]; then
        gitim -d /srv --ssh --shallow
    fi
fi
