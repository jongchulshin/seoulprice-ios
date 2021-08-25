//
//  SplashViewController.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/06/29.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Thread.sleep(forTimeInterval: 1.0)
        
        //let homeViewModel = HomeViewModel()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        self.addViewController(homeViewController)
    }
}
