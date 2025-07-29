import Foundation

public extension Date {
    
    func bySubtracting(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self) ?? self
    }
    
    func bySubtracting(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: -hours, to: self) ?? self
    }
    
    func bySubtracting(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: -minutes, to: self) ?? self
    }
    
    func bySubtracting(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: -seconds, to: self) ?? self
    }
}