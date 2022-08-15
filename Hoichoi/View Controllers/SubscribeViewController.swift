//
//  SubscribeViewController.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 14/08/22.
//

import UIKit

class SubscribeViewController: UIViewController {

    @IBOutlet weak private var viewBasic: UIView!
    @IBOutlet weak private var viewGradient: UIView!
    @IBOutlet weak private var viewPreminum: UIView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var buttonContinue: UIButton!
    @IBOutlet weak private var viewPosterGradient: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setAnimation()
    }
    @IBAction func actionOnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func actionOnContinue(_ sender: UIButton) {
        sender.scaleAnimation()
    }
    private func setStyle() {
        scrollView.contentInset = .init(top: -45, left: 0, bottom: 120, right: 0)
        viewPreminum.layer.borderColor = UIColor(named: "cherry_red")?.cgColor
        viewPreminum.layer.borderWidth = 2
        viewPreminum.layer.cornerRadius = 25
        viewPreminum.layer.masksToBounds = true
        viewBasic.layer.borderColor = UIColor(named: "dark_grey")?.cgColor
        viewBasic.layer.borderWidth = 2
        viewBasic.layer.cornerRadius = 25
        viewBasic.layer.masksToBounds = true
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = viewGradient.frame.size
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.masksToBounds = true
        gradientLayer.colors = [UIColor(named: "cherry_red")!.cgColor, UIColor(named: "w_blue")!.cgColor]
        viewGradient.layer.addSublayer(gradientLayer)
        viewGradient.layer.cornerRadius = 18
        viewGradient.layer.masksToBounds = true
        
        let posterGradientLayer: CAGradientLayer = CAGradientLayer()
        posterGradientLayer.frame.size = viewPosterGradient.frame.size
        posterGradientLayer.startPoint = CGPoint(x: 1, y: 1)
        posterGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        posterGradientLayer.masksToBounds = true
        posterGradientLayer.colors = [UIColor(named: "dark")!.cgColor, UIColor(named: "dark")!.withAlphaComponent(0).cgColor]
        viewPosterGradient.layer.addSublayer(posterGradientLayer)
    }
    private func setAnimation() {
        buttonContinue.frame.origin.y += 100
        buttonContinue.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: [.allowUserInteraction], animations: {
            self.buttonContinue.frame.origin.y -= 100
            self.buttonContinue.alpha = 1
        })
    }
}
