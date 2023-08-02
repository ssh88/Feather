#!/bin/bash

echo Creating iPhoneTestDevice Simulator
xcrun simctl create iPhoneTestDevice com.apple.CoreSimulator.SimDeviceType.iPhone-14
xcrun simctl boot iPhoneTestDevice

echo Launching Simulator
open -a Simulator.app

PHONE_ID="$(xcrun simctl getenv iPhoneTestDevice SIMULATOR_UDID)"
echo Device ID:
echo $PHONE_ID

echo Listing Devices:
xcrun simctl list devices


echo Running UI Tests
xcodebuild \
        -project Demo.xcodeproj \
        -scheme Demo \
        -destination 'platform=iOS Simulator,id='$PHONE_ID \
        clean test

echo Deleting iPhoneTestDevice Simulator
xcrun simctl delete $PHONE_ID
