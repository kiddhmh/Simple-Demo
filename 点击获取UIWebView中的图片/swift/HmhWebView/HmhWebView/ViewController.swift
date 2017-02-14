//
//  ViewController.swift
//  HmhWebView
//
//  Created by 胡明昊 on 17/2/8.
//  Copyright © 2017年 ccic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = UIWebView(frame: view.frame)
        view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com")!))
        webView.delegate = self
        
        webView.mh_didClickImageCall { (URLString) in
            print("图片地址 === \(URLString)")
        }
    }

}

extension ViewController: UIWebViewDelegate {
    
    
    
}
