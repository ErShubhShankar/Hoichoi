//
//  Models.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import Foundation

public typealias CodeHashable = Codable & Hashable & Equatable

// MARK: - Welcome
struct HomeData: CodeHashable {
    let data: [ShowsData]
}

// MARK: - Datum
struct ShowsData: CodeHashable {
    let id, position: Int
    let type: SectionType
    let items: [Shows]
}

// MARK: - Item
struct Shows: CodeHashable {
    let id: Int
    let image: String
    let position: Int
    let isFree: Bool
    let completionPercentage: Double?
    let metaInfo: MetaInfo
}

// MARK: - MetaInfo
struct MetaInfo: CodeHashable {
    let title, seasons, episodes, genre: String
    let  duration, year: String?
}

enum SectionType: String, CodeHashable {
    case poster
    case continueWatching
    case orignal
    case artist
    case watchlist
    case trending
    case channels
    case newPremieres
    case music
    case mustWatch
    case promotion
    case classic
    case newTrending
    
    var displayName: String {
        switch self {
        case .poster:
            return "Poster"
        case .continueWatching:
            return "Continue Watching"
        case .orignal:
            return "Hoichoi Orignals"
        case .artist:
            return "Brows by Artis"
        case .watchlist:
            return "My Watchlist"
        case .trending:
            return "Trending on hoichoi"
        case .channels:
            return "Live TV Channels"
        case .newPremieres:
            return "New Premieres"
        case .music:
            return "New Music Releases"
        case .mustWatch:
            return "Must Watch Series"
        case .promotion:
            return "promotion"
        case .classic:
            return "Classics"
        case .newTrending:
            return "New and Trending Series"
        }
    }
}
