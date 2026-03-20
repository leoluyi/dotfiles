#!/usr/bin/env bash

screencapture -i ~/.cache/screenshot.png

curl -F'file=@'"${HOME}"/.cache/screenshot.png https://0x0.st | pbcopy
