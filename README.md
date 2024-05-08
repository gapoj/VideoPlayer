# VideoPlayer
A SwiftUI video player with gyroscope and other little things made for a challenge

## Problem Statement


The challenge is to develop an interactive video player with the following features:

1. Video Playback: The player should load and play a specified video file upon launch.
2.Location-Based Reset: If the user's location changes by more than 10 meters from the previous location, the video should reset and replay from the beginning.
3.Shake Detection: A shake of the device should trigger the video to pause.
4.Gyroscope Control: Rotation along the z-axis (tilting the device sideways) should control the current time where the video is playing. Rotation along the x-axis (tilting the device up or down) should control the volume of the sound.

## Technologies Used

* SwiftUI
* Combine
* Core Motion
* Core Location
* AVKit
* iOS SDK version 17.4

## Installation

* No special configuration is needed because the app does not rely on third-party libraries.
* To fully harness its capabilities, you must deploy it onto a physical device


## Approach

Implementing the video player challenge with MVVM separates data (Model), UI (View), and logic (ViewModel), promoting cleaner, more manageable code.


## Author

**Guillermo Apoj**

