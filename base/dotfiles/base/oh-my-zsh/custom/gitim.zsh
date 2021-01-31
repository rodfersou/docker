if [[ "$WINDOW" == '1' ]]; then
    if [ $(ls /srv | wc -l) = "0"  ]; then
        (cd /srv && gitim -o rodfersou    -d . --ssh --shallow)
        (cd /srv && gitim -o boughtbymany -d . --ssh --shallow)
        (cd /srv && gitim -o slyinfo      -d . --ssh --shallow)
    fi
fi
