#!/bin/sh

echo "[ LQDI-BUILDBOT ] Scaffolding environment...";
mv src/env_api_root.ts src/env_api_root.bck.ts
cp src/env_api_root_release.ts src/env_api_root.ts

echo "[ LQDI-BUILDBOT ] Cleaning Cordova builds...";
cordova clean

echo "[ LQDI-BUILDBOT ] Building IOS...";
rm ./release/ios-release-ready.ipa
ionic build ios --device --release
cp ./platforms/ios/build/device/Busca\ Ativa\ Escolar.ipa ./release/ios-release-ready.ipa

echo "[ LQDI-BUILDBOT ] Building ANDROID...";
rm ./release/android-release-pending.apk
rm ./release/android-release-ready.apk
ionic build android --device --release

echo "[ LQDI-BUILDBOT ] Signing APK for ANDROID...";
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

echo "iOS Package generation done! Uploading iOS IPA to Itunes Connect..."
altool --upload-app -f ./platforms/ios/build/device/Busca\ Ativa\ Escolar.ipa -u buildbot@lqdi.net -p p8HDjI4jTWw5

echo "[ LQDI-BUILDBOT ] De-scaffolding environment...";
rm src/env_api_root.ts
mv src/env_api_root.bck.ts src/env_api_root.ts

echo "[ LQDI-BUILDBOT ] Done! Now you must upload the APK to Play Store and update the current used build for TestFlight/GA in Itunes Connect."
