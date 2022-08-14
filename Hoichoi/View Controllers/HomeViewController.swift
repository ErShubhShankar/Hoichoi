//
//  HomeViewController.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit

class HomeViewController: UIViewController {
    private typealias DataSource  = UICollectionViewDiffableDataSource<SectionType, Shows>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionType, Shows>
    
    @IBOutlet weak private var collectionView: UICollectionView!
    private var homeData: HomeData?
    private var dataSource: DataSource?
    private var snapShot: DataSourceSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeData = Bundle.main.decodeJsonFromBundle(HomeData.self, from: "HomeData.json")
        registerCells()
        collectionView.collectionViewLayout = createLayout()
        makeDataSource()
        applySnapshot()
        collectionView.contentInset = UIEdgeInsets(top: -45, left: 0, bottom: 60, right: 0)
    }
    
    private func registerCells() {
        PosterCell.register(for: collectionView)
        ShowsCell.register(for: collectionView)
        let identifier = "HeaderCollectionReusableView"
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: identifier, withReuseIdentifier: identifier)
    }
    
    private func applySnapshot() {
        guard let homeData = homeData else {return}
        snapShot = DataSourceSnapshot()
        let arraySectionTypes = homeData.data.sorted(by: {$0.position < $1.position}).map{ $0.type}
        snapShot.appendSections(arraySectionTypes)
        for section in homeData.data {
            let items = section.items.sorted(by: {$0.position < $1.position})
            snapShot.appendItems(items, toSection: section.type)
        }
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    private func makeDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {[weak self] (collectionView, indexPath, show) -> UICollectionViewCell? in
            guard let self = self else {return nil}
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            switch section {
            case .poster:
                let cell: PosterCell = collectionView.dequeueCell(for: indexPath)
                cell.updateUI(show: show)
                return cell
            case .continueWatching, .orignal, .artist, .watchlist:
                let cell: ShowsCell = collectionView.dequeueCell(for: indexPath)
                cell.updateTitleUI(show: show)
                return cell
            case .channels:
                let cell: ShowsCell = collectionView.dequeueCell(for: indexPath)
                cell.updateTitleUI(show: show, hideBadge: false)
                return cell
            case .trending:
                let cell: PosterCell = collectionView.dequeueCell(for: indexPath)
                cell.updateUI(show: show, isTrendingLayout: true)
                return cell
            default:
                return nil
            }
        })
        dataSource?.supplementaryViewProvider = {[weak self] (collectionView, item, indexPath) in
            guard let self = self else {return HeaderCollectionReusableView()}
            let identifier = "HeaderCollectionReusableView"
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: identifier,
                                                                         withReuseIdentifier: identifier,
                                                                         for: indexPath) as? HeaderCollectionReusableView
            header?.labelTitle.text = self.dataSource?.sectionIdentifier(for: indexPath.section)?.displayName ?? ""
            header?.buttonHeader.tag = indexPath.section
            header?.buttonHeader.addTarget(self, action: #selector(self.actionOnButtonHeader(_:)), for: .touchUpInside)
            return header
        }
    }
}

//MARK: - Layouts
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {[weak self] (sectionindex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            guard let sectionType = self.dataSource?.sectionIdentifier(for: sectionindex) else {return nil}
            switch sectionType {
            case .poster:
                return self.createPosterLayout()
            case .continueWatching, .watchlist:
                return self.createCWLayout()
            case .orignal:
                return self.createOrignalLayout()
            case .artist, .channels:
                return self.createArtistLayout()
            case .trending:
                return self.createTrendingLayout()
            default: return nil
            }
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.register(BackgroundCollectionReusableView.self, forDecorationViewOfKind: "background")
        return layout
    }
    
    private func createPosterLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0)
        return section
    }
    private func createCWLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28),
                                               heightDimension: .fractionalWidth(0.45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 32, trailing: 12)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createOrignalLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalWidth(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundItem.contentInsets.leading = 0
        backgroundItem.contentInsets.trailing = 0
        section.decorationItems = [backgroundItem]
        return section
    }
    private func createArtistLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let width = ((collectionView.frame.width-60)/4)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
                                               heightDimension: .absolute(width/0.8695))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 32, trailing: 12)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createTrendingLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.47),
                                               heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 12, leading: 0, bottom: 0, trailing: 0)
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0)
        let header = self.createHeaderLayout(leftInset: 12)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createHeaderLayout(leftInset: CGFloat = 0) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerIdentifier = "HeaderCollectionReusableView"
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(32))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: headerIdentifier,
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = false
        headerItem.contentInsets = .init(top: 0, leading: leftInset, bottom: 0, trailing: leftInset)
        return headerItem
    }

    @objc func actionOnButtonHeader(_ sender: UIButton) {
        let section = dataSource?.sectionIdentifier(for: sender.tag)?.displayName ?? ""
        Logger.log(message: "Open \(section)", event: .debug)
    }
}

//MARK: - CollectionView Delegate & Animations
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0.0
        cell.frame.origin.x += 20
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
            cell.alpha = 1
            cell.frame.origin.x -= 20
        })
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
            view.alpha = 1
        })
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.showHightLight()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.showUnHightLight()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
