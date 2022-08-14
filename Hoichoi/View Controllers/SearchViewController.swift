//
//  SearchViewController.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 15/08/22.
//

import UIKit

class SearchViewController: UIViewController {
    private typealias DataSource  = UICollectionViewDiffableDataSource<Int, String>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var textSearch: UITextField!
    private var arraySearchHistory: [String] = ["byomkesh", "old classic"]
    private var dataSource: DataSource?
    private var snapShot: DataSourceSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchHistoryCell.register(for: collectionView)
        let identifier = "HeaderCollectionReusableView"
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: identifier, withReuseIdentifier: identifier)
        collectionView.contentInset = .init(top: 30, left: 0, bottom: 20, right: 0)
        collectionView.collectionViewLayout = createLayout()
        makeDataSource()
        applySnapshot()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textSearch.attributedPlaceholder = NSAttributedString(
            string: "Search shows, movies and music",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "very_grey_blue") as Any]
        )
        textSearch.becomeFirstResponder()
        textSearch.delegate = self
    }
    private func applySnapshot() {
        snapShot = DataSourceSnapshot()
        if !arraySearchHistory.isEmpty {
            snapShot?.appendSections([1])
            snapShot?.appendItems(arraySearchHistory, toSection: 1)
        }
        dataSource?.apply(snapShot!, animatingDifferences: true)
    }
    private func makeDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {[weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else {return nil}
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            if section == 1 {
                let cell: SearchHistoryCell = collectionView.dequeueCell(for: indexPath)
                cell.labelTitle.text = item
                cell.buttonClose.tag = indexPath.row
                return cell
            } else {
                return nil
            }
        })
        dataSource?.supplementaryViewProvider = {[weak self] (collectionView, item, indexPath) in
            guard let self = self else {return HeaderCollectionReusableView()}
            let identifier = "HeaderCollectionReusableView"
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: identifier,
                                                                         withReuseIdentifier: identifier,
                                                                         for: indexPath) as? HeaderCollectionReusableView
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            header?.imageChevron.isHidden = true
            if section == 1 {
                header?.labelTitle.text = "Recent Searches"
            } else {
                header?.labelTitle.text = "Top Genre"
            }
            return header
        }
    }
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = {[weak self] (sectionindex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            guard let sectionType = self.dataSource?.sectionIdentifier(for: sectionindex) else {return nil}
            if sectionType == 1 {
                return self.createHistoryLayout()
            } else {
                return self.createGenreLayout()
            }
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    private func createHistoryLayout() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createGenreLayout() -> NSCollectionLayoutSection {
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
    private func createHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerIdentifier = "HeaderCollectionReusableView"
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(32))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: headerIdentifier,
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = false
        headerItem.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        return headerItem
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.collectionView.alpha = 1
        })
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchString = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchString.isEmpty {
            arraySearchHistory.append(searchString)
            UserDefaults.standard.set(arraySearchHistory, forKey: "search_history")
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.collectionView.alpha = 0
        })
        return true
    }
}
