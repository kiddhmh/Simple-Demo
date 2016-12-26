//
//  MHURLProtocol.swift
//  NSURLProtocol-webView
//
//  Created by 胡明昊 on 16/12/26.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import Foundation

private let CacheURLHeader: String = "CacheURLProtocolCache"
private var CachingSupportSchemes: Set<String>?
private let URLProtocolHandleKey = "URLprotocolHandleKey"
private let CacheURLStringKey = "CacheURLStringKey" // 本地保存缓存urlKey的数组key


class MHURLProtocol: URLProtocol {
    
    fileprivate lazy var cacheModel: MHCacheModel = MHCacheModel()
    fileprivate var data: Data?
    fileprivate var response: URLResponse?
    fileprivate var connection: NSURLConnection?
    
    
    open override class func initialize() {
        CachingSupportSchemes = Set<String>(["http","https"])
    }
    
    
    open override class func canInit(with request: URLRequest) -> Bool {
        
        if CachingSupportSchemes?.contains(request.url?.scheme ?? "") == true && request.value(forHTTPHeaderField: CacheURLHeader) == nil {
            
            //看看是否已经处理过了，防止无限循环
            if URLProtocol.property(forKey: URLProtocolHandleKey, in: request) != nil {
                return false
            }
            
            return true
        }
        return false
    }
    
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    /// 开始加载时自动调用
    override func startLoading() {
        
        //打标签，防止无限循环
        let request = self.request as NSURLRequest
        URLProtocol.setProperty(true, forKey: URLProtocolHandleKey, in: request.mutableCopy() as! NSMutableURLRequest)
        
        // 加载本地
        let cacheModel = MHCache.shareInstance.object(forKey: request.url?.absoluteString.md5() ?? "") as? MHCacheModel
        
        if useCache() && cacheModel == nil { // 可到达(有网)而且无缓存  才重新获取
            loadRequest()
        }else if cacheModel != nil { // 有缓存
            loadCacheData(cacheModel)
        }else { // 没网  没缓存
            print("没网没缓存")
        }
        
    }
    
    
    override func stopLoading() {
        connection?.cancel()
    }
    
    /// 获取最新数据
    private func loadRequest() {
        
        var connectionRequest = request
        connectionRequest.setValue("", forHTTPHeaderField: CacheURLHeader)
        connection = NSURLConnection(request: connectionRequest, delegate: self)
    }
    
    
    /// 获取当前网络状态
    private func useCache() -> Bool {
        let reachable = Reachability(hostName: request.url?.host).currentReachabilityStatus() != NotReachable
        return reachable
    }
    
    
    /// 加载本地缓存数据
    private func loadCacheData(_ cacheModel: MHCacheModel?) {
        
        guard let cacheModel = cacheModel else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil))
            return
        }
        
        let data = cacheModel.data
        let response = cacheModel.response
        let redirectRequest = cacheModel
        .redirectRequest
        
        guard redirectRequest != nil else {
            
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            client?.urlProtocol(self, didLoad: data!)
            client?.urlProtocolDidFinishLoading(self)
            
            print("直接使用缓存------缓存url=\(request.url?.absoluteString)")
            return
        }
        
        client?.urlProtocol(self, wasRedirectedTo: redirectRequest!, redirectResponse: response!)
        print("重定向")
    }
    
    
    /// 存储缓存数据
    fileprivate func cacheDataWith(response: URLResponse?, redirectRequest: URLRequest?) {
        
        cacheModel.response = response
        cacheModel.data = data
        cacheModel.redirectRequest = redirectRequest
        
        let cacheStringkey = request.url?.absoluteString.md5() ?? ""
        MHCache.shareInstance.setObject(cacheModel, forKey: cacheStringkey) { 
            
            // 注意 这里加载.css   jpg 等资源路径的时候，这个类已经更新了（即数组加urlkey数组的时候，不能在当前类一直加，而是先从本地取了之后再加）
            var array = UserDefaults.standard.object(forKey: CacheURLStringKey) as? [String]
            if array == nil {
                array = []
            }
            
            array?.append(cacheStringkey)
            UserDefaults.standard.set(array, forKey: CacheURLStringKey)
            print("重置了缓存 key == CacheUrlStringKey")
            print("新增了缓存key \(cacheStringkey)===当前缓存个数\(array?.count)")
        }
    }
    
    
    /// 拼接数据
    fileprivate func appendData(_ newData: Data) {
        
        if data == nil {
            data = newData
        }else {
            data?.append(newData)
        }
    }
}


extension MHURLProtocol: NSURLConnectionDelegate {
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        appendData(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.response = response
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        client?.urlProtocolDidFinishLoading(self)
        
        /// 自己项目设置的逻辑  即是服务器版本号 > 本地版本号   则需要刷新
        /// 先移除之前的缓存，在缓存新的。。对吧 这里逻辑看情况而定
        //    if ([SCYLoanUrlType() isEqualToString:@"1"] && SCYLoanSerViceVersion().integerValue > SCYLoanLocalVersion().integerValue) { // 缓存最新的时候  移除之前  loacalVersion  localUrl
        //        [[SCYLoanHTMLCache defaultcache] removeAllObjects];
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CacheUrlStringKey];
        //        NSLog(@"刷新网页成功.........");
        //    }
        
        /// 有缓存则不缓存
        let cacheModel = MHCache.shareInstance.object(forKey: request.url?.absoluteString.md5() ?? "")
        if cacheModel == nil {
            cacheDataWith(response: response, redirectRequest: nil)
        }
    }
    
}


extension MHURLProtocol: NSURLConnectionDataDelegate {
    
    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        
        guard let response = response else {
            return request
        }
        
        var redirectableRequest = request
        redirectableRequest.setValue(nil, forHTTPHeaderField: CacheURLHeader)
        
        cacheDataWith(response: response, redirectRequest: redirectableRequest)
        
        client?.urlProtocol(self, wasRedirectedTo: redirectableRequest, redirectResponse: response)
        return redirectableRequest
    }
}
