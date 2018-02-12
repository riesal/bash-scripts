#!/bin/bash
# auto pull from github
# you can place it under cronjob
# pretty much self-explanatory

pushd /home/user/project > /dev/null 2>&1

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Sudah Up-to-date. Ga perlu ngapa-ngapain"
elif [ $LOCAL = $BASE ]; then
    echo "Ada yang baru, perlu nge-pull.."
    git pull
    # gradle build
    # sudo service nginx restart
elif [ $REMOTE = $BASE ]; then
    echo "Kamu ada ngerjain sesuatu yg perlu di push.."
    echo -e "Push manual aja ya.."
else
    echo "Diverged."
fi

popd > /dev/null 2>&1
