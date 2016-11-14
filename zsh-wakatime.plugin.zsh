# wakatime for zsh

# hook function to send wakatime a tick
send_wakatime_heartbeat() {
    entity=$(waka_filename);
    project=$(waka_project);
    if [ "$entity" ]; then
        if [ -z "$project" ]; then
            project="Terminal"
        fi
        (wakatime --write --plugin "zsh-wakatime/0.0.1" --entity-type app --project "$project" --entity "$entity"> /dev/null 2>&1 &)
    fi
}

# generate text to report as "filename" to the wakatime API
waka_filename() {
    if [ "x$WAKATIME_USE_DIRNAME" = "xtrue" ]; then
        # just use the current working directory
        echo "$PWD"
    else
        # only command without arguments to avoid senstive information
        echo "$history[$((HISTCMD-1))]" | cut -d ' ' -f1
    fi
}

waka_project() {
    if [ ! -z $VIRTUAL_ENV ] && [ ! -z $VIRTUALENVWRAPPER_PROJECT_FILENAME ]; then
        basename $(cat $VIRTUAL_ENV/$VIRTUALENVWRAPPER_PROJECT_FILENAME)
    fi
}

precmd_functions+=(send_wakatime_heartbeat)
