#!/bin/bash

#apk update
#apk add coreutils

current_time=`date +%k%M`

export OK="✅"
export NOT="⚠️"
export RED="⛔️"
export ALERT="🚧"
export DIR="."
export HEADER="$DIR/header.txt"
export MSG="$DIR/send.txt"
export LISTA="$DIR/lista.txt"
export TOP="$DIR/rec.txt"
export TMP="$DIR/tmp.txt"
export NAMESPACES="$DIR/namespaces.txt"
export EXCLUDE="NAME|kube*"


ls -la 

> $MSG
> $LISTA
> $TOP
> $TMP

_SEND() {
    bash ./monitoring/send.sh
}

_GETNODES() {
    kubectl get nodes > $LISTA
}

_TOPNODES() {
    kubectl top nodes > $TOP
}

_CHECK_NODES() {
    echo -n "%0A$ALERT%20[%20CHECKING%20NODES%20K8STEST%20]%0A%0A" >> $MSG
    echo -n "%20Status%20%20%20%20%20%20%20Node%0A" >> $MSG
    for i in $(cat $LISTA |awk '{print $1":"$2}')
    do
        SERVER=$(echo $i |cut -d ":" -f 1)
        STATUS=$(echo $i |cut -d ":" -f 2)
        
        if [ $STATUS = "Ready" ] && [ "$1" = "" ]; then
            echo -n "%20%20%20$OK%20%20%20%20%20%20$SERVER%20%20%20%20%0A" >> $MSG
        fi
        if [ $STATUS = "Ready,SchedulingDisabled" ]; then
            echo -n "%20%20%20$NOT%20%20%20%20%20%20$SERVER%20%20%20%20$STATUS%0A" >> $MSG
        fi
        if [ $STATUS = "NotReady" ]; then
            echo -n "%20%20%20$RED%20%20%20%20%20%20$SERVER%20%20%20%20$STATUS%0A" >> $MSG
        fi
    done
}

_MOUNT_LIST_NAMESPACE() {
    kubectl get namespaces |awk {'print $1'} > $NAMESPACES
}

_VALIDA_NAMESPACE() {
    SKIP="$1"
    echo -n "%0A$ALERT%20[%20CHECKING%20NAMESPACES%20K8STEST%20]%0A%0A" >> $MSG
    for NMP in $(cat $NAMESPACES |grep -E -v $EXCLUDE)
    do
        # kubectl -n $NMP get pods --no-headers | grep -E -v "Running|Completed|ContainerCreating|Terminating" | awk '{print $1":"$3}' > $TMP
        kubectl get pods -n $NMP --field-selector=status.phase=Pending > $TMP
        # kubectl -n telegram-status get pods --field-selector=status.phase=Pending --no-headers | grep -E -v "NAMESPACE|NAME|READY|STATUS|RESTARTS|AGE" | awk '{print $1":"$3}' 
        COUNT=$(cat $TMP |wc -l)
        if [ $COUNT -ge "2" ]; then
            echo -n "$RED%20$NMP%0A" >> $MSG
            for i in $(cat $TMP)
            do
                DEPLOY=$(echo $i |cut -d ":" -f 1)
                ERROR=$(echo $i |cut -d ":" -f 2)
                if [ $DEPLOY != "NAME" ]; then
                    echo -n "%20%20%20%20$NOT%20$DEPLOY%20$ERROR%0A" >> $MSG
                fi
            done
        else
            if [ "$1" = "" ]; then
                echo -n "$OK%20$NMP%0A" >> $MSG
            fi
        fi
    done
}

execute() {
    _GETNODES
    _CHECK_NODES "$1"
    _SEND >/dev/null

    > $MSG

    _MOUNT_LIST_NAMESPACE
    _VALIDA_NAMESPACE "$1"
    _SEND >/dev/null
}

check_time_to_run() {
    temp_time="$1"

    echo "Alerta namespaces status..."
    execute ""
}

check_time_to_run $current_time