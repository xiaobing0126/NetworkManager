//
//  HomeViewController.swift
//  NetworkManager
//
//  Created by Bing on 2017/11/7.
//  Copyright © 2017年 Bing. All rights reserved.
//

import UIKit
import SwiftyJSON


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLogin()
        
    }
    
    // MARK: 请求登录
    func requestLogin() {
        
        var parameters              = [String : Any]()
        parameters["mobile"]        = "13333333333"
        parameters["password"]      = "aaaaaa"
        NetworkRequest.sharedInstance.postRequest(urlString: "app/fkd/login", params: parameters, success: { (response) in
            
            MyMBProgressHUD.hide()
            let obj = JSON.init(response)
            DLog(message: "登录请求数据 ================ " + "\(obj)")
            
        }) { (error) in
            
            MyMBProgressHUD.showMessageWithoutView("请求超时")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

   
    

}
