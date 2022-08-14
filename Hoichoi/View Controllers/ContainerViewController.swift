//
//  ViewController.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 30/07/22.
//

import UIKit

class ContainerViewController: UIViewController {
   
    @IBOutlet weak var viewContainer: UIView!
    var bottomBar: BottomBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBottomBar()
    }
    
    private func loadBottomBar() {
        let bar = BottomBar.add(on: self)
        bottomBar = bar
        view.bringSubviewToFront(bar)
        bottomBar?.selectTab(at: 0)
    }
}

