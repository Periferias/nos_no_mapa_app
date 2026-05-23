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

PLUGIN_COUNT=$(cat build.yaml| shyaml get-length qfield.bundled_plugins 2>/dev/null || echo 0)
if [[ ${PLUGIN_COUNT} -gt 0 ]]; then
  PLUGINS_STAGING="${DIR}/../bundled-plugins"
  rm -rf "${PLUGINS_STAGING}"
  mkdir -p "${PLUGINS_STAGING}"

  for ((i=0; i<PLUGIN_COUNT; i++)); do
    PLUGIN_DIR=$(cat build.yaml| shyaml get-value qfield.bundled_plugins.${i}.dir)
    PLUGIN_URL=$(cat build.yaml| shyaml get-value qfield.bundled_plugins.${i}.url)
    PLUGIN_SHA512=$(cat build.yaml| shyaml get-value qfield.bundled_plugins.${i}.sha512)

    echo "Fetching bundled plugin: ${PLUGIN_DIR}"
    PLUGIN_ZIP="${PLUGINS_STAGING}/${PLUGIN_DIR}.zip"
    curl -fSL "${PLUGIN_URL}" -o "${PLUGIN_ZIP}"

    echo "${PLUGIN_SHA512}  ${PLUGIN_ZIP}" | shasum -a 512 -c -

    mkdir -p "${PLUGINS_STAGING}/${PLUGIN_DIR}"
    unzip -q "${PLUGIN_ZIP}" -d "${PLUGINS_STAGING}/${PLUGIN_DIR}"
    rm "${PLUGIN_ZIP}"
  done

  export APP_BUNDLED_PLUGINS="${PLUGINS_STAGING}"
fi

export APP_NAME
export APP_PACKAGE_NAME
export APP_ICON
export APP_ICON_PATH="${DIR}/../assets/icons"
export APP_THEME_PATH="${DIR}/../assets/theme/theme.json"
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
echo "APP_ICON_PATH: ${APP_ICON_PATH}"
echo "APP_VERSION: ${APP_VERSION}"
echo "APP_VERSION_STR: ${APP_VERSION_STR}"
echo "ANDROID_NDK_PLATFORM: ${ANDROID_NDK_PLATFORM}"
echo "APK_VERSION_CODE: ${APK_VERSION_CODE}"
echo "APP_BUNDLED_PLUGINS: ${APP_BUNDLED_PLUGINS}"

pushd ${DIR}/../QField
git checkout ${QFIELD_VERSION}
popd