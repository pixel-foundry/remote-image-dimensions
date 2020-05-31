# RemoteImageDimensions

`RemoteImageDimensions` is a Swift package for determining the dimensions and image type of a remote image without downloading the whole thing.

The size and filetype of an image can usually be determined after downloading less than 512 bytes.

`RemoteImageDimensions` supports any platform that can run Swift executables: iOS, macOS, Linux, Windows.

## Usage

```swift
import RemoteImageDimensions

let image = URL(string: "https://pixelfoundry.io/static/logo.png")!
RemoteImage.dimensions(of: image) { result in
    switch result {
        case .success(let dimensions):
            print(dimensions) // Dimensions(width: 606, height: 216, format: .png, bytes: 512)
        case .failure: return
    }
}
```

### Combine Interface

`RemoteImageDimensions` offers [Combine](https://developer.apple.com/documentation/combine) bindings on supported platforms.

```swift
import Combine
import RemoteImageDimensions

var cancellable: AnyCancellable?
cancellable = RemoteImage.dimensions(of: image).sink(
    receiveCompletion: { _ in },
    receiveValue: { dimensions in
        print(dimensions) // Dimensions(width: 606, height: 216, format: .png, bytes: 512)
    }
)
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/pixel-foundry/remote-image-dimensions", from: "1.0.0")
],
targets: [
    .target(name: "YourTarget", dependencies: ["RemoteImageDimensions"])
]
```
