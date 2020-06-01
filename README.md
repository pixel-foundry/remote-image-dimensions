# RemoteImageDimensions

`RemoteImageDimensions` is a Swift package for determining the dimensions and image type of a remote image without downloading the whole thing. The size of most image formats can be determined after downloading fewer than 30 bytes.

`RemoteImageDimensions` supports any platform that can run Swift executables: iOS, macOS, Linux, Windows.

## Usage

```swift
import RemoteImageDimensions

let image = URL(string: "https://pixelfoundry.io/static/logo.png")!

RemoteImage.dimensions(of: image) { result in
    switch result {
        case .success(let dimensions):
            print(dimensions) // Dimensions(width: 606, height: 216, format: .png, bytes: 25)
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
        print(dimensions) // Dimensions(width: 606, height: 216, format: .png, bytes: 25)
    }
)
```

## Configuration

You can specify the timeout and byte-range headers of network requests using `RemoteImage.Configuration`.
`RemoteImageDimensions` attempts to download the absolute minimum amount of data to determine the size of the image, which may not always be enough data in the case of non-deterministic formats like JPEG.

```swift
RemoteImage.dimensions(of: image, configuration: .init(timeout: 10, byteRange: 0..<100000))
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
