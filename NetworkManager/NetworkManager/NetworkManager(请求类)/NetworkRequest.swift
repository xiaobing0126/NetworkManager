//
//  NetworkRequest.swift
//  RichCredit_iOS
//
//  Created by Bing on 2017/11/1.
//  Copyright © 2017年 Bing. All rights reserved.
//

import UIKit
import Alamofire

// 网络状态
enum NetworkStatus : Int {
    
    case StatusNotReach     // 没网
    
    case StatusUnknow       // 未知
    
    case StatusWWan         // 手机网络
    
    case StatusWiFi         // WIFI
    
}


// final关键字这个类或方法不希望被重写
final class NetworkRequest: NSObject {

    // 创建单例
    static let sharedInstance : NetworkRequest = {
        
        let NetworkRequestInstance = NetworkRequest()
        
        return NetworkRequestInstance
        
    }()
    
}

extension NetworkRequest {
    
    
    /// POST请求
    func postRequest(urlString: String, params: [String : Any], success: @escaping(_ response: [String : AnyObject]) -> (), failture: @escaping(_ error: Error) -> ()) {
        
        let window = UIApplication.shared.keyWindow
        MyMBProgressHUD.showProgress(nil, in: window)
        
        // 请求之前先检测网络状态
        monitorNetworkStatus { (status) in
            
            DLog(message: "当前网络状态 ======== " + "\(status)")
            
            if status == .StatusNotReach {
                
                MyMBProgressHUD.showMessage("无网络连接", in: window)
                
            }
            
            
        }
        
        
        // 使用Alamofire进行网络请求时，调用该方法的参数都是通过getRequest(urlString, params, success:, failure:)传入的，而success传入的其实是一个接受[String : AnyObject]类型， 返回void类型的函数
        
        let url = Baseurl + urlString

        let header : HTTPHeaders = ["application/json" : "Content-type"]
        
        // 设置请求超时时长
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        manager.session.configuration.timeoutIntervalForResource = 15
        
        
        manager.request( url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in

            DLog(message: "请求的内容" + "\(String(describing: response.request))")

            DLog(message: "返回的内容" + "\(String(describing: response.response))")

            switch response.result {

            case .success:

                if let value = response.result.value as? [String : AnyObject] {

                    success(value)

                }

            case .failure(let error):

                failture(error)


            }
            
        }
        
    }
    
    
    /// 图片上传
    func uploadPost(urlString: String, params: [String : Any], data: [Data], success: @escaping(_ respnse: [String : AnyObject]) -> (), failture: @escaping(_ error: Error) -> ()) {
        
        let header : HTTPHeaders = ["application/json" : "Content-type"]
        
        let url = Baseurl + urlString

        DLog(message: "请求的网关地址 ============= " + "\(url)")
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            /**
                 data         : 图片或视频二进制数据
                
                 name         : 对应服务器的字段名
                
                 fileName     : 文件名，后缀要跟文件类型一致，不能为空，这个根据是UIImageJPEGRepresentation还是UIImagePNGRepresentation压缩来
                
                 mimeType     : 文件类型，比如image/pngvideo/quicktime
             */
            
//            multipartFormData.append(data[0], withName: "file", fileName: "idCardPicFront.jpg", mimeType: "image/jpeg")

            
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: header) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if let value = response.result.value as? [String : AnyObject] {
                        
                        success(value)
                        
                    }
                    
                }
                
            case .failure(let error):
                
                failture(error)
                
                
            }
            
        }
        
    }
    
    
    
    // 监听网络状态
    func monitorNetworkStatus(netStatus: @escaping(NetworkStatus) -> ()) {
        
        
        var manager : NetworkReachabilityManager?
        
        manager = NetworkReachabilityManager.init(host: "www.baidu.com")

        manager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                
                netStatus(.StatusNotReach)
                
            case .unknown:
                
                netStatus(.StatusUnknow)
                
            case .reachable(.ethernetOrWiFi):
                
                netStatus(.StatusWiFi)
                
            case .reachable(.wwan):
                
                netStatus(.StatusWWan)
                
            }
  
        }
        manager?.startListening()
        
    }
    
}















