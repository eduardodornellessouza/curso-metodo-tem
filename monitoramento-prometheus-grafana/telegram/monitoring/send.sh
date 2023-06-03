#!/bin/bash

export TOKEN="<token_bot>"
export ID="<id_grupo>"
export URL="https://api.telegram.org/bot$TOKEN/sendMessage"
export MSG=$(cat ./send.txt)

curl -s -X POST $URL -d chat_id=$ID -d text=$MSG
