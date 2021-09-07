//
//  HomeViewController.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/08/10.
//

import UIKit

class HomeViewController: UIViewController {

    //Loading status view
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var loadingStatusLabel: UILabel!
    
    //Main scroll view
    @IBOutlet var scrollView: UIScrollView!
    
    //Main button
    var mainButtonView1: HomeMainButtonView!
    var mainButtonView2: HomeMainButtonView!
    var mainButtonView3: HomeMainButtonView!
    var mainButtonView4: HomeMainButtonView!
    
    //View model
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        self.mainButtonView1 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView1)
        
        self.mainButtonView2 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView2)
        
        self.mainButtonView3 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView3)
        
        self.mainButtonView4 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView4)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 16.0
        let buttonViewHeight: CGFloat = 140.0
        let largeButtonViewWidth = self.scrollView.frame.width - margin * 2
        let smallButtonViewWidth = (self.scrollView.frame.width - margin * 3) / 2
        
        self.mainButtonView1.frame = CGRect(x: margin, y: margin, width: largeButtonViewWidth, height: buttonViewHeight)
        self.mainButtonView2.frame = CGRect(x: margin, y: self.mainButtonView1.frame.maxY + margin, width: largeButtonViewWidth, height: buttonViewHeight)
        
        self.mainButtonView3.frame = CGRect(x: margin, y: self.mainButtonView2.frame.maxY + margin, width: smallButtonViewWidth, height: buttonViewHeight)
        self.mainButtonView4.frame = CGRect(x: self.scrollView.frame.maxX - margin - smallButtonViewWidth, y: self.mainButtonView2.frame.maxY + margin, width: smallButtonViewWidth, height: buttonViewHeight)
        
        let contentHeight = self.mainButtonView4.frame.maxY + margin
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: contentHeight)
    }
}
