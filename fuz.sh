#!/usr/bin/env bash
set -e

main() {
    if [ -z $1 ]; then
        echo select_file
        file_to_edit=`select_file ""`
    else
        echo select file with grep $@
        file_to_edit=`select_file_grep $@`
    fi

    if [ -n "$file_to_edit" ] ; then
        vim "$file_to_edit"
    fi
}

select_file_grep() {
    grep --line-buffered -ril "$@" * | fzf_preview
}

select_file() {
    fzf_preview $1
}

fzf_preview() {
    given_file="$1"
    fzf --preview="cat {}" --preview-window=right:70%:wrap --query="$given_file"
}

main $@

