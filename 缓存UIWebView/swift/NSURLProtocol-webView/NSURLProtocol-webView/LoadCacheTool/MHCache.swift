//
//  MHCache.swift
//  NSURLProtocol-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

private let CacheName = "MHCacheName"
/// 单例
class MHCache: YYCache {
    
    static var shareInstance: MHCache {
        struct MyStatic {
            static var instance: MHCache = MHCache(name: CacheName)!
        }
        
        return MyStatic.instance
    }
    
}
