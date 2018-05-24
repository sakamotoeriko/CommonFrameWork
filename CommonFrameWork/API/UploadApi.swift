//
//  UploadApi.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/24.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
class UpLoadApi:NSObject{
    //コールバック
    var delegate: APIDelegate?
    
    override init() {
        NetWorkManager.instance.networkCheck()
        
    }
    
    //投稿データの取得処理
    func UpLoadZip(fileURL:URL) {
        NetWorkManager.instance.upLoad(uploadUrl:CommonConst.APIUPLOAD_URL, fileURL: fileURL, completion: {result in
            if let result = result as? AnyObject {
                //let result = try? JSONDecoder().decode(Array<ArticleMode>.self, from: data)
                //success(result! as AnyObject)
                LogPrint.whLog(result)            //JSONの解析処理
                self.delegate?.upLoadComplete(result: result)
            }
            
        }){
            //エラー処理
            (error) in LogPrint.whLog(error.localizedDescription)
            self.delegate?.failed(error: error as NSError)
        }
    }
}
