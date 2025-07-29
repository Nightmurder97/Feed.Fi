//
//  FetchAllUnreadCountsOperation.swift
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

public class FetchAllUnreadCountsOperation: MainThreadOperation {

	public var completion: (([String: Int]) -> Void)?
	public var result: [String: Int] = [:]
	private let databaseQueue: DatabaseQueue
	
	init(databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
		super.init()
	}
	
	override public func run() {
		
		databaseQueue.runInDatabase { databaseResult in
			
			if self.isCanceled {
				self.result = [:]
				self.completion?(self.result)
				self.finish()
				return
			}
			
			switch databaseResult {
			case .success(let database):
				self.fetchAllUnreadCounts(database)
			case .failure:
				self.result = [:]
				self.completion?(self.result)
				self.finish()
			}
		}
	}
	
	private func fetchAllUnreadCounts(_ database: FMDatabase) {
		let sql = "select feedID, count(*) from articles natural join statuses where read=0 group by feedID;"
		
		guard let resultSet = database.executeQuery(sql, withArgumentsIn: []) else {
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
