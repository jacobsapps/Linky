//
//  DeepLinkHandler.swift
//  Linky
//
//  Created by Jacob Bartlett on 22/01/2025.
//

import AsyncAlgorithms
import Foundation

public protocol DeepLinkHandler {
    func open(url: URL) async
    func stream(_ link: DeepLink) -> AsyncChannel<DeepLink>
}

public enum DeepLink: String, CaseIterable, Sendable {
    
    case favourites = #"/favourites/?$"#
    case recents = #"/recents/?$"#
    case mostRecent = #"/mostrecent/?$"#
    case contacts = #"/contacts/?$"#
    case addContact = #"/addcontact/?$"#
    
    fileprivate static func link(from url: URL) -> DeepLink? {
        DeepLink.allCases.first(where: { url.absoluteString ~= $0.rawValue })
    }
}

public final class DeepLinkHandlerImpl: DeepLinkHandler {
    
    private let _favouritesStream = AsyncChannel<DeepLink>()
    private let _contactsStream = AsyncChannel<DeepLink>()
    private let _addContactStream = AsyncChannel<DeepLink>()
    private let _recentsStream = AsyncChannel<DeepLink>()
    private let _mostRecentStream = AsyncChannel<DeepLink>()
    
    public func stream(_ link: DeepLink) -> AsyncChannel<DeepLink> {
        switch link {
        case .favourites:
            return _favouritesStream
        case .contacts:
            return _contactsStream
        case .addContact:
            return _addContactStream
        case .recents:
            return _recentsStream
        case .mostRecent:
            return _mostRecentStream
        }
    }
    
    public func open(url: URL) async {
        guard let link = DeepLink.link(from: url) else { return }
        Task {
            switch link {
            case .favourites:
                await _favouritesStream.send(link)
            case .contacts:
                await _contactsStream.send(link)
            case .addContact:
                await _addContactStream.send(link)
            case .recents:
                await _recentsStream.send(link)
            case .mostRecent:
                await _mostRecentStream.send(link)
            }
        }
    }
}
