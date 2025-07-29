//
//  HTMLMetadataCache.swift
//
//
//  Created by Brent Simmons on 10/13/24.
//

import Foundation
import RSCore
@preconcurrency import RSParser

public extension Notification.Name {
	// Sent when HTMLMetadata is cached. Posted on any thread.
	static let htmlMetadataAvailable = Notification.Name("htmlMetadataAvailable")
}

public final class HTMLMetadataCache: Sendable {

	static let shared = HTMLMetadataCache()
	
	// Sent along with .htmlMetadataAvailable notification
	public struct UserInfoKey {
		public static let htmlMetadata = "htmlMetadata"
		public static let url = "url" // String value
	}

	private struct HTMLMetadataCacheRecord: CacheRecord {
		let key: String
		let date: Date
		let metadata: RSHTMLMetadata
		
		init(key: String, metadata: RSHTMLMetadata) {
			self.key = key
			self.date = Date()
			self.metadata = metadata
		}
	}

	private let cache = Cache<HTMLMetadataCacheRecord>(timeToLive: TimeInterval.hours(21), timeBetweenCleanups: TimeInterval.hours(10))

	subscript(_ url: String) -> RSHTMLMetadata? {
		get {
			return cache[url]?.metadata
		}
		set {
			guard let htmlMetadata = newValue else {
				return
			}
			let cacheRecord = HTMLMetadataCacheRecord(key: url, metadata: htmlMetadata)
			cache[url] = cacheRecord
			NotificationCenter.default.post(name: .htmlMetadataAvailable, object: self, userInfo: [UserInfoKey.htmlMetadata: htmlMetadata, UserInfoKey.url: url])
		}
	}
}
