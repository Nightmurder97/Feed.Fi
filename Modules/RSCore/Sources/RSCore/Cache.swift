import Foundation

public protocol CacheRecord {
    var key: String { get }
    var date: Date { get }
}

public final class Cache<T: CacheRecord> {
    
    private let timeToLive: TimeInterval
    private let timeBetweenCleanups: TimeInterval
    private var cache = [String: T]()
    private var lastCleanup = Date()
    
    public init(timeToLive: TimeInterval, timeBetweenCleanups: TimeInterval) {
        self.timeToLive = timeToLive
        self.timeBetweenCleanups = timeBetweenCleanups
    }
    
    public func add(_ record: T) {
        cleanupIfNeeded()
        cache[record.key] = record
    }
    
    public func get(_ key: String) -> T? {
        cleanupIfNeeded()
        guard let record = cache[key] else { return nil }
        
        let age = Date().timeIntervalSince(record.date)
        if age > timeToLive {
            cache.removeValue(forKey: key)
            return nil
        }
        
        return record
    }
    
    public func remove(_ key: String) {
        cache.removeValue(forKey: key)
    }
    
    public func clear() {
        cache.removeAll()
    }
    
    public subscript(key: String) -> T? {
        get {
            return get(key)
        }
        set {
            if let record = newValue {
                add(record)
            } else {
                remove(key)
            }
        }
    }
    
    private func cleanupIfNeeded() {
        let now = Date()
        let timeSinceLastCleanup = now.timeIntervalSince(lastCleanup)
        
        if timeSinceLastCleanup > timeBetweenCleanups {
            cleanup()
            lastCleanup = now
        }
    }
    
    private func cleanup() {
        let now = Date()
        let keysToRemove = cache.compactMap { key, record in
            let age = now.timeIntervalSince(record.date)
            return age > timeToLive ? key : nil
        }
        
        for key in keysToRemove {
            cache.removeValue(forKey: key)
        }
    }
}

public extension TimeInterval {
    static func hours(_ hours: Int) -> TimeInterval {
        return TimeInterval(hours * 3600)
    }
}