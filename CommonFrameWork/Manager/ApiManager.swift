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
        let title: String
        let user: String
        let profile_image_url: String
        
    }

    private override init() {
        // シングルトン
    }

    //GET
    func getRequestWithURL(path :String,parameter:[String: AnyObject]?, success: @escaping (_ result: [String: AnyObject]) -> Void ,failure: @escaping (_ error: Error) -> Void ) -> Void {
        Alamofire.request(path, method: .get, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.error != nil {
                failure(response.error!)
                return;
            }
            
            if let JSON = response.result.value {
                success(JSON as! [String: AnyObject])
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

