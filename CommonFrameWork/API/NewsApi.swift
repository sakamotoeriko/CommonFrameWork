//
//  NewsApi.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/22.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import Alamofire

class NewsApi:NSObject{
    //コールバック
    var delegate: APIDelegate?

    //投稿データの取得処理
    func getNews(page:String,per_page:String) {
        //パラメータの作成処理
        let parameter:[String: Any] = ["page":page, "per_page":per_page]

        NetWorkManager.instance.getRequestWithURL(path: CommonConst.APINews,parameter:parameter as [String : AnyObject], success: {resData in
            if let data = resData as? Data {
                let result = try? JSONDecoder().decode(Array<ArticleMode>.self, from: data)
                //success(result! as AnyObject)
                LogPrint.whLog(result)            //JSONの解析処理
                self.delegate?.complete(result: result as AnyObject)
            }

        }){
            //エラー処理
            (error) in LogPrint.whLog(error.localizedDescription)
            self.delegate?.failed(error: error as NSError)
        }
    }

    override init() {
        NetWorkManager.instance.networkCheck()
        
    }
}
