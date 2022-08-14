//
//  AccountViewController.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 14/08/22.
//

import UIKit

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
class AccountViewController: UIViewController {
    private typealias DataSource  = UICollectionViewDiffableDataSource<Int, AccountData>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, AccountData>
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var snapShot: DataSourceSnapshot!
    private var accountData: [AccountData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        accountData = [AccountData(title: "Plans", type: .plans),
                            AccountData(title: "App Launguage", subtitle: "English", type: .language),
                            AccountData(title: "About", type: .about),
                            AccountData(title: "FAQ", type: .faq)
        ]
        collectionView.collectionViewLayout = createLayout()
        registerCells()
        makeDataSource()
        applySnapshot()
    }
    
    @IBAction func actionOnSubscribe(_ sender: UIButton) {
        sender.scaleAnimation()
        if let subscribeVC = SubscribeViewController.instantiate(storyboard: "Main") {
            navigationController?.pushViewController(subscribeVC, animated: true)
        }
    }
    @objc func actionOnButtonHeader(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let headerIdentifier = "AccountHeader"
        let headerView = collectionView.supplementaryView(forElementKind: headerIdentifier, at: indexPath)
        headerView?.scaleAnimation()
    }
    private func registerCells() {
        AccountCell.register(for: collectionView)
        let identifier = "AccountHeader"
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: identifier, withReuseIdentifier: identifier)
    }
    private func applySnapshot() {
        snapShot = DataSourceSnapshot()
        snapShot.appendSections([1])
        snapShot.appendItems(accountData, toSection: 1)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    private func makeDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {(collectionView, indexPath, accountData) -> UICollectionViewCell? in
            let cell: AccountCell = collectionView.dequeueCell(for: indexPath)
            cell.updateUI(accountData: accountData)
            return cell
        })
        dataSource?.supplementaryViewProvider = {(collectionView, item, indexPath) in
            let identifier = "AccountHeader"
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: identifier,
                                                                         withReuseIdentifier: identifier,
                                                                         for: indexPath) as? AccountHeader
            header?.buttonHeader.tag = indexPath.section
            header?.buttonHeader.addTarget(self, action: #selector(self.actionOnButtonHeader(_:)), for: .touchUpInside)
            return header
        }
    }
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {(sectionindex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .absolute(55))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(55))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            let header = self.createHeaderLayout()
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 32, trailing: 0)
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    private func createHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerIdentifier = "AccountHeader"
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(55))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: headerIdentifier,
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = false
        headerItem.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        return headerItem
    }
}

extension AccountViewController: UICollectionViewDelegate {
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
