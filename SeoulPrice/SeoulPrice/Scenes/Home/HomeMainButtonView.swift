//
//  HomeMainButton.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/09/06.
//

import UIKit

class HomeMainButtonView: UIView {

    //TODO: 타이틀, 이미지
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
