#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

help() {
    cat <<EOF
Usage: $0 [-a]

Clearing the docker cache

Options:

-a  Remove all cache
-h  Help text

EOF
}

color_print() {
    local color=$1
    local msg=$2
    echo -e "$color$msg$NC"
}

remove_all() {
    # Delete all containers
    color_print $YELLOW "Deleting all containers"
    cont=$(docker ps -aq)
    docker stop $cont &>/dev/null
    docker rm $cont &>/dev/null

    # Delete all images
    color_print $YELLOW "Deleting all images"
    image=$(docker images -aq)
    docker rmi $image &>/dev/null

    # Delete volume
    color_print $YELLOW "Delete all volume"
    docker volume prune -af >/dev/null

    # Delete the build cache
    color_print $YELLOW "Deleting all build caches"
    docker buildx prune -af >/dev/null

    # Delete the network
    color_print $YELLOW "Deleting all networks"
    docker network prune -f >/dev/null

    return 0
}

remove_unused() {
    # Remove unused containers
    color_print $YELLOW "Deleting unused containers"
    docker container prune -f >/dev/null

    # Delete images
    color_print $YELLOW "Deleting unused images"
    docker image prune -f >/dev/null

    # Delete anonymous volume
    color_print $YELLOW "Delete anonymous volume"
    docker volume prune -f >/dev/null

    # Delete the build cache
    color_print $YELLOW "Deleting build caches"
    docker buildx prune -f >/dev/null

    # Delete the network
    color_print $YELLOW "Deleting unused networks"
    docker network prune -f >/dev/null

    return 0
}

# Main script
all=0

# Processing options
while getopts ":ah" OPTION; do
    case $OPTION in
    a)
        all=1
        shift
        ;;
    h)
        help
        exit 0
        ;;
    \?)
        echo "Invalid option: -$OPTARG"
        help >&2
        exit 1
        ;;
    *) shift ;;
    esac
done

color_print $RED "Size before cleaning"
docker system df

if [ $all -eq 1 ]; then
    remove_all
else
    remove_unused
fi

color_print $GREEN "Size after cleaning"
docker system df
