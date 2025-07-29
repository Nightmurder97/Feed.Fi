//
//  FetchFeedUnreadCountOperation.swift
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

public class FetchFeedUnreadCountOperation: MainThreadOperation {

	public var completion: ((Int) -> Void)?
	public var result: Int = 0
	private let databaseQueue: DatabaseQueue
	private let webFeedID: String
	private let cutoffDate: Date
	
	init(webFeedID: String, databaseQueue: DatabaseQueue, cutoffDate: Date) {
		self.webFeedID = webFeedID
		self.databaseQueue = databaseQueue
		self.cutoffDate = cutoffDate
		super.init()
	}
	
	override public func run() {
		
		databaseQueue.runInDatabase { databaseResult in
			
			if self.isCanceled {
				self.result = 0
				self.completion?(self.result)
				self.finish()
				return
			}
			
			switch databaseResult {
			case .success(let database):
				self.fetchUnreadCount(database)
			case .failure:
				self.result = 0
				self.completion?(self.result)
				self.finish()
			}
		}
	}
	
	private func fetchUnreadCount(_ database: FMDatabase) {
		let sql = "select count(*) from articles natural join statuses where feedID=? and read=0 and datePublished > ?;"
		
		guard let resultSet = database.executeQuery(sql, withArgumentsIn: [webFeedID, cutoffDate]) else {
			result = 0
			completion?(result)
			finish()
			return
		}
		
		if resultSet.next() {
			if isCanceled {
				resultSet.close()
				result = 0
				completion?(result)
				finish()
				return
			}
			result = resultSet.long(forColumnIndex: 0)
		}
		resultSet.close()
		
		completion?(result)
		finish()
	}
}
