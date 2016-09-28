//
//  ViewController.swift
//  QRCodeScanerDemo
//
//  Created by wangshiyu13 on 16/3/28.
//  Copyright © 2016年 wangshiyu13. All rights reserved.
//

import UIKit
import HLQRCodeScanner

class ViewController: UIViewController {

    func scan() {
        let qr = HLQRCodeScanner.scanner { (str) in
            debugPrint(str)
        }
        show(qr, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(self.scan), for: .touchUpInside)
        view.addSubview(button)
        
        button.setImage(HLQRCodeScanner.createQRCodeImage("http://www.baidu.com"), for: UIControlState())
    }
}
