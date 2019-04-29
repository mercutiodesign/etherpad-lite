#!/bin/bash
if ! { [[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] ||
       [[ -n $BASH_VERSION && $0 != "$BASH_SOURCE" ]] ; } ; then
    echo "this script needs to be sourced. run 'source scripts/activate-remote.sh'";
    exit;
fi

deactivate_docker () {
    if [ -n "${_OLD_DOCKER_PS1+_}" ] ; then
        export PS1="$_OLD_DOCKER_PS1"
        unset _OLD_DOCKER_PS1
    fi

    if [ -n "$SSH_TUNNEL_PID" ] ; then
        kill "$SSH_TUNNEL_PID" > /dev/null 2>&1
        [ -z "$SOCKET_FILE" ] || rm -f "$SOCKET_FILE" >/dev/null 2>&1
    fi
    unset SSH_TUNNEL_PID
    unset SOCKET_FILE
    unset DOCKER_HOST
}

deactivate_docker

SOCKET_FILE="$(pwd)/docker.sock"
if ! [ -e "$SOCKET_FILE" ] ; then
    env ssh -nNT -L "$SOCKET_FILE:/var/run/docker.sock" mono-aws &
    SSH_TUNNEL_PID=$!
fi
export DOCKER_HOST=unix://$SOCKET_FILE

_OLD_DOCKER_PS1="$PS1"
export PS1="(aws-docker) $PS1"
