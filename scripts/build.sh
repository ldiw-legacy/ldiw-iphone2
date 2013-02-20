#!/bin/sh
function failed() {
  echo "Failed: $@" >&2
  exit 1
}

set -ex

export OUTPUT=$WORKSPACE/release
rm -rf $OUTPUT
mkdir -p $OUTPUT
PROFILE_HOME=~/Library/MobileDevice/Provisioning\ Profiles/

KEYCHAIN=~/Library/Keychains/login.keychain

. "$WORKSPACE/scripts/build.config"


[ -d "$PROFILE_HOME" ] || mkdir -p "$PROFILE_HOME"
security unlock -p $PASSWORD

cd $WORKSPACE

agvtool new-version -all $BUILD_NUMBER

for sdk in $SDKS; do
  for config in $CONFIGURATIONS; do
    provision=$(eval echo \$`echo Provision$config`)
cert="$WORKSPACE/scripts/$provision"
    
archive="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.ipa";
dSymArchive="$OUTPUT/$JOB_NAME-$BUILD_NUMBER-$config.dSYM.zip";
    [ -f "$cert" ] && cp "$cert" "$PROFILE_HOME"
    cd $WORKSPACE

    echo "build commandLine xcodebuild -configuration $config -sdk $sdk clean"
    xcodebuild -configuration $config -sdk $sdk clean;
    xcodebuild -configuration $config -sdk $sdk || failed build;
    cd build/$config-iphoneos;
    rm -fr Payload
    mkdir Payload
    cp -r *.app* Payload
    if [ $config == "Release" ]; then
      zip -r -T -y "$archive" Payload || failed zip
      zip -j -T "$archive" "$WORKSPACE/iphone/icon.png" || failed icon
      zip -r "$dSymArchive" *.dSYM
    else
      zip -r -T -y "$archive" *.app || failed zip
      zip -j -T "$archive" "$cert" || failed cert 
      zip -r "$dSymArchive" *.dSYM
    fi
  done
done
