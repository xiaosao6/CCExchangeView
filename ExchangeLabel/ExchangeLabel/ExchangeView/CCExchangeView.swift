//
//  CCExchangeView.swift
//
//  Created by sischen on 2017/11/21.
//  Copyright © 2017年 .com. All rights reserved.
//

import UIKit


/// 交换View协议
@objc protocol CCExchangeProtocol : NSObjectProtocol {
    @objc optional  func labelClicked(_ view: CCExchangeView, isFrom:Bool) -> ()
    @objc optional  func exchangeDidFinish(_ view: CCExchangeView) -> ()
}


/// 交换View
class CCExchangeView: UIView {
    
    /// 动画时长
    var animDuration = 0.5
    /// 左右边距
    fileprivate var LR_gap : CGFloat = 0
    
    weak var delegate : CCExchangeProtocol?
    
    var fromText : String? {
        get{ return fromLabel.text }
        set{ fromLabel.text = newValue }
    }
    
    var toText : String? {
        get{ return toLabel.text }
        set{ toLabel.text = newValue }
    }
    
    var labelTextColor : UIColor {
        get{ return fromLabel.textColor }
        set{
            fromLabel.textColor = newValue
            toLabel.textColor = newValue
        }
    }
    var labelTextFont : UIFont {
        get{ return fromLabel.font }
        set{
            fromLabel.font = newValue
            toLabel.font = newValue
        }
    }
    
    fileprivate lazy var fromLabel : UILabel = {
        let tmp = UILabel.init()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.systemFont(ofSize: 20)
        tmp.textAlignment = .center
        tmp.isUserInteractionEnabled = true
        tmp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(fromlabelTapped)))
        return tmp
    }()
    
    fileprivate lazy var toLabel : UILabel = {
        let tmp = UILabel.init()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.systemFont(ofSize: 20)
        tmp.textAlignment = .center
        tmp.isUserInteractionEnabled = true
        tmp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tolabelTapped)))
        return tmp
    }()
    
    lazy var exchangeImgv : UIImageView = {
        let tmp = UIImageView.init()
//        tmp.backgroundColor = UIColor.lightGray
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.isUserInteractionEnabled = true
        tmp.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(exchageClick)))
        return tmp
    }()
    
    //MARK: ------------------------ init
    override convenience init(frame: CGRect) {
        self.init(frame: frame, lr_gap: 15, imgSizePercent: 0.6)
    }
    
    init(frame: CGRect, lr_gap: CGFloat, imgSizePercent: CGFloat) {
        super.init(frame: frame)
        LR_gap = lr_gap
        
        let imgW = frame.size.height * imgSizePercent
        
        self.addSubview(fromLabel)
        let from_cons1 = NSLayoutConstraint.init(item: fromLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let from_cons2 = NSLayoutConstraint.init(item: fromLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let from_cons3 = NSLayoutConstraint.init(item: fromLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: LR_gap)
        let from_cons4 = NSLayoutConstraint.init(item: fromLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 0.5, constant: (-0.5*imgW - LR_gap))
        self.addConstraints([from_cons1, from_cons2, from_cons3, from_cons4])
        
        self.addSubview(exchangeImgv)
        let imgv_cons1 = NSLayoutConstraint.init(item: exchangeImgv, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let imgv_cons2 = NSLayoutConstraint.init(item: exchangeImgv, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let imgv_cons3 = NSLayoutConstraint.init(item: exchangeImgv, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imgW)
        let imgv_cons4 = NSLayoutConstraint.init(item: exchangeImgv, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imgW)
        self.addConstraints([imgv_cons1, imgv_cons2, imgv_cons3, imgv_cons4])
        
        self.addSubview(toLabel)
        let to_cons1 = NSLayoutConstraint.init(item: toLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let to_cons2 = NSLayoutConstraint.init(item: toLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let to_cons3 = NSLayoutConstraint.init(item: toLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -LR_gap)
        let to_cons4 = NSLayoutConstraint.init(item: toLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 0.5, constant: (-0.5*imgW - LR_gap))
        self.addConstraints([to_cons1, to_cons2, to_cons3, to_cons4])
        
        let lineW = 0.5 * (frame.width - imgW) - LR_gap
        
        let line1 = UIView.init(frame: CGRect.init(x: LR_gap, y: frame.height-0.5, width: lineW, height: 0.5))
        line1.backgroundColor = UIColor.lightGray
        self.addSubview(line1)
        
        let line2 = UIView.init(frame: CGRect.init(x: 0.5*(frame.width + imgW), y: frame.height-0.5, width: lineW, height: 0.5))
        line2.backgroundColor = UIColor.lightGray
        self.addSubview(line2)
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    //MARK: ------------------------ Event
    @objc func exchageClick() -> () {
        self.isUserInteractionEnabled = false  //动画过程中禁止交互
        DispatchQueue.main.asyncAfter(deadline: .now() + animDuration) {
            self.isUserInteractionEnabled = true
            self.delegate?.exchangeDidFinish?(self)
        }
        
        performLabelAnim()
        performImgvAnim()
    }
    
    @objc func fromlabelTapped() -> () {
        self.delegate?.labelClicked?(self, isFrom: true)
    }
    @objc func tolabelTapped() -> () {
        self.delegate?.labelClicked?(self, isFrom: false)
    }
    
    fileprivate func performLabelAnim() -> () {
        
        let label_l = copyLabelProp(rawLabel: getLabel(onLeft: true))
        self.addSubview(label_l)
        
        let label_r = copyLabelProp(rawLabel: getLabel(onLeft: false))
        self.addSubview(label_r)
        
        self.fromLabel.alpha = 0
        self.toLabel.alpha   = 0
        
        UIView.animate(withDuration: animDuration, animations: {
            var frame = label_l.frame
            frame.origin.x = (self.frame.maxX - self.LR_gap) - frame.size.width
            label_l.frame = frame
            
            label_r.frame.origin.x = self.frame.minX + self.LR_gap
        }) { (finished) in
            if !finished { return }
            
            label_l.removeFromSuperview()
            label_r.removeFromSuperview()
            
            let from = self.fromLabel.text
            self.fromLabel.text = self.toLabel.text
            self.toLabel.text = from
            
            self.fromLabel.alpha = 1
            self.toLabel.alpha   = 1
        }
    }
    
    fileprivate func performImgvAnim() -> () {
        let animKey = "rotation-layer"
        let imgvOriginaltag = 101
        let imgvRevesedtag  = 102
        
        let isReversed = (exchangeImgv.tag == imgvRevesedtag)
        
        let bAnim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        bAnim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        bAnim.duration = animDuration
        bAnim.fromValue = 0
        bAnim.toValue   = isReversed ? (-Double.pi) : Double.pi
        exchangeImgv.layer.add(bAnim, forKey: animKey)
        exchangeImgv.tag = isReversed ? imgvOriginaltag : imgvRevesedtag
    }
    
    
    //MARK: ------------------------ Private
    
    fileprivate func getLabel(onLeft:Bool) -> UILabel {
        let midX1 = fromLabel.frame.midX
        let midX2 = toLabel.frame.midX
        return onLeft && (midX1 < midX2) ? fromLabel : toLabel
    }
    
    fileprivate func copyLabelProp(rawLabel:UILabel) -> UILabel {
        let newLabel = UILabel.init(frame: rawLabel.frame)
        newLabel.text = rawLabel.text
        newLabel.font = rawLabel.font
        newLabel.textColor = rawLabel.textColor
        newLabel.textAlignment = rawLabel.textAlignment
        newLabel.backgroundColor = rawLabel.backgroundColor
        return newLabel
    }
}
