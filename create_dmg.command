#!/bin/sh
# Should build a pretty DMG for installation of Network Monitor.
# Needs a mac os x box.
# Configure: BUILD_DIR and BUILD_PRODUCTS_DIR if not using xcode with
# builds relative to project to build the project.
# This file is a modification from the example provided in
# http://asmaloney.com/2013/07/howto/packaging-a-mac-os-x-application-using-a-dmg/

set -ex
APP_NAME="Network Monitor"
VERSION=`grep -A1 CFBundleShortVersionString Network\ Monitor/Info.plist | tail -1 | sed -e 's/<string>\([^<]*\)<\/string>/\1/g' | awk '{print $1}'`
BACKGROUND_IMG_NAME="Background.png"

CURRENT_DIR=${0%/*}

BUILD_DIR="${CURRENT_DIR}/Build"
CONFIGURATION="Release"
BUILT_PRODUCTS_DIR="${BUILD_DIR}/Products/${CONFIGURATION}"
INTERMEDIATES_DIR="${BUILD_DIR}/Intermediates"
APP_FOLDER="${BUILT_PRODUCTS_DIR}/${APP_NAME}.app"
TEMP_FILES_DIR="${BUILD_DIR}/tmp"
STAGING_DIR="${TEMP_FILES_DIR}/disk"

APP_EXE="${APP_NAME}.app/Contents/MacOS/${APP_NAME}"
VOL_NAME="${APP_NAME} ${VERSION}"

DMG_DIR="${BUILD_DIR}/dmg"
DMG="${DMG_DIR}/${APP_NAME}.dmg"
DMG_TMP="${DMG_DIR}/${VOL_NAME}-temp.dmg"
DMG_FINAL="${DMG_DIR}/${VOL_NAME}.dmg"
DMG_BACKGROUND_IMG="${CURRENT_DIR}/${BACKGROUND_IMG_NAME}"

# Ensure we're on the right folder
if [ -d "$CURRENT_DIR" ]; then
  cd "$CURRENT_DIR"
fi

# Build executable
rm -Rf "${BUILT_PRODUCTS_DIR}"
rm -Rf "${INTERMEDIATES_DIR}"
mkdir -p "${BUILT_PRODUCTS_DIR}"
BUILT_PRODUCTS_DIR="${BUILT_PRODUCTS_DIR}" xcodebuild -target "${APP_NAME}" -scheme 'Network Monitor' -configuration "#{CONFIGURATION}" build

# Ensure temporary folders exist
mkdir -p "${DMG_DIR}"

# Check the background image DPI and convert it if it isn't 72x72
_BACKGROUND_IMAGE_DPI_H=`sips -g dpiHeight ${DMG_BACKGROUND_IMG} | grep -Eo '[0-9]+\.[0-9]+'`
_BACKGROUND_IMAGE_DPI_W=`sips -g dpiWidth ${DMG_BACKGROUND_IMG} | grep -Eo '[0-9]+\.[0-9]+'`

if [ $(echo " $_BACKGROUND_IMAGE_DPI_H != 72.0 " | bc) -eq 1 -o $(echo " $_BACKGROUND_IMAGE_DPI_W != 72.0 " | bc) -eq 1 ]; then
echo "WARNING: The background image's DPI is not 72.  This will result in distorted backgrounds on Mac OS X 10.7+."
echo "         I will convert it to 72 DPI for you."

_DMG_BACKGROUND_TMP="${TEMP_FILES_DIR}/${BACKGROUND_IMG_NAME%.*}"_dpifix."${BACKGROUND_IMG_NAME##*.}"

sips -s dpiWidth 72 -s dpiHeight 72 ${DMG_BACKGROUND_IMG} --out ${_DMG_BACKGROUND_TMP}

DMG_BACKGROUND_IMG="${_DMG_BACKGROUND_TMP}"
fi

# clear out any old data
rm -rf "${STAGING_DIR}" "${DMG_TMP}" "${DMG_FINAL}"
mkdir -p "${STAGING_DIR}"

# copy over the stuff we want in the final disk image to our staging dir
cp -rpf "${APP_FOLDER}" "${STAGING_DIR}/${APP_NAME}.app"
cp -pf "${CURRENT_DIR}/LICENSE.txt" "${STAGING_DIR}/"
cp -pf "${CURRENT_DIR}/README.txt" "${STAGING_DIR}/"

pushd "${STAGING_DIR}"

# strip the executable
echo "Stripping ${APP_EXE}..."
strip -u -r "${APP_EXE}"

# compress the executable if we have upx in PATH
#  UPX: http://upx.sourceforge.net/
if hash upx 2>/dev/null; then
echo "Compressing (UPX) ${APP_EXE}..."
upx -9 "${APP_EXE}"
fi

# ... perform any other stripping/compressing of libs and executables

popd

# figure out how big our DMG needs to be in kilobytes
SIZE=`du -sk "${STAGING_DIR}/" | awk '{print $1}'`
SIZE=`echo "${SIZE} + 700.0" | bc | awk '{print int($1+0.5)}'`

if [ $? -ne 0 ]; then
echo "Error: Cannot compute size of staging dir"
exit
fi

# create the temp DMG file
hdiutil create -srcfolder "${STAGING_DIR}" -volname "${VOL_NAME}" -fs HFS+ \
-fsargs "-c c=64,a=16,e=16" -format UDRW -size "${SIZE}k" "${DMG_TMP}"

echo "Created DMG: ${DMG_TMP}"

# mount it and save the device
DEVICE=$(hdiutil attach -readwrite -noverify "${DMG_TMP}" | \
egrep '^/dev/' | sed 1q | awk '{print $1}')

sleep 2

# add a link to the Applications dir
echo "Add link to /Applications"
pushd /Volumes/"${VOL_NAME}"
ln -s /Applications
popd

# add a background image
mkdir /Volumes/"${VOL_NAME}"/.background
cp "${DMG_BACKGROUND_IMG}" /Volumes/"${VOL_NAME}"/.background/"${BACKGROUND_IMG_NAME}"

# tell the Finder to resize the window, set the background,
#  change the icon size, place the icons in the right position, etc.
echo '
tell application "Finder"
    tell disk "'${VOL_NAME}'"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {400, 100, 920, 440}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 72
        set background picture of viewOptions to file ".background:'${BACKGROUND_IMG_NAME}'"
        set position of item "'${APP_NAME}'.app" of container window to {80, 248}
        set position of item "Applications" of container window to {440, 248}
        set position of item "README.txt" of container window to {80, 100}
        set position of item "LICENSE.txt" of container window to {180, 100}
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
' | osascript

sync

# unmount it
hdiutil detach "${DEVICE}"

# now make the final image a compressed disk image
echo "Creating compressed image"
hdiutil convert "${DMG_TMP}" -format UDZO -imagekey zlib-level=9 -o "${DMG_FINAL}"

# clean up
rm -rf "${DMG_TMP}"
rm -rf "${STAGING_DIR}"

echo 'Done.'

exit