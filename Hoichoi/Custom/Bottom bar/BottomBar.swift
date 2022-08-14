//
//  BottomBar.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit

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

class BottomBar: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionTabItems: UICollectionView!
    private var tabViewController: UIViewController?
    private var arrayTabItems: [TabItem] = []
    var currentFeature: UIViewController?
    // MARK: - Super Property
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func add(on tabViewController: UIViewController, tabItems: [TabItem] = []) -> BottomBar {
        let nib = UINib(nibName: "BottomBar", bundle: nil)
        if let bottomBar = nib.instantiate(withOwner: "BottomBar", options: nil)[0] as? BottomBar {
            bottomBar.tabViewController = tabViewController
            if tabItems.isEmpty {
                bottomBar.arrayTabItems = TabItem.getDefaultTabItems()
            } else {
                bottomBar.arrayTabItems = tabItems
            }
            bottomBar.setup()
            return bottomBar
        } else {
            return BottomBar()
        }
    }

    private func setup() {
        if let tabViewController = self.tabViewController {
            let bottomSpace = UIApplication.shared.window?.safeAreaInsets.bottom ?? 0
            let bottomBarHeight = 51+bottomSpace
            let point = CGPoint(x: 0, y: tabViewController.view.frame.height-bottomBarHeight)
            let size = CGSize(width: tabViewController.view.frame.width, height: bottomBarHeight)
            frame = CGRect(origin: point, size: size)
            tabViewController.view.addSubview(self)
            addConstraints()
        }
        BottomBarCell.register(for: collectionTabItems)
        collectionTabItems.delegate = self
        collectionTabItems.dataSource = self
        collectionTabItems.allowsMultipleSelection = false
    }

    private func addConstraints() {
        let bottomSpace = UIApplication.shared.window?.safeAreaInsets.bottom ?? 0
        let bottomBarHeight = 51+bottomSpace
        let superView = tabViewController ?? UITabBarController()
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: bottomBarHeight),
            self.leadingAnchor.constraint(equalTo: superView.view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superView.view.bottomAnchor)
        ])
        setNeedsLayout()
        layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.frame.height/2
        containerView.layer.masksToBounds = true
    }

    func selectTab(at index: Int) {
        if index < arrayTabItems.count {
            let tabItem = arrayTabItems[index]
            if let viewController = getViewController(feature: tabItem.feature) {
                if currentFeature?.classForCoder == viewController.classForCoder {
                     currentFeature?.navigationController?.popToRootViewController(animated: true)
                    for childVC in currentFeature?.children ?? [] {
                        childVC.view.removeFromSuperview()
                        childVC.removeFromParent()
                    }
                    for childVC in currentFeature?.parent?.children ?? [] where childVC != currentFeature {
                        childVC.view.removeFromSuperview()
                        childVC.removeFromParent()
                    }
                } else {
                    guard let parent = tabViewController as? ContainerViewController else {
                        return
                    }
                    parent.view.layoutIfNeeded()
                    viewController.view.frame.origin = CGPoint(x: 0, y: 0) // safeAreaInsets.top
                    viewController.view.frame.size.width = parent.viewContainer.frame.width
                    viewController.view.frame.size.height = parent.viewContainer.frame.height
                    parent.addChild(viewController)
                    viewController.view.fixInView(parent.viewContainer)
                    viewController.didMove(toParent: parent)
                    currentFeature?.willMove(toParent: nil)
                    currentFeature?.view.removeFromSuperview()
                    currentFeature?.removeFromParent()
                    currentFeature = viewController
                    parent.viewContainer.bringSubviewToFront(self)
                    viewController.view.layoutIfNeeded()
                    collectionTabItems.selectItem(at: IndexPath(item: index, section: 0),
                                                  animated: true,
                                                  scrollPosition: .centeredHorizontally)
                }
            }
        }
    }
    private func getViewController(feature: AvailableBottomFeature) -> UIViewController? {
        let classNameString = NSStringFromClass(type(of: self)).components(separatedBy: ".")[0] + "."+feature.rawValue
        guard let className = NSClassFromString(classNameString) as? UIViewController.Type else {
            return nil
        }
        if let viewController = className.instantiate(storyboard: "Main") {
            return viewController
        } else {
            return nil
        }
    }
}

extension BottomBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTabItems.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BottomBarCell = collectionView.dequeueCell(for: indexPath)
        cell.updateUI(tabItem: arrayTabItems[indexPath.row])
        return cell
    }
}

extension BottomBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.bounceAnimation()
        selectTab(at: indexPath.row)
    }
}

extension BottomBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/CGFloat(arrayTabItems.count)
        return CGSize(width: width, height: 56)
    }
}
