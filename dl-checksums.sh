#!/usr/bin/env sh
DIR=~/Downloads
MIRROR=https://github.com/weaveworks/footloose/releases/download

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local platform="${os}-${arch}"
    local file="footloose-${ver}-${platform}"
    local url=$MIRROR/$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="checksums.txt"
    local url=$MIRROR/$ver/$checksums
    local lchecksums="$DIR/footloose-$ver-$checksums"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin i386
    dl $ver $lchecksums darwin x86_64
    dl $ver $lchecksums linux i386
    dl $ver $lchecksums linux x86_64
}

dl_ver 0.5.0
dl_ver 0.6.0
dl_ver 0.6.1
dl_ver ${1:-0.6.2}
