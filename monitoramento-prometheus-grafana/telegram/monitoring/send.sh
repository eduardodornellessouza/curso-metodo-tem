#!/bin/bash

export TOKEN="6059455146:AAGNNBejs6yMNOA7NQR3sGHUuV0s3ehZ9Gc"
export ID="-939573571"
export URL="https://api.telegram.org/bot$TOKEN/sendMessage"
#export MSG=$(cat ./send.txt)

curl -s -X POST $URL -d chat_id=$ID -d text="teste pelo grupo"
