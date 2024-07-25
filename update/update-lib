#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

help() {
    cat <<EOF
Usage: $0 [-y]

Updating lib using the package manager

Options:

-y  Automatic yes to prompts
-h  Help text

EOF
}

color_print() {
    local color=$1
    local msg=$2
    echo -e "$color$msg$NC"
}


yes=

# Processing options
while getopts ":y" OPTION; do
    case $OPTION in
    y)
        yes="-$OPTION"
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

color_print $GREEN "Обновление репозиториев"
sudo apt update

color_print $GREEN "Обновление пакетов"
sudo apt upgrade $yes

color_print $GREEN "Удаление не используемых пакетов"
sudo apt autoremove $yes

color_print $GREEN "Удаление старых загруженных архивных файлов"
sudo apt autoclean $yes

color_print $GREEN "Удаление загруженных архивных файлов"
sudo apt clean

color_print $GREEN "Пакеты обновлены и удалены не используемые"
