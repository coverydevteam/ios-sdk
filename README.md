# Covery KYC SDK

 ![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat-square)
 ![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)
 ![CocoaPods Compatible](https://img.shields.io/badge/CocoaPods-compatible-orange?style=flat-square)
 [![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)


## Table of contents

- [Prerequisites](#prerequsites)
- [Installation](#installation)
- [Preparation](#preparation)
- [Configuration](#configuration)
- [Initialization](#initialization)
- [Usage of SDK](#usage-of-sdk)

## Prerequisites

- **macOS** (minimum version 15.1.1) [[link]](https://apps.apple.com/ua/app/macos-sequoia/id6596773750?mt=12)
- **Xcode** (minimum version 16.1) [[link]](https://apps.apple.com/ua/app/xcode/id497799835?mt=12)
- **Ruby** (minumum version 2.6.10p210) [[link]](https://www.ruby-lang.org/en/documentation/installation/)
- **CocoaPods** (minimum version 1.15.2) [[link]](https://cocoapods.org)
- **Shell** zsh x86_64-apple-darwin24.0 (minimum version 5.9, it is a default shell for recent versions of macOS)
- **iOS** (minimum deployment target 15.5)

## Installation

There are two approaches how to add CoverySDK to a project: **Cocoapods** or **SPM**.

### _Cocoapods package manager:_
First of all, set up Cocoapods for you project if it hasn't been set up before. [[link]](https://guides.cocoapods.org/using/using-cocoapods)

Add to **Podfile** this lines of code:
	
```ruby
 pod 'CoverySDK', :tag => '1.0.0', :git => 'https://github.com/coverydevteam/ios-sdk.git'
 pod 'TensorFlowLiteSwift'
```
In a terminal, go to the root of the project where is located **Podfile** and run the command:

```zsh
 pod install
```
### _Swift Package Manager:_

Also there is an option to install CoverySDK via **SPM**, but you should keep in mind that the dependency TensorFlowLiteSwift currently can be installed only via **Cocoapods**:

```swift
 dependencies: [
    .package(url: "https://github.com/coverydevteam/ios-sdk.git", .upToNextMajor(from: "1.0.0"))
]
```

## Preparation

Before starting using SDK, an app should request a permission to a camera access.
App's Info.plist should contain a key **NSCameraUsageDescription**.
Otherwise SDK should work inproperly.
This means that the app should ask the permission before and only after that should start showing screens from SDK. This permission is required in case of KYC procedure, otherwise it is an optional feature.

For example:

```xml
<key>NSCameraUsageDescription</key>
<string>Required for document and face capture</string>
```

There are optional permissions which might be used for device data collection:

```xml
<key>NFCReaderUsageDescription</key>
<string>Please provide access to NFC</string>
<key>NSBluetoothAlwaysUsageDescription </key> 
<string>Please provide access to Bluetooth</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Please provide access to your location</string>
<key>NSUserTrackingUsageDescription</key>
<string>Please allow user tracking</string>
```

⚠️ Please note that all methods below may return their callbacks in non-main thread.

## Configuration

When an app launches, SDK should be configured at first time:

```swift
do {
  try SDKCovery.configure(config: nil)
} catch {
  debugPrint(error.localizedDescription)
}
```

There is information about a configuration object:

```swift
/// A configuration object which can be used for SDK initialization
final public class SDKConfiguration {

    /// Positioning of Accept / Retake buttons
    ///  - horizontal:
    ///     * [ Accept ] [ Retake ]
    ///  - vertical:
    ///     * [ Accept ]
    ///     * [ Retake ]
    public enum ButtonsBarAxis : String, Codable {

        case horizontal

        case vertical
    }

    /// Configuration object for text
    public struct TextConfigurationItem : Codable {

        /// Initializes a configuration object
        /// - Parameters:
        ///   - fontName: Custom font name. The given font should be exist in the app. If font name isn't set then default one will be used
        ///   - fontSize: Custom font size. If font size isn't set then default one will be used
        public init(fontName: String? = nil, fontSize: CGFloat? = nil)
    }

    /// Configuration object for button
    public struct ButtonConfigurationItem : Codable {

        public enum ButtonType : String, Codable {

            case flat

            case bordered
        }

        /// Initializes a configuration object
        /// - Parameters:
        ///   - showsIcon: A flag for showing/hiding a button icon. If it is `nil` then default value will be used
        ///   - buttonType: Defines a view of a button. if it is `nil` then default value will be used
        ///   - buttonBorderCornerRadius: A button corner radius in points. If it is `nil` then default value will be used
        ///   - borderWidth: A border width in points. If it is `nil` then default value will be used
        public init(showsIcon: Bool? = nil, buttonType: CoverySDK.SDKConfiguration.ButtonConfigurationItem.ButtonType? = nil, buttonBorderCornerRadius: CGFloat? = nil, borderWidth: CGFloat? = nil)
    }

    /// Configuration object for button's bar
    public struct ButtonsBarConfiguration : Codable {

        public enum ButtonOrder : String, Codable {

            case accept

            case retake
        }

        /// Initializes a configuration object
        /// - Parameters:
        ///   - layoutAxis: Positioning of Accept / Retake buttons
        ///   - buttonOrder: An order of buttons (Accept | Retake or Retake | Accept)
        ///   - retakeButton: A cuztomization of Retake button
        ///   - acceptButton: A customization of Accept button
        ///   - titleFont: A customization of title font
        ///   - bodyFont: A customization of body font
        public init(layoutAxis: CoverySDK.SDKConfiguration.ButtonsBarAxis? = nil, buttonOrder: CoverySDK.SDKConfiguration.ButtonsBarConfiguration.ButtonOrder? = nil, retakeButton: CoverySDK.SDKConfiguration.ButtonConfigurationItem? = nil, acceptButton: CoverySDK.SDKConfiguration.ButtonConfigurationItem? = nil, titleFont: CoverySDK.SDKConfiguration.TextConfigurationItem? = nil, bodyFont: CoverySDK.SDKConfiguration.TextConfigurationItem? = nil)
    }

    /// Initializes button's bar configurations
    /// - Parameters:
    ///   - buttonBarConfiguration: Object for button's bar
    ///   - localizationTableName: Name of custom localization file
    public init(buttonBarConfiguration: CoverySDK.SDKConfiguration.ButtonsBarConfiguration? = nil, localizationTableName: String? = nil)
}
```

Sample of localization file for SDK is in **Localizable_sample.xcstrings**.
If you need to add your own localizations, you shold create **.strings** or **.xcstrings** file(s) and pass the name of it to SDK during initialization.
Current version SDK supports only English localization.
In case of altering localization, own variant of English version should be also provided.

In order to customize a theme of SDK's screens you should create a specific folder structure in your image assets:

- covery_sdk
	* selfie
		+ colors
			- accept\_background
			- accept\_button\_background
			- accept\_button\_border
			- accept\_button\_icon
			- accept\_button\_text
			- accept\_text
			- back\_button
			- oval\_border\_selected
			- retake\_button\_background
			- retake\_button\_border
			- retake\_button\_icon
			- retake\_button\_text
			- scanner\_text
		+ icons
			- accept\_button
			- retake\_button

![ACS](readme_images/sdk_colors_asset_structure.png)

Please don't forget to set a checkmark for a namespace to every folder, otherwise the colours couldn't be get properly by SDK.

![AN](readme_images/sdk_assets_namespace.png)

Finally, you can alter the default SDK fonts with custom ones. 
They should be properly installed into the app bundle in order to be used by SDK with custom names.

## Initialization

After obtaining an access token from Covery web-service, SDK should be initialized:

```swift
 DKCovery.Authorization.updateToken(<access token from backend>) { error in
 	debugPrint("Error: \(error?.localizedDescription)")
 } 
```

## Usage of SDK

### _Selfie KYC_

After initializing SDK with access token, there is method to initiate selfie KYC procedure:

```swift
SDKCovery.KYC.startKYCSelfie { error in
    debugPrint("Error: \(error?.localizedDescription)")
}
```

#### Showing KYC scanner UI

When the previous method completes without any error, the next step is showing a screen of KYC scanner.

```swift
SDKCovery.UIController.showKYC(
	parentController: <parent controller>) {
	    // User cancel completion
	}
	serverCompletion: { (result, error) in
	    ...
	} cameraCompletion: { error in
	    debugPrint("Error: \(error.localizedDescription)")
	}
```

Alternative method for using in **SwiftUI** is:

```swift
struct CustomView: View {
	@State private var showsCamera: Bool = false
	
	var body: some View {
		ZStack {
			...
			someSwiftUIView.showCoveryKYC(
			    showingController: $showsCamera,
			    cancelCompletion: {
			        ...
			    },
			    serverCompletion: { result in
			        debugPrint(result)
			        switch result {
			        case .success(let success):
			            ...
			        case .failure(let error):
			            debugPrint("Camera error: \(error.localizedDescription)")
			        }
			    },
			    cameraCompletion: { error in
			        debugPrint("Camera error: \(error.localizedDescription)")
			    })
		}
	}
}
```

After finishing procedure of selfie KYC, a screen, provided by SDK is closed automatically. 
The response should be returned to either completion **serverCompletion** or completion **cameraCompletion**.

### _Document KYC_

Document KYC procedure is a slightly longer.
Firstly, an app should obtain a list of available documents:

```swift
 SDKCovery.KYC.fetchDocumentList { result in
    switch result {
    case .success(let documents):
        ...
    case .failure(let error):
        debugPrint("Camera error: \(error.localizedDescription)")
    }
}
```

Please note that SDK doesn't provide any UI to represent list of documents, so it is a responsibility of an app.
After choosing a specific document type and document name by user, there is a method of initiation document KYC procedure:

```swift
let documentId   = ... // Choosed by user
let documentType = ... // Choosed by user
// Name (probably localized version) of choosed document by user. Provided by an app. 
// Can be **nil**. If this field isn't set, the default name of the document will be applied.
let documentName = ... 
SDKCovery.KYC.startKYCDocument(
        documentId: documentId, documentType: documentType, documentName: documentName
    ) { error in
        ...
}
```

Finally, an app performs method of [showing KYC scanner](#showing-kyc-scanner-ui).

### _Miscellaneous_

There is one more method in SDK. It is used for sending a device data to the backend:

```swift
SDKCovery.DataCollection.sendDeviceData { result in
	...
}
```

Please note, a device data collection is an asynchronous process. 

### _SDK error list_

Also SDK provides list of predefined errors:

```swift
public enum SDKError: Error {
    /// Informs that the SDK has been used before initialization
    case isntInitialized
    /// A user hasn't allowed yet or has forbidden a camera permission
    case cameraPermission
    /// There is happened a video session creation error
    case videoSessionCreation
    /// There is no enough free space on the device
    case notEnoughDiskSpace
    /// Covery access token is expired
    case authorizationError
    /// Incorrect response from Covery service
    case incorrectResponse
    /// A given document id isn't found or incorrect
    case incorrectDocumentId
    /// Some internal SDK error occurs
    case internalSDKError
    /// Some network error occurs (e. g. backend error)
    case networkError
    /// An error which is caused by an Internet connection issue
    case internetConnectionError
}
```








 
