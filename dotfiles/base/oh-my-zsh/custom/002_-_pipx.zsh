trap 'echo got SIGINT' SIGINT

export PATH="$HOME/.local/bin:/cache/pipx/bin:$PATH"
pipx ensurepath

rm /srv/srv 2> /dev/null || true
if [[ "$WINDOW" == '1' ]]; then
    if [ $(ls /srv | wc -l) = "0"  ]; then
        pipx install --include-deps                     \
             git+https://github.com/rodfersou/gitim.git \
        && pipx install ipython
    fi
else
    sleep 2
fi
while [ $(ps -ef | grep pipx | wc -l) = "2" ]; do
    sleep 1
done
clear

trap SIGINT
