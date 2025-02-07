//
//  DeepLinkHandler.swift
//  Linky
//
//  Created by Jacob Bartlett on 22/01/2025.
//

import Foundation
import AsyncAlgorithms
import Factory

public protocol DeepLinkHandler {
    func open(url: URL)
    func stream(_ link: DeepLink) -> AsyncChannel<Void>
}

public enum DeepLink: String, CaseIterable, Sendable {
    
    case favourites = #"/favourites/?$"#
    case contacts = #"/contacts/?$"#
    case recents = #"/recents/?$"#
    case addContact = #"/addContact/?$"#
    
    fileprivate static func link(from url: URL) -> DeepLink? {
        DeepLink.allCases.first(where: { url.absoluteString ~= $0.rawValue })
    }
}

public final class DeepLinkHandlerImpl: DeepLinkHandler {
    private let deepLinkChannel = AsyncChannel<DeepLink>()
    
    private let _favouritesStream = AsyncChannel<Void>()
    private let _contactsStream = AsyncChannel<Void>()
    private let _recentsStream = AsyncChannel<Void>()
    private let _addContactStream = AsyncChannel<Void>()
    
    public init() {
        Task {
            for try await link in deepLinkChannel {
                switch link {
                case .favourites: await _favouritesStream.send(())
                case .contacts:
                    await _contactsStream.send(())
                case .recents: await _recentsStream.send(())
                case .addContact: await _addContactStream.send(())
                }
            }
        }
    }
    
    public func stream(_ link: DeepLink) -> AsyncChannel<Void> {
        switch link {
        case .favourites: return _favouritesStream
        case .contacts:
            return _contactsStream
        case .recents: return _recentsStream
        case .addContact: return _addContactStream
        }
    }
    
    public func open(url: URL) {
        guard let link = DeepLink.link(from: url) else { return }
        Task {
            await deepLinkChannel.send(link)
        }
    }
}

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
