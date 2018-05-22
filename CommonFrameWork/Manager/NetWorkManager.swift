//
//  NetWorkManager.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import Alamofire

protocol APIDelegate {
    func complete(result: AnyObject)
    func failed(error: NSError)
}

class NetWorkManager: NSObject {
    static let instance = NetWorkManager()

    private override init() {
    }

    
    func networkCheck()->Bool{
        // シングルトン
        if Connectivity.isConnectedToInternet {
            print("ネットワーク利用できます")
            return true
        // do some tasks..
        }else{
            print("ネットワーク利用できます")
            return false
        }
    }

    //GET
    func getRequestWithURL(path :String,parameter:[String: AnyObject]?, success: @escaping (_ result: AnyObject) -> Void ,failure: @escaping (_ error: Error) -> Void ) -> Void {
//        if (!networkCheck()){
//            let error =  NSError(domain: "ネットワーク接続できません！！！",code: -1,userInfo: nil)
//            failure(error)
//            return;
//        }

        Alamofire.request(path, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in

            if response.error != nil {
                failure(response.error!)
                return;
            }
            //エラーの判断処理
            let message : String
            let httpStatusCode = response.response?.statusCode
                //var error = kill
                switch(httpStatusCode) {
                case 400:
                    message = "サービス存在してない"
                    let error =  NSError(domain: message,code: httpStatusCode!,userInfo: nil)
                    failure(error as Error)
                case 401:
                    message = "サーバーにアクセスできません"
                    let error =  NSError(domain: message,code: httpStatusCode!,userInfo: nil)
                    failure(error)
                default:
                    message = "OK"
                }
            //JSONの解析処理
            success((response.data! as AnyObject) )
            return
        }
    }
    
    //POST
    func postRequestWithURL(path :String,parameter:[String: AnyObject]?, complection: @escaping (_ result: [String: AnyObject]) -> Void,failure: @escaping (_ error: Error) -> Void  ) -> Void {
        Alamofire.request(path, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.error != nil {
                failure(response.error!)
                return;
            }
            
            if let JSON = response.result.value {
                complection(JSON as! [String: AnyObject])
            }
            
            return
        }
    }
    // delete、put
    //TODO
}

