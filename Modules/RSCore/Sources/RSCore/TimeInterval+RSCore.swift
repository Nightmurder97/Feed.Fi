import Foundation

public extension TimeInterval {
	
	init(hours: Double) {
		self = hours * 3600
	}
	
	init(minutes: Double) {
		self = minutes * 60
	}
	
	init(seconds: Double) {
		self = seconds
	}
}