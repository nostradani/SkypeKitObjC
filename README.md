# SkypeKit.framework

An Objective C wrapper for the official SkypeKit SDK.
It enables development of native Objective C applications without the need to deal with C++ specific code.
The current version of the SkypeKit framework also takes care of running the SkypeKit runtime, thereby only providing a library point of view in order to develop custom Skype applications.

## Dependencies

* SkypeKit SDK 4.x.x

## Installation

First of all you have to compile the SkypeKit SDK. This description assumes that the C++ wrapper library was built to the standard location within the build directory.

The project itself comes fully configured and build ready. You have only to point it to the SkypeKit SDK.
Since the project does not only use the headers, but also copies the runtime you have to do two adjustments:

* Set the custom build variable SKYPEKIT_SDK to the location of the SDK (Can be found at the project build settings)
* Set the correct path for SkypeKitSDK group folder also to the location of the SDK.

## Usage

The Objective C wrapper tries to stick to the original C++ wrapper library. 
All class names and property names should be at least very similar (Actually they should be the same except for case sensitivity).
Currently this framework is still in development, so not all classes or properties are already present.
The basic design however should be quite straight forward, so you should be able to extend the framework for your needs.

## Development

Soon you will find developing examples at a Wiki, that will show you how you can extend this framework.

## Author

* Daniel Muhra

## License

* Copyright (c) 2012 Daniel Muhra
* [MIT](www.opensource.org/licenses/MIT)

## References

* [SkypeKit C++ Wrapper Reference](http://developer.skype.com/skypekit/reference/cpp/index.html)