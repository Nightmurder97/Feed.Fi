import Foundation
import CommonCrypto

public extension String {
    
    var collapsingWhitespace: String {
        return self.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var trimmingWhitespace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func stripping(prefix: String, caseSensitive: Bool = false) -> String {
        if caseSensitive {
            return self.hasPrefix(prefix) ? String(self.dropFirst(prefix.count)) : self
        } else {
            let lowercasedSelf = self.lowercased()
            let lowercasedPrefix = prefix.lowercased()
            return lowercasedSelf.hasPrefix(lowercasedPrefix) ? String(self.dropFirst(prefix.count)) : self
        }
    }
    
    func stripping(suffix: String, caseSensitive: Bool = false) -> String {
        if caseSensitive {
            return self.hasSuffix(suffix) ? String(self.dropLast(suffix.count)) : self
        } else {
            let lowercasedSelf = self.lowercased()
            let lowercasedSuffix = suffix.lowercased()
            return lowercasedSelf.hasSuffix(lowercasedSuffix) ? String(self.dropLast(suffix.count)) : self
        }
    }
    
    func strippingHTML() -> String {
        // Simple HTML tag removal - can be enhanced for more complex cases
        let pattern = "<[^>]+>"
        return self.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
    }
    
    var escapingSpecialXMLCharacters: String {
        return self
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
    
    var strippingHTTPOrHTTPSScheme: String {
        if self.hasPrefix("http://") {
            return String(self.dropFirst(7))
        } else if self.hasPrefix("https://") {
            return String(self.dropFirst(8))
        }
        return self
    }
    
    var normalizedURL: String {
        if self.hasPrefix("feeds:") {
            let withoutFeeds = String(self.dropFirst(6))
            if withoutFeeds.hasPrefix("https://") {
                return withoutFeeds
            } else if withoutFeeds.hasPrefix("//https://") {
                return String(withoutFeeds.dropFirst(2))
            } else {
                return "https://" + withoutFeeds
            }
        } else if self.hasPrefix("feed:") {
            let withoutFeed = String(self.dropFirst(5))
            if withoutFeed.hasPrefix("https://") {
                return withoutFeed
            } else if withoutFeed.hasPrefix("//https://") {
                return String(withoutFeed.dropFirst(2))
            } else {
                return "http://" + withoutFeed
            }
        }
        return self
    }
    
    var md5Hash: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}