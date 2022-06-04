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
        
        //TODO: 여기서하면 안됨. 스플레시 이미지가 나온 후에 1초 대기
        //Thread.sleep(forTimeInterval: 1.0)
        
        //let homeViewModel = HomeViewModel()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        self.addViewController(homeViewController)
    }
}
