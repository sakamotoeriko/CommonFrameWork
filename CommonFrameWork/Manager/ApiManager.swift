//
//  NetWorkManager.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class  ApiManager: NSObject {
    static let instance = ApiManager()
    
    struct ArticleMode: Codable {
        let id: String
        let profile_image_url: String
        
    }

    private override init() {
    }

    private func networkCheck()->Bool{
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
    func getRequestWithURL(path :String,parameter:[String: AnyObject]?, success: @escaping (_ result: [String: AnyObject]) -> Void ,failure: @escaping (_ error: Error) -> Void ) -> Void {
        if (!networkCheck()){
            let error =  NSError(domain: "ネットワーク接続できません！！！",code: -1,userInfo: nil)
            failure(error)
            return;
        }
        
        Alamofire.request(path, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in

            if response.error != nil {
                failure(response.error!)
                return;
            }

            let message : String
            if let httpStatusCode = response.response?.statusCode
            {
                //var error = kill

                switch(httpStatusCode) {
                case 400:
                    message = "Username or password not provided."
                    let error =  NSError(domain: message,code: httpStatusCode,userInfo: nil)
                    failure(error as! Error)
                case 401:
                    message = "Incorrect password for user."
                    let error =  NSError(domain: message,code: httpStatusCode,userInfo: nil)
                    failure(error)
                default:
                    message = "OK"
                }
            } else {
                //message = response.error!
            }
            
           /* if let JSON = response.result.value {
                success(JSON as! [String: AnyObject])
            }*/
            
            let json = JSON(response.result.value)
            var article: [String: String?] = [:]
            
            json.forEach { (_, json) in
                article = [
                    "profile_image_url": json["profile_image_url"].string,
                    "id": json["id"].string
                ]
                //articles.append(article)
                success(article as [String: AnyObject])
            }
            
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

// 業務関連処理
extension ApiManager {
    func doLogout(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
    }
    
    func doLogin(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
    }
    
    func authorizationCheck(success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void ) {
        
    }

    //投稿データの取得処理
    func getArticle(parameter:Parameters,success: @escaping (_ result: [String: AnyObject]) -> Void , failure: @escaping (_ error: Error) -> Void) {
        //let parameter:Parameters = ["page":1, "per_page":"3"]
        
        getRequestWithURL(path: "https://qiita.com/api/v2/users",parameter:parameter as [String : AnyObject], success: success,failure: failure)
    }
    
    //アルバムデータの取得処理
    func getArticles(apiResponse: @escaping (_ responseArticles: [[String: String?]]) -> ()) {
        
        var articles: [[String: String?]] = []

        Alamofire.request("https://qiita.com/api/v2/items")
            .responseJSON { response in

                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                var article: [String: String?] = [:]
                
                json.forEach { (_, json) in
                    
                    article = [
                        "title": json["title"].string,
                        "user": json["user"]["id"].string,
                        "profile_image_url": json["user"]["profile_image_url"].string
                    ]
                    articles.append(article)
                }
                // 追加
                apiResponse(articles)
        }
    }
}

