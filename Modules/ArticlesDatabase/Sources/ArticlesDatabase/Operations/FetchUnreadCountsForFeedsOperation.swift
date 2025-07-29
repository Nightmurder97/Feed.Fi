//
//  FetchUnreadCountsForFeedsOperation.swift
//  ArticlesDatabase
//
//  Created by Brent Simmons on 8/28/16.
//  Copyright © 2016 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSCore
import RSDatabase
import RSDatabaseObjC
import Articles

public class FetchUnreadCountsForFeedsOperation: MainThreadOperation {

	public var completion: (([String: Int]) -> Void)?
	public var result: [String: Int] = [:]
	private let databaseQueue: DatabaseQueue
	private let webFeedIDs: Set<String>
	
	init(webFeedIDs: Set<String>, databaseQueue: DatabaseQueue) {
		self.webFeedIDs = webFeedIDs
		self.databaseQueue = databaseQueue
		super.init()
	}
	
	override public func run() {
		
		guard !webFeedIDs.isEmpty else {
			result = [:]
			completion?(result)
			finish()
			return
		}
		
		databaseQueue.runInDatabase { databaseResult in
			
			if self.isCanceled {
				self.result = [:]
				self.completion?(self.result)
				self.finish()
				return
			}
			
			switch databaseResult {
			case .success(let database):
				self.fetchUnreadCounts(database)
			case .failure:
				self.result = [:]
				self.completion?(self.result)
				self.finish()
			}
		}
	}
	
	private func fetchUnreadCounts(_ database: FMDatabase) {
		let placeholders = webFeedIDs.map { _ in "?" }.joined(separator: ",")
		let sql = "select feedID, count(*) from articles natural join statuses where feedID in (\(placeholders)) and read=0 group by feedID;"
		
		guard let resultSet = database.executeQuery(sql, withArgumentsIn: Array(webFeedIDs)) else {
			result = [:]
			completion?(result)
			finish()
			return
		}
		
		var unreadCountDictionary = [String: Int]()
		while resultSet.next() {
			if isCanceled {
				resultSet.close()
				result = [:]
				completion?(result)
				finish()
				return
			}
			let unreadCount = resultSet.long(forColumnIndex: 1)
			if let webFeedID = resultSet.string(forColumnIndex: 0) {
				unreadCountDictionary[webFeedID] = unreadCount
			}
		}
		resultSet.close()
		
		result = unreadCountDictionary
		completion?(result)
		finish()
	}
}
