//
//  CloudKitAccountZone.swift
//  Account
//
//  Created by Maurice Parker on 3/21/20.
//  Copyright © 2020 Ranchero Software, LLC. All rights reserved.
//

// MARK: - Modern CloudKit APIs
// Updated to use modern CloudKit APIs with async/await support

import Foundation
import os.log
import RSCore
import RSWeb
import RSParser
import CloudKit

public class CloudKitAccountZone: CloudKitZone {
	
	public var zoneID: CKRecordZone.ID
	public var log: OSLog
	
	public weak var container: CKContainer?
	public weak var database: CKDatabase?
	public weak var delegate: CloudKitZoneDelegate?
	
	public init(zoneID: CKRecordZone.ID, container: CKContainer, database: CKDatabase) {
		self.zoneID = zoneID
		self.container = container
		self.database = database
		self.log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "CloudKit")
	}
	
}

public extension CloudKitAccountZone {
	
	func findOrCreateAccount(completion: @escaping (Result<String, Error>) -> Void) {
		let predicate = NSPredicate(format: "isAccount = \"1\"")
		let ckQuery = CKQuery(recordType: CloudKitContainer.recordType, predicate: predicate)
		
		database?.fetch(withQuery: ckQuery, inZoneWith: zoneID, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { [weak self] result in
			guard let self = self else { return }
			
			switch result {
			case .success(let queryResult):
				DispatchQueue.main.async {
					if queryResult.matchResults.count > 0 {
						let record = queryResult.matchResults[0].1
						completion(.success(record.externalID))
					} else {
						self.createContainer(name: "Account", isAccount: true, completion: completion)
					}
				}
			case .failure(let error):
				switch CloudKitZoneResult.resolve(error) {
				case .zoneNotFound:
					self.createZoneRecord() { result in
						switch result {
						case .success:
							self.findOrCreateAccount(completion: completion)
						case .failure(let error):
							DispatchQueue.main.async {
								completion(.failure(error))
							}
						}
					}
				case .retry(let timeToWait):
					os_log(.error, log: self.log, "%@ zone find or create account retry in %f seconds.", self.zoneID.zoneName, timeToWait)
					self.retryIfPossible(after: timeToWait) {
						self.findOrCreateAccount(completion: completion)
					}
				default:
					DispatchQueue.main.async {
						completion(.failure(CloudKitError(error)))
					}
				}
			}
		}
	}
	
	func createContainer(name: String, isAccount: Bool, completion: @escaping (Result<String, Error>) -> Void) {
		let record = CKRecord(recordType: CloudKitContainer.recordType)
		record.setValue(name, forKey: CloudKitContainer.nameKey)
		record.setValue(isAccount ? "1" : "0", forKey: CloudKitContainer.isAccountKey)
		record.setValue(UUID().uuidString, forKey: CloudKitContainer.externalIDKey)
		
		save(record) { result in
			switch result {
			case .success:
				DispatchQueue.main.async {
					completion(.success(record.externalID))
				}
			case .failure(let error):
				DispatchQueue.main.async {
					completion(.failure(error))
				}
			}
		}
	}
	
}
