#!/usr/bin/env bash

cd "/home/eldou/Music/dl/yt"

youtube-dl -x --audio-format "mp3" "$@"