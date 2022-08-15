//
//  Models.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import Foundation

// MARK: - Home Page Data
struct HomeData: CodeHashable {
    let data: [ShowsData]
}
struct ShowsData: CodeHashable {
    let id, position: Int
    let type: SectionType
    let items: [Shows]
}
struct Shows: CodeHashable {
    let id: Int
    let image: String
    let position: Int
    let isFree: Bool
    let completionPercentage: Double?
    let metaInfo: MetaInfo
}
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

//MARK: - ACCOUNT
struct AccountData: CodeHashable {
    var title: String
    var subtitle: String?
    var type: AccountType
}
enum AccountType: String, CodeHashable {
    case plans
    case language
    case about
    case faq
}

//MARK: - Tab Bar
enum AvailableBottomFeature: String {
    case home = "HomeViewController"
    case search = "SearchViewController"
    case download = "DownloadViewController"
    case upcoming = "UpcomingViewController"
    case account = "AccountViewController"
}

struct TabItem {
    var name: String
    var imageName: String
    var selectedImageName: String
    var feature: AvailableBottomFeature

    static func getDefaultTabItems() -> [TabItem] {
        let homeTab = TabItem(name: "Home",
                              imageName: "house",
                              selectedImageName: "house.fill",
                              feature: .home)
        let searchTab = TabItem(name: "Discover",
                                     imageName: "magnifyingglass.circle",
                                     selectedImageName: "magnifyingglass.circle.fill",
                                     feature: .search)
        let downloadTab = TabItem(name: "Downloads",
                              imageName: "arrow.down.circle",
                              selectedImageName: "arrow.down.circle.fill",
                              feature: .download)
        let upcomingTab = TabItem(name: "Upcoming",
                              imageName: "bell",
                              selectedImageName: "bell.fill",
                              feature: .upcoming)
        let accountTab = TabItem(name: "Account",
                                 imageName: "person.crop.circle",
                                 selectedImageName: "person.crop.circle.fill",
                                 feature: .account)
        return [homeTab, searchTab, downloadTab, upcomingTab, accountTab]
    }
}
