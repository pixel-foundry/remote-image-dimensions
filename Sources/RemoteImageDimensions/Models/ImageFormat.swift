import Foundation

public enum ImageFormat: Hashable {

	case bmp
	case gif
	case jpeg
	case png

	var minimumSampleSize: Int {
		switch self {
		case .bmp: return 29
		case .gif: return 11
		case .jpeg: return 11
		case .png: return 25
		}
	}

	public init(data: Data) throws {
		let length: UInt16 = data[0..<2].unsafeUInt16
		switch CFSwapInt16(length) {
		case 0x424D: 	self = .bmp
		case 0x4749:	self = .gif
		case 0xFFD8:	self = .jpeg
		case 0x8950:	self = .png
		default: throw Error.unsupportedFormat
		}
	}

	enum Error: Swift.Error {
		case unsupportedFormat
	}

}
