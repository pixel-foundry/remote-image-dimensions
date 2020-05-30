// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "RemoteImageDimensions",
	products: [
		.library(name: "RemoteImageDimensions", targets: ["RemoteImageDimensions"])
	],
	targets: [
		.target(name: "RemoteImageDimensions"),
		.testTarget(name: "Tests", dependencies: ["RemoteImageDimensions"])
	]
)
