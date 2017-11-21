//
//  ViewController.swift
//  ExchangeLabel
//
//  Created by sischen on 2017/11/21.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exview = CCExchangeView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
        exview.exchangeImgv.image = #imageLiteral(resourceName: "exchange-icon")
        exview.labelTextFont = UIFont.systemFont(ofSize: 19)
        exview.labelTextColor = UIColor.blue
        self.view.addSubview(exview)
        
        exview.fromText = "北京市"
        exview.toText   = "广西自治区"
    }

}

