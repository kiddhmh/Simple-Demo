//
//  MHWebView.swift
//  HmhWebView
//
//  Created by 胡明昊 on 17/2/8.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

extension UIWebView: UIGestureRecognizerDelegate {
    
    public typealias MHClickImageCloSure = (_ URLString: String) -> Void
    
    private struct AssociatedKeys {
        static var mh_clickImageKey: MHClickImageCloSure?
        static var mh_imageStringKey: String?
        static var mh_isClickImageKey: NSNumber?
        static var mh_customTapKey: UITapGestureRecognizer?
    }
    
    public var mh_clickImage: MHClickImageCloSure {
        
        get {
        return objc_getAssociatedObject(self, &AssociatedKeys.mh_clickImageKey) as! MHClickImageCloSure
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.mh_clickImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    public var mh_imageString: String? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.mh_imageStringKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.mh_imageStringKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    
    public var mh_isClickImage: NSNumber? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.mh_isClickImageKey) as? NSNumber
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.mh_isClickImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    public var mh_customTap: UITapGestureRecognizer? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.mh_customTapKey) as? UITapGestureRecognizer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.mh_customTapKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
    // 点击图片回调，返回字符串
    public func mh_didClickImageCall(clickImage: @escaping MHClickImageCloSure) {
        
        let gesture = UITapGestureRecognizer.init(target: nil, action: nil)
        addGestureRecognizer(gesture)
        gesture.delegate = self
        mh_customTap = gesture
        mh_clickImage = clickImage
    }

    
    //GestureRecognizer  delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            if gestureRecognizer == mh_customTap {
                let touchPoint = touch.location(in: self)
                let imgURL = "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"
                let URLString = stringByEvaluatingJavaScript(from: imgURL)
                mh_isClickImage = false
                if URLString != nil && !URLString!.isEmpty {
                    mh_isClickImage = true
                    mh_imageString = URLString
                }
            }
        }
        return true
    }
    
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == mh_customTap {
            
            guard let imageString = mh_imageString, let isClick = mh_isClickImage?.boolValue, isClick == true else { return false }
            mh_clickImage(imageString)
            mh_imageString = nil
            
            return false
        }
        return true
    }
    
}
