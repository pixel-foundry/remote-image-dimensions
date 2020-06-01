import Foundation

public enum ImageFormat: String, CaseIterable, Hashable {

	case bmp
	case gif
	case jpeg
	case png

	var minimumSampleSize: Int? {
		switch self {
		case .bmp: return 29
		case .gif: return 11
		case .jpeg: return nil
		case .png: return 25
		}
	}

	public init(data: Data) throws {
		let length: UInt16 = data[0..<2].unsafeUInt16
		switch length.bigEndian {
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
