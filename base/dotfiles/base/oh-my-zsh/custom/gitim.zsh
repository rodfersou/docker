if [[ "$WINDOW" == '1' ]]; then
    if [ $(ls /srv | wc -l) = "0"  ]; then
        gitim -d /srv --ssh --shallow
    fi
fi
