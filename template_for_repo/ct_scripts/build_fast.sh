set -ex

if [ -d "/workspace" ] 
then
    if ! [ -d "/workspace/publishtools" ] 
    then
        pushd /workspace "$@" > /dev/null
        git clone https://github.com/crystaluniverse/publishtools
        popd "$@" > /dev/null
        pushd /workspace/publishtools/scripts_workspace "$@" > /dev/null
        bash install.sh
        popd "$@" > /dev/null
    fi
    #build the publishtools
    pushd /workspace/publishtools/scripts_workspace "$@" > /dev/null
    bash build_fast.sh
    popd     "$@" > /dev/null
else
    if ! [ -d ~/code/publishtools ] 
    then
        pushd ~/code
        git clone https://github.com/crystaluniverse/publishtools
        popd "$@" > /dev/null
        # pushd ~/code/publishtools/scripts
        # bash build_fast.sh
        # popd "$@" > /dev/null
    fi
    #build the publishtools
    pushd ~/code/publishtools/scripts "$@" > /dev/null
    bash build_fast.sh
    popd  "$@" > /dev/null 
fi
publishtools develop


