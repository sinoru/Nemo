# Nemo [![License](https://img.shields.io/badge/license-BSD-blue.svg)](https://raw.githubusercontent.com/sinoru/Nemo/master/LICENSE) [![Build Status](https://travis-ci.org/sinoru/Nemo.svg)](https://travis-ci.org/sinoru/Nemo)
Nemo is a photos picker menu framework for iOS

## Installation
### Carthage [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
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
### Obj-C
* Import Nemo framework by:

```objective-c
@import Nemo;
// or
#import <Nemo/Nemo.h>
```
* Init PhotosMenuController by:

```objective-c
PhotosMenuController *controller = [[PhotosMenuController alloc] init];
```
* Present it by UIViewController's present view controller method:

```swift
[self presentViewController:controller animated:YES completion:nil];
```

Or you can simply check NemoExample on `Nemo.xcodeproj`

## License
Nemo is distributed under the BSD 3-clause "New" or "Revised" License (see LICENSE).