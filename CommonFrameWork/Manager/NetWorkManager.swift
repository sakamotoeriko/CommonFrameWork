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
    func downLoadComplete(result: Bool,filepath:String)
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
    
    //ファイルのダウンロード
    func downLoad(downloadUrl:String, completion: @escaping (Bool,String) -> Void,failure: @escaping (_ error: Error) -> Void)->Void {
        
        /*let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent(saveUrl, isDirectory: false)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }*/

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("Test.jpg")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(downloadUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination).response{ response in
            if response.error == nil {
                //completion(true,response.result.value! as AnyObject)
                completion(true,(response.destinationURL?.path)!)
            } else{
                failure(response.error!)
                return;
            }
        }
    }
    
    //ファイルアップロード処理
    /*let fileURL = NSBundle.mainBundle().URLForResource("hangge", withExtension: "zip")
    
    Alamofire.upload(.POST, "http://www.hangge.com/upload.php", file: fileURL!)
    .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
    print(totalBytesWritten)
    
    // This closure is NOT called on the main queue for performance
    // reasons. To update your ui, dispatch to the main queue.
    dispatch_async(dispatch_get_main_queue()) {
    print("Total bytes written on main queue: \(totalBytesWritten)")
    }
    }
    .responseJSON { response in
    debugPrint(response)
    }*/
    
    
    /*.downloadProgress(closure: <#T##Request.ProgressHandler##Request.ProgressHandler##(Progress) -> Void#>)) {
    (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
    let percent = totalBytesRead*100/totalBytesExpectedToRead
    print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
    
    }*/
    
    
    
    // delete、put
    //TODO
}

