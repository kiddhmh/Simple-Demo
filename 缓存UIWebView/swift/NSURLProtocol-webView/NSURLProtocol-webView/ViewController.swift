//
//  ViewController.swift
//  NSURLProtocol-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLProtocol.registerClass(MHURLProtocol.self)
        webView.loadRequest(URLRequest(url: URL(string: "http://blog.csdn.net/hmh007/article/details/53837859")!))
        
        /// 不需要缓存的url，取消注册，即不回走urlprotocol机制了
//        URLProtocol.unregisterClass(MHURLProtocol.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

