#!/bin/sh

#-------------------------------------------------------------------------------
# Build definition
#-------------------------------------------------------------------------------
#
# Application Bundle Indentifier (see your applications's Info.plist)
APP_BUNDLE_IDENTIFIER="com.mirego.killswitch"

# Overwrite bundle identifier in Info.pllist file.
# (default: NO)
#OPTION_FORCE_APP_BUNDLE_IDENTIFIER="YES"

# The name the application will have. It's your chance to add
# information to the name. For dev builds it's suggested to use
# Like "AppName [dev]"
# (default: use value from plist)
APP_BUNDLE_NAME="KillSwitch"

# Specify the PRODUCT_NAME (use when Xcode generates the binary)
# (default: $BUILD_SCHEME)
APP_PRODUCT_NAME="KillSwitch"

# Put the location of your project's Info.plist file.
APP_INFO_PLIST="MCKillSwitchExample/MCKillSwitchExample/Info.plist"

# The name and relative path to the workspace file. Should be in the
# root of your repo so only the file name will do.
BUILD_WORKSPACE="MCKillSwitchExample/MCKillSwitchExample.xcworkspace"

# The name of the xcodeproj file (with the extension).
# By default it expects the same name as the BUILD_WORKSPACE
# (default: ${BUILD_WORKSPACE%.*}.xcodeproj)
BUILD_PROJECT_FILE="MCKillSwitchExample/MCKillSwitchExample.xcodeproj"

# The name of the build scheme that's marked as shared in XCode and to
# use to build the application.
BUILD_SCHEME="MCKillSwitchExample"

# You can choose which build configuration to use. (Release, Debug,
# etc.)
# (default:"Release")
BUILD_CONFIGURATION="Release"

# Compress the xcarchive folder in a .tar.gz file
# (default:"YES")
BUILD_MAKE_ARCHIVE="NO"

# Generate the .dSYM.zip from the xcarchive folder.
# (default:"YES")
BUILD_ARCHIVE_DSYM="NO"

#
# (default:"YES")
#BUILD_CLEAN_FILES="YES"

#-------------------------------------------------------------------------------
# Build number management
#-------------------------------------------------------------------------------
#
# The script will increment the build number after a succesfull build
# (default:"NO")
#BUILD_UPDATE_VERSION_NUMBER="YES"

# Force the MAJOR version number (MAJOR.minor.revision.build)
# (default:"")
#APP_VERSION_MAJOR_NUMBER="0"

# Force the MINOR version number (major.MINOR.revision.build)
# (default:"")
#APP_VERSION_MINOR_NUMBER="1"

# Select format for version number it's either long or short.
# long format  : major.minor.revision.build (e.g. 1.1.3.2412)
# short format : major.minor.revision (e.g. 1.0.2412)
# (default:"YES")
#APP_VERSION_LONG_FORMAT="YES"

# Settings bundle root.plist
#APP_SETTINGS_PLIST="MaVie/Resources/Settings.bundle/Root.plist"

# The plist path that will be used by the plistbuddy command line tool
# to update the version number in the Settings.bundle
#APP_SETTINGS_VERSION_PATH="PreferenceSpecifiers:0:DefaultValue"

#-------------------------------------------------------------------------------
# Compiler Flags
#-------------------------------------------------------------------------------
#
# Allow script to pass additional CFLAGS to build. It's very useful to have
# build specific defines
# (default:"")
#BUILD_EXTRA_CFLAGS="-DPRODUCTION"

# Allow script to define additional environment variables accessible from the
# build environment during the Xcode build.
#BUILD_EXTRA_XCODE_ENV="DEFAULT_ENVIRONMENT=qa"

#-------------------------------------------------------------------------------
# Cocoapods
#-------------------------------------------------------------------------------
#
# Force build script to remove the "Pods" folder from the project
# before running pod install
# (default: "NO")
BUILD_REMOVE_PODS_FOLDER="YES"

#-------------------------------------------------------------------------------
# Build scripts hooks
#-------------------------------------------------------------------------------
#
# Run pre-build script before xcodebuild clean (then archive)
# (default: "")
#BUILD_PREBUILD_SCRIPT="Accent/accent-sync.sh"

# Run post-build script after .ipa generation
# (default: "")
#BUILD_POSTBUILD_SCRIPT="Scripts/do-something-fun.sh"

#-------------------------------------------------------------------------------
# Provisioning profile and key
#-------------------------------------------------------------------------------
#
# Uncomment the following lines if you want to use a different
# provisioning profile than Mirego's Team Provisioning Profile.
# The directory containing the provisioning profile relative to your
# repository root.
#PROVISIONING_DIR="Releases"

# The name of the provisioning profile file in your repository. Having
# the provisioning profile in your repo allows you to update it easily.
#PROVISIONING_FILE="com.mirego.ent.familiprix.mavie.qa_Enterprise.mobileprovision"

# The name of the private key to use to sign the build.
#PROVISIONING_NAME="iPhone Distribution: Mirego"

# Provisioning certificate straight from your build. Provide the p12 and the
# password (see below) of the p12 file.
# It must be located in PROVISIONING_DIR.
# (default: "")
#PROVISIONING_CERTIFICATE_FILE="SuperCompany.p12"
#
# The password for the provisioning certificate defined in
# PROVISIONING_CERTIFICATE_FILE
# (default: "")
#PROVISIONING_CERTIFICATE_PASSWORD="SuperPassword:1234567"

#-------------------------------------------------------------------------------
# Hockey App
#-------------------------------------------------------------------------------
#
# Upload the build to HockeyApp
# (default:"NO")
HOCKEYAPP_UPLOAD="YES"

# Specify HockeyApp App ID for uploads
# (default:"")
HOCKEYAPP_APP_ID="723671c62caeb6eaf449a8c4978e5cd8"

#-------------------------------------------------------------------------------
# Git
#-------------------------------------------------------------------------------
#
# When your build completes Jenkins can push the changes to your git
# repo. This is great if you're doing automatic build numbers and
# Continuous Integration (CI).
# (default:"NO")
#PUSH_CHANGES="YES"

# When your build completes Jenkins can tag the current git version
# This is great for client builds. The tag will follow the following
# format: $TAG_PREFIX/$VERSION
# (default:"NO")
#TAG_VERSION="YES"

# Prefix used when tagging.
# (default:"${BUILD_CONFIGURATION}")
#TAG_PREFIX="QA"

#-------------------------------------------------------------------------------
# Unit Testing
#-------------------------------------------------------------------------------
#
# Enable running unit tests after build. At the moment it will not prevent
# Testflight upload or push to github. It's the very last step in the build
# process. Don't forget to set UNIT_TEST_BUILD_SCHEME if you set it to "YES"
# (default:NO)
#UNIT_TEST="YES"

# Ignore all build steps but unit tests. Skips clean, archive, change log
# generation, testflight upload, hockeyapp upload, git tag and push changes.
# (default:NO)
#UNIT_TEST_ONLY="YES"

#-------------------------------------------------------------------------------
# Script Behaviours
#-------------------------------------------------------------------------------
#
# Should more detailed be shown in the script output
# (default:NO)
VERBOSE="YES"

#-------------------------------------------------------------------------------
# Xcode selection
#-------------------------------------------------------------------------------
#
# You can choose which version of Xcode to use to build. Only useful if
# you need an old Xcode of a DP version of Xcode. Most of the time you
# don't need to change this.
# (default:"/Applications/Xcode.app/Contents/Developer")
#XCODE_PATH="/Applications/Xcode5-DP6.app/Contents/Developer"
