//
//  DeepLinkUtils.swift
//  Linky
//
//  Created by Jacob Bartlett on 14/02/2025.
//

import Factory
import Foundation

infix operator ~= : ComparisonPrecedence

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: rhs, options: [])
            let range = NSRange(lhs.startIndex..<lhs.endIndex, in: lhs)
            return regex.firstMatch(in: lhs, options: [], range: range) != nil
        } catch {
            return false
        }
    }
}

extension Container {
    var deepLinkHandler: Factory<DeepLinkHandler> {
        Factory(self) { DeepLinkHandlerImpl() }.scope(.singleton)
    }
}
