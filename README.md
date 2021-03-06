# Nemo
[![Build Status](https://travis-ci.org/sinoru/Nemo.svg?branch=master)](https://travis-ci.org/sinoru/Nemo) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Nemo is a photos menu framework for iOS

<img src="Example~iPhone.gif" alt="Example" width="39%"/>

## Installation
### [CocoaPods](https://cocoapods.org)
You can install Nemo with CocoaPods, simply add this line to your Podfile:

```ruby
pod 'Nemo'
```

### [Carthage](https://github.com/Carthage/Carthage)
You can install Nemo with Carthage, simply add this line to your Cartfile:

```
github "sinoru/Nemo"
```

### Manually
1. Drag `Nemo.xcodeproj` file into you project
2. Add `Nemo.framework` into Project Setting's General->Embedded Binaries

## Usage
### Swift
* Import Nemo framework by:

```swift
import Nemo
```
* Init PhotosMenuController by:

```swfit
let controller = PhotosMenuController()
```
* Present it by UIViewController's present view controller method:

```swift
self.presentViewController(controller, animated: true, completion: nil)
```
### Objective-C
* Import Nemo framework by:

```objective-c
@import Nemo;
// or
#import <Nemo/Nemo.h>
```
* Init PhotosMenuController by:

```objective-c
NMPhotosMenuController *controller = [[NMPhotosMenuController alloc] init];
```
* Present it by UIViewController's present view controller method:

```swift
[self presentViewController:controller animated:YES completion:nil];
```

Or you can simply check NemoExample on `Nemo.xcodeproj`

## License
Read LICENSE for more information.
