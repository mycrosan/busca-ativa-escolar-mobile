#!/bin/sh

echo "[ LQDI-BUILDBOT ] Removing previous APKs...";
rm -f ./release/android-release-ready.apk
rm -f ./release/android-release-unaligned.apk
rm -f ./release/android-release-pending.apk
rm -f ./release/android-release-pending.apk.sig

echo "[ LQDI-BUILDBOT ] Copying APK...";
cp ./platforms/android/build/outputs/apk/release/android-release-unsigned.apk ./release/android-release-unaligned.apk

echo "[ LQDI-BUILDBOT ] Aligning APK ZIP...";
zipalign -v 4 ./release/android-release-unaligned.apk ./release/android-release-pending.apk

echo "[ LQDI-BUILDBOT ] Signing APK...";
apksigner sign --verbose --ks ~/Dropbox/SSH/google_play_keystore.jks --ks-key-alias busca-ativa-escolar_2017 --ks-pass "pass::%_x3^1%._Q49%1m" --key-pass "pass:#eYYG%+ISH5w" --out ./release/android-release-ready.apk ./release/android-release-pending.apk
