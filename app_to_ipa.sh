# 将 .app 文件转换为 .ipa 文件
# 执行下述命令给脚本点权限 chmod +x app_to_ipa.sh
# ./app_to_ipa.sh xxx.app

#!/bin/bash

# Ensure a file was dragged onto the script
if [ -z "$1" ]
then
    echo "No file provided. Please drag and drop the .app file onto this script."
    exit 1
fi

# Extract the app name from the file path
appName=$(basename "$1" .app)

# Remove any existing directory with the same name
rm -rf "$appName"

# Create necessary directories
mkdir "$appName"
mkdir "$appName/Payload"

# Copy the .app file into the Payload directory
cp -r "$1" "$appName/Payload/$appName.app"

# If there's an icon file, copy it over
if [ -f Icon.png ]
then
    cp Icon.png "$appName/iTunesArtwork"
fi

# Change to the app directory
cd "$appName"

# Create the .ipa file
zip -r "$appName.ipa" Payload iTunesArtwork

# Print the absolute path of the .ipa file
echo "The .ipa file has been created at: $(pwd)/$appName.ipa"

# Exit successfully
exit 0
