if [ $(ls /srv | wc -l) = "0"  ]; then
    (cd /srv && gitim -d . --ssh --shallow)
fi
