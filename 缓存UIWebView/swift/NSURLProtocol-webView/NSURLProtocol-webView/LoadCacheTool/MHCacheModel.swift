//
//  MHCacheModel.swift
//  NSURLProtocol-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHCacheModel: NSObject,NSCoding {
    
    var data: Data?
    var response: URLResponse?
    var redirectRequest: URLRequest?
    
    /// 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
        aCoder.encode(response, forKey: "response")
        aCoder.encode(redirectRequest, forKey: "redirectRequest")
    }
    
    
    /// 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        data = aDecoder.decodeObject(forKey: "data") as! Data?
        response = aDecoder.decodeObject(forKey: "response") as! URLResponse?
        redirectRequest = aDecoder.decodeObject(forKey: "redirectRequest") as! URLRequest?
    }
    
    
    override init() {
        super.init()
    }
}
