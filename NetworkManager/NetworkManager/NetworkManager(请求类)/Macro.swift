//
//  Macro.swift
//  NetworkManager
//
//  Created by Bing on 2017/11/7.
//  Copyright © 2017年 Bing. All rights reserved.
//



import UIKit

/**
 *  打印
 *
 *  parameter   T           :打印的信息
 *  parameter   methodName  :方法名
 *  parameter   file        :文件名
 *  parameter   lineNumber  :代码所在行数
 */
func DLog<T>(message : T, methodName : String = #function, file : String = #file, lineNumber : Int = #line){
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName) : method : \(methodName) : line : \(lineNumber)] - \(message)")
        
    #endif
    
}

let Baseurl = "http://192.168.104.88:1200/" 

