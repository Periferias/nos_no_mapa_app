#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../QField/scripts/version_number.sh

echo "Building with APK_VERSION_CODE ${APK_VERSION_CODE}"

APP_VERSION=$(cat build.yaml| shyaml get-value qfield.version)
QFIELD_VERSION=$(cat build.yaml| shyaml get-value qfield.qfield_version)

APP_NAME=$(cat build.yaml| shyaml get-value qfield.app_name)
APP_PACKAGE_NAME=$(cat build.yaml| shyaml get-value qfield.app_package_suffix)
APP_ICON=$(cat build.yaml| shyaml get-value qfield.app_icon)
APP_VERSION_NAME=$(cat ${DIR}/../QField/RELEASE_NAME)
APP_VERSION_STR="$(app_version_str ${TAG}) - ${APP_VERSION_NAME}"
APK_VERSION_CODE=$(echo "$(expr ${GITHUB_RUN_NUMBER} \* 4 + $(arch_to_build_number "${TRIPLET}") + $(cat build.yaml| shyaml get-value qfield.version_offset))")

export APP_NAME
export APP_PACKAGE_NAME
export APP_ICON
export APP_VERSION
export APP_VERSION_STR
export APK_VERSION_CODE
export VERSION_CODE_CHECK=102000000

echo "Version offset: $(cat build.yaml| shyaml get-value qfield.version_offset)"
echo "Run number: ${GITHUB_RUN_NUMBER}"
echo "Arch number: ${TRIPLET_NUMBER}"
echo "APP_NAME: ${APP_NAME}"
echo "APP_PACKAGE_NAME: ${APP_PACKAGE_NAME}"
echo "APP_ICON: ${APP_ICON}"
echo "APP_VERSION: ${APP_VERSION}"
echo "APP_VERSION_STR: ${APP_VERSION_STR}"
echo "ANDROID_NDK_PLATFORM: ${ANDROID_NDK_PLATFORM}"
echo "APK_VERSION_CODE: ${APK_VERSION_CODE}"

pushd ${DIR}/../QField
git checkout ${QFIELD_VERSION}
echo "Copying custom icons into QField source tree..."
cp ${DIR}/../assets/icons/${APP_ICON}.svg images/icons/${APP_ICON}.svg
cp ${DIR}/../assets/icons/android/drawable/${APP_ICON}_vector.xml platform/android/res/drawable/${APP_ICON}_vector.xml
for DENSITY in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  cp ${DIR}/../assets/icons/android/drawable-${DENSITY}/${APP_ICON}.png platform/android/res/drawable-${DENSITY}/${APP_ICON}.png
done

popd