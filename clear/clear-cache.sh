#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

help() {
    cat <<EOF
Usage: $0 [-d]

Clearing the memory cache

Options:

-d  The type of cached data to clear

    * 1 – Clears only the page cache. Default
    * 2 – Clears dentries and inodes.
    * 3 – Clears page cache, dentries, and inodes.

-h  Help text

EOF
}

color_print() {
    local color=$1
    local msg=$2
    echo -e "$color$msg$NC"
}

is_in_range() {
    local number=$1

    if [[ $number -ge 1 && $number -le 3 ]]; then
        return 0
    else
        return 1
    fi
}

drop=1

# Обработка опций
while getopts ":d:1" OPTION; do
    case $OPTION in
    d)
        drop=$OPTARG
        if ! is_in_range $drop; then
            color_print $RED "The cache for deleting a numeric type must be equal 1, 2, 3"
            exit 0
        fi
        shift
        ;;
    h)
        help
        exit 0
        ;;
    \?)
        color_print $RED "Invalid option: -$OPTARG"
        help >&2
        exit 1
        ;;
    *) shift ;;
    esac
done

color_print $YELLOW "Сlearing the cache"
sync
echo $drop >/proc/sys/vm/drop_caches
color_print $YELLOW "Сlearing the cache is finished"
