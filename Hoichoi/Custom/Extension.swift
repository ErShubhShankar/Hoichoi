//
//  Extension.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit
import Kingfisher

public typealias CodeHashable = Codable & Hashable & Equatable
extension UIApplication {
    var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
        return sceneDelegate.window
    }
}

extension UIViewController {
    static func instantiate(storyboard: String) -> Self? {
        let idValue = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: idValue) as? Self
    }
}

extension UIView {
    func fixInView(_ container: UIView?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let container = container {
            frame = container.frame
            container.addSubview(self)
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                               toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                               toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                               toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                               toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
    }
    func bounceAnimation(duration: CGFloat = 0.5,
                             animationValues: [CGFloat] = [1.0, 1.2, 0.9, 1.15, 0.95, 1.02, 1.0],
                         completion: (() -> Swift.Void)? = nil) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = animationValues
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        layer.add(bounceAnimation, forKey: nil)
        CATransaction.commit()
    }
    func showHightLight(_ callBack: (() -> Void)? = nil) {
      UIView.animate(withDuration: 0.4,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 8,
                     options: [.allowUserInteraction],
                     animations: {
                      self.transform = .init(scaleX: 0.9, y: 0.9)
                     }, completion: { _ in
                      callBack?()
                     })
    }

    func showUnHightLight(_ callBack: (() -> Void)? = nil) {
      UIView.animate(withDuration: 1.0,
                     delay: 0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 5.0,
                     options: [.allowUserInteraction],
                     animations: {
                      self.transform = .identity
                     }, completion: {_ in callBack?()})
    }
    func scaleAnimation() {
        showHightLight()
        showUnHightLight()
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell -> \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static func register(for collectionView: UICollectionView) {
        let bundle = Bundle(for: self)
        let cellName = String(describing: self)
        let cellIdentifier = reuseIdentifier
        let cellNib = UINib(nibName: cellName, bundle: bundle)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension Bundle {
    public func decodeJsonFromBundle<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate file \(file) in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        let decoder = JSONDecoder()
        guard let loaded = decoder.decodeSafely(T.self, from: data) else {
            fatalError("Failed to decode date from \(file)")
        }
        return loaded
    }
    public func getBundlePath(resource:String, type:String) ->String? {
        return Bundle.main.path(forResource: resource, ofType: type)
    }
}

extension JSONDecoder {
    public func decodeSafely<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
        do {
            let object = try decode(type, from: data)
            return object
        } catch let DecodingError.dataCorrupted(context) {
            Logger.log(message: context, event: .error)
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.log(message: "Key '\(key)' not found:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.log(message: "Value '\(value)' not found:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.log(message: "Type '\(type)' mismatch:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch {
            Logger.log(message: "error: ", error, event: .error)
        }
        return nil
    }
}

extension KeyedDecodingContainer {
    public func decodeSafely<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) -> T? where T: Decodable {
        do {
            let object = try decode(type, forKey: key)
            return object
        } catch let DecodingError.dataCorrupted(context) {
            Logger.log(message: context, event: .error)
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.log(message: "Key '\(key)' not found:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.log(message: "Value '\(value)' not found:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.log(message: "Type '\(type)' mismatch:", context.debugDescription, event: .error)
            Logger.log(message: "codingPath:", context.codingPath, event: .error)
        } catch {
            Logger.log(message: "error: ", error, event: .error)
        }
        return nil
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension UIImageView {
    func downloadImage(imageURL: String, contentMode: ContentMode = .scaleAspectFill, completion: ((Bool) -> Void)? = nil) {
        image = UIImage(named: "placeholder")
        self.contentMode = .scaleAspectFit
        let options: KingfisherOptionsInfo? = [.memoryCacheExpiration(.expired), .diskCacheExpiration(.days(5))]
        var fileURL = imageURL
        if fileURL.contains(" ") {
            fileURL = fileURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fileURL
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            self.layoutIfNeeded()
            fileURL += "?impolicy=resize&w=\(self.frame.width*2)&h=\(self.frame.height*2)"
            let url = URL(string: fileURL)
            self.kf.setImage(with: url, options: options) { (result) in
                switch result {
                case .success(let value):
                    self.image = value.image
                    self.contentMode = contentMode
                    completion?(true)
                case .failure(let error):
                    self.image = UIImage(named: "placeholder")
                    completion?(false)
                    Logger.log(message: "Coudn't download image ---> \(fileURL), because \(error)",
                               event: .debug)
                }
            }
        })
    }
}
