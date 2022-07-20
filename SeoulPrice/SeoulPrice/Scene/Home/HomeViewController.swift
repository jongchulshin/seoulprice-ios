//
//  HomeViewController.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/08/10.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()

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
        self.viewModel = HomeViewModel()
        
        self.mainButtonView1 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView1)
        
        self.mainButtonView2 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView2)
        
        self.mainButtonView3 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView3)
        
        self.mainButtonView4 = HomeMainButtonView()
        self.scrollView.addSubview(self.mainButtonView4)
        
        viewModel.activated
            .map { !$0 }
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            let margin: CGFloat = 8.0
            let buttonViewHeight: CGFloat = 140.0
            let largeButtonViewWidth = self.scrollView.frame.width - margin * 2
            let smallButtonViewWidth = (self.scrollView.frame.width - margin * 4) / 2
            
            self.mainButtonView1.frame = CGRect(x: margin, y: margin, width: largeButtonViewWidth, height: buttonViewHeight)
            self.mainButtonView2.frame = CGRect(x: margin, y: self.mainButtonView1.frame.maxY + margin * 2, width: largeButtonViewWidth, height: buttonViewHeight)
            
            self.mainButtonView3.frame = CGRect(x: margin, y: self.mainButtonView2.frame.maxY + margin * 2, width: smallButtonViewWidth, height: buttonViewHeight)
            self.mainButtonView4.frame = CGRect(x: self.mainButtonView3.frame.maxX + margin * 2, y: self.mainButtonView2.frame.maxY + margin * 2, width: smallButtonViewWidth, height: buttonViewHeight)
            
            let contentHeight = self.mainButtonView4.frame.maxY + margin * 2
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: contentHeight)
        }
    }
}
