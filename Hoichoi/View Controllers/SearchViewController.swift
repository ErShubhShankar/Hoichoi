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
    private var arraySearchHistory: [String] = []
    private var arrayGenre: [String] = ["Thriller", "Comedies", "Horror", "Orignals", "Adventure", "Action", "Classics", "Detective", "Drama", "Free Movie", "Romance", "Shorts"]
    private var dataSource: DataSource?
    private var snapShot: DataSourceSnapshot?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        collectionView.contentInset = .init(top: 30, left: 0, bottom: 20, right: 0)
        collectionView.collectionViewLayout = createLayout()
        makeDataSource()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textSearch.attributedPlaceholder = NSAttributedString(
            string: "Search shows, movies and music",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "very_grey_blue") as Any]
        )
        textSearch.becomeFirstResponder()
        textSearch.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func registerCell() {
        SearchHistoryCell.register(for: collectionView)
        GenreTagCell.register(for: collectionView)
        let identifier = "HeaderCollectionReusableView"
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: identifier, withReuseIdentifier: identifier)
    }
    @objc private func actionOnDeleteHistory(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let item = dataSource?.itemIdentifier(for: indexPath), var snapShot = dataSource?.snapshot() {
            snapShot.deleteItems([item])
            if arraySearchHistory.count == 1 {
                snapShot.deleteSections([1])
            }
            dataSource?.apply(snapShot, animatingDifferences: true, completion: {[weak self] in
                guard let self = self else { return }
                self.makeDataSource()
                self.applySnapshot()
            })
            arraySearchHistory.removeAll(where: {$0 == item})
            UserDefaults.standard.set(arraySearchHistory, forKey: "search_history")
        }
    }
    
    //MARK: - Collection DataSource, Snapshot
    private func applySnapshot() {
        snapShot = DataSourceSnapshot()
        arraySearchHistory = (UserDefaults.standard.value(forKey: "search_history") as? [String] ?? [])
        arraySearchHistory = Array(arraySearchHistory.prefix(5))
        arraySearchHistory = Array(Set(arraySearchHistory.reversed()))
        if !arraySearchHistory.isEmpty {
            snapShot?.appendSections([1])
            snapShot?.appendItems(arraySearchHistory, toSection: 1)
        }
        if !arrayGenre.isEmpty {
            snapShot?.appendSections([2])
            snapShot?.appendItems(arrayGenre, toSection: 2)
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
                cell.buttonClose.addTarget(self, action: #selector(self.actionOnDeleteHistory(_:)), for: .touchUpInside)
                return cell
            } else {
                let cell: GenreTagCell = collectionView.dequeueCell(for: indexPath)
                cell.labelTitle.text = item
                return cell
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
    
    //MARK: - CollectionView Layout
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 32, trailing: 12)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
        return section
    }
    private func createGenreLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(10), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 12, bottom: 32, trailing: 12)
        let header = self.createHeaderLayout()
        section.boundarySupplementaryItems = [header]
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
        headerItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return headerItem
    }
}

//MARK: - TextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.collectionView.alpha = 1
        })
        applySnapshot()
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

//MARK: - CollectionView Delegate & Animation
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let section = dataSource?.sectionIdentifier(for: indexPath.section), section == 2 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.showHightLight()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let section = dataSource?.sectionIdentifier(for: indexPath.section), section == 2 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.showUnHightLight()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        let sectionType = dataSource?.sectionIdentifier(for: indexPath.section)
        if sectionType == 1, let item = dataSource?.itemIdentifier(for: indexPath) {
            textSearch.text = item
        }
    }
}

//MARK: - Keyboard Event
extension SearchViewController {
    @objc func keyboardShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.contentInset.bottom = keyBoardFrame.height+20
        }
    }
    @objc func keyboardHide(notification: NSNotification) {
        collectionView.contentInset.bottom = 20
    }
}
