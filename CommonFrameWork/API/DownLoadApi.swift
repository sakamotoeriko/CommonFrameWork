//
//  downLoadApi.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/24.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
class DownLoadApi:NSObject{
    //コールバック
    var delegate: APIDelegate?
    
    override init() {
        NetWorkManager.instance.networkCheck()
        
    }
    
    //投稿データの取得処理
    func downLoadZip(fileURL:String) {
        //パラメータの作成処理
        //let parameter:[String: Any] = ["page":page, "per_page":per_page]
        
        //NetWorkManager.instance.downLoad(path: CommonConst.APIImage,parameter:nil, completion: {result,resData in
        NetWorkManager.instance.downLoad(downloadUrl: fileURL, completion: {result, filePath in
            if let result = result as? Bool {
                //let result = try? JSONDecoder().decode(Array<ArticleMode>.self, from: data)
                //success(result! as AnyObject)
                LogPrint.whLog(result)            //JSONの解析処理
                self.delegate?.downLoadComplete(result: result as Bool,filepath: filePath)
            }
            
        }){
            //エラー処理
            (error) in LogPrint.whLog(error.localizedDescription)
            self.delegate?.failed(error: error as NSError)
        }
    }
}
