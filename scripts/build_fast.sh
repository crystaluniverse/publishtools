rm -f /usr/local/bin/publishtools

set -ex
pushd ../publishtools "$@" > /dev/null
sudo rm -f /usr/local/bin/publishtools

# v -gc boehm -prod publishtools.v
if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew install libgc
    # v -d static_boehm  -gc boehm -prod publishtools.v
    v -d net_blocking_sockets -d static_boehm  -gc boehm publishtools.v
    
else
    v -d static_boehm  -gc boehm -cflags -static -prod publishtools.v
fi


# v -d static_boehm  -gc boehm publishtools.v

#v  publishtools.v

sudo cp publishtools /usr/local/bin/publishtools 
   
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ `uname -m` == 'arm64' ]]; then
        cp publishtools ~/Downloads/publishtools_osx_arm
    else
        cp publishtools ~/Downloads/publishtools_osx
    fi
fi

rm publishtools

popd "$@" > /dev/null

echo " - publishtools build ok"