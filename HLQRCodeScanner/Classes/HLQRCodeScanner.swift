//
//  QRScanViewController.swift
//  lovek12
//
//  Created by 汪诗雨 on 15/10/25.
//  Copyright © 2015年 manyi. All rights reserved.
//

import UIKit

open class HLQRCodeScanner: UIViewController {
    
    /// 扫描二维码，handle回调内返回扫描结果
    /// 返回值为QRCodeScanner类型对象
    open class func scanner(_ handle: @escaping (String) -> ()) -> HLQRCodeScanner {
        let sc = HLQRCodeScanner()
        weak var weakSC = sc
        weakSC?.scanImageFinished = handle
        weakSC?.scanner.prepareScan(sc.view) {
            weakSC?.dissmissVC()
            handle($0)
        }
        return sc
    }
    
    /// 创建二维码图片
    /// 参数：字符串，内嵌图片，内嵌占比，二维码前景色，二维码后景色
    /// 返回值为UIImage?
    open class func createQRCodeImage(_ withStringValue: String, avatarImage: UIImage? = nil, avatarScale: CGFloat? = nil, color: CIColor = CIColor(color: UIColor.black), backColor: CIColor = CIColor(color: UIColor.white)) -> UIImage? {
        return QRCode.generateImage(withStringValue, avatarImage: avatarImage, avatarScale: avatarScale ?? 0.25, color: color, backColor: backColor)
    }
    
    fileprivate var scanImageStringValue: String? {
        didSet {
            if let value = scanImageStringValue {
                scanImageFinished!(value)
            }
        }
    }
    
    fileprivate var scanImageFinished: ((String) -> ())?
    
    fileprivate let scanner = QRCode()
    
    fileprivate var animating = true
    
    /// MARK: - UI布局
    fileprivate lazy var scanViewHeight: CGFloat = {
        return self.view.frame.width * 0.75
    }()
    
    fileprivate lazy var backgroundView: UIView = {
        self.view.layoutIfNeeded()
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        aView.backgroundColor = UIColor.clear
        let cropLayer = CAShapeLayer()
        aView.layer.addSublayer(cropLayer)
        let path = CGMutablePath()
        
        let cropRect = CGRect(x: (aView.frame.width - self.scanViewHeight) * 0.5, y: (aView.frame.height - self.scanViewHeight) * 0.5, width: self.scanViewHeight, height: self.scanViewHeight)
        path.addRect(aView.bounds)
        path.addRect(cropRect)
        cropLayer.fillRule = kCAFillRuleEvenOdd
        cropLayer.path = path
        cropLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        return aView
    }()
    
    fileprivate lazy var photoButton: UIButton = {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "HLQRCodeScanner", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
        let button = UIButton(type: .custom)
        button.setImage(self.imageWithName("ScanPhoto", bundle: imageBundle!), for: UIControlState())
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(self.clickAlbumButton), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    fileprivate lazy var torchButton: UIButton = {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "HLQRCodeScanner", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
        let button = UIButton(type: .custom)
        button.setImage(self.imageWithName("ScanTorch", bundle: imageBundle!), for: UIControlState())
        button.setImage(self.imageWithName("ScanTorch_selected", bundle: imageBundle!), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(self.torchClick), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    fileprivate lazy var descLabel: UILabel = {
        let descLabel = UILabel(frame: CGRect.zero)
        descLabel.text = "将二维码放入框内，即可自动扫描"
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = UIColor.white
        descLabel.sizeToFit()
        descLabel.center = self.view.center
        return descLabel
    }()
    
    fileprivate lazy var scanView: UIView = {
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.scanViewHeight, height: self.scanViewHeight))
        aView.center = self.view.center
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "HLQRCodeScanner", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
        let imageView1 = UIImageView(image: self.imageWithName("ScanQR1", bundle: imageBundle!))
        let imageView2 = UIImageView(image: self.imageWithName("ScanQR2", bundle: imageBundle!))
        let imageView3 = UIImageView(image: self.imageWithName("ScanQR3", bundle: imageBundle!))
        let imageView4 = UIImageView(image: self.imageWithName("ScanQR4", bundle: imageBundle!))
        
        imageView1.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        imageView2.frame = CGRect(x: aView.frame.width - 16, y: 0, width: 16, height: 16)
        imageView3.frame = CGRect(x: 0, y: aView.frame.height - 16, width: 16, height: 16)
        imageView4.frame = CGRect(x: aView.frame.width - 16, y: aView.frame.height - 16, width: 16, height: 16)
        aView.addSubview(imageView1)
        aView.addSubview(imageView2)
        aView.addSubview(imageView3)
        aView.addSubview(imageView4)
        aView.addSubview(self.lineImage)
        aView.backgroundColor = UIColor.clear
        
        self.descLabel.frame.origin.y = aView.frame.maxY + 8
        //self.torchButton.center = CGPoint(x: self.view.frame.width / 3, y: aView.frame.origin.y - 32)
        //self.photoButton.center = CGPoint(x: self.view.frame.width / 3 * 2, y: aView.frame.origin.y - 32)
        self.view.addSubview(self.descLabel)
        return aView
    }()
    
    fileprivate lazy var lineImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.scanViewHeight, height: 15))
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "HLQRCodeScanner", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        imageView.image = self.imageWithName("QRCodeScanLine", bundle: imageBundle!)
        return imageView
    }()
    
    /// MARK: - 点击事件
    fileprivate func dissmissVC() {
        if (self.navigationController?.responds(to: #selector(self.navigationController?.popViewController(animated:))) != nil) {
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func torchClick() {
        let _ = scanner.openTorch()
        torchButton.isSelected = !torchButton.isSelected
    }
    
    @objc fileprivate func clickAlbumButton() {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            descLabel.text = "无法访问相册"
            return
        }
        
        let picker = UIImagePickerController()
        
        picker.view.backgroundColor = UIColor.white
        picker.delegate = self
        
        showDetailViewController(picker, sender:nil)
    }
    
    /// 初始化方法
    fileprivate func setupSubviews() {
        view.backgroundColor = UIColor.white
        view.addSubview(backgroundView)
        view.addSubview(scanView)
    }
    
    fileprivate func setupScaner() {
        scanner.scanFrame = scanView.frame
        scanner.autoRemoveSubLayers = true
    }
    
    @objc fileprivate func lineMoveAnimate() {
        if animating {
            UIView.animate(withDuration: 2.5, animations: {
                self.lineImage.frame.origin.y = self.scanView.frame.height - 16
            }, completion: { (finished) -> Void in
                self.lineImage.frame.origin.y = 0
                self.lineMoveAnimate()
            }) 
        }
    }
    
    /// MARK: - 生命周期方法
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "二维码"
        setupSubviews()
        setupScaner()
        lineMoveAnimate()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanner.startScan()
        animating = true
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scanner.stopScan()
        animating = false
    }
    
    fileprivate func imageWithName(_ named: String, bundle: Bundle) -> UIImage? {
        let filename = "\(named)@2x"
        let path = bundle.path(forResource: filename, ofType: "png")
        return UIImage(contentsOfFile: path!)?.withRenderingMode(.alwaysOriginal)
    }
    
    deinit {
        debugPrint("deinit")
    }
}

extension HLQRCodeScanner: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            weak var weakSC = self
            weakSC?.scanner.scanImage(image) {
                if ($0.count > 0) {
                    weakSC?.scanImageStringValue = $0.first
                    picker.dismiss(animated: false) {
                        if ((weakSC?.navigationController?.responds(to: #selector(weakSC?.navigationController?.popViewController(animated:)))) != nil) {
                            let _ = weakSC?.navigationController?.popViewController(animated: true)
                        } else {
                            weakSC?.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    weakSC?.descLabel.text = "没有识别到二维码，请选择其他照片"
                    weakSC?.descLabel.sizeToFit()
                    picker.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
