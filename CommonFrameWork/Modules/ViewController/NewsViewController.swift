//
//  NewsViewController.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/22.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import UIKit
class NewsViewController: UIViewController{
    
    @IBOutlet weak var downloadResume: UIButton!
    @IBOutlet weak var downloadPause: UIButton!
    
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var networkBtn: UIButton!
    @IBOutlet weak var pushBtn: UIButton!
    //APIの定義
    var newsApi:NewsApi?
    
    var downLoadApi:DownLoadApi?
    
    var uploadApi:UpLoadApi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initApi()
    }


    
    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //NewsAPIの初期化処理
    func initApi(){
        //初期化
        newsApi = NewsApi();
        newsApi?.delegate = self;
        //ダウンロード処理
        downLoadApi = DownLoadApi();
        downLoadApi?.delegate = self;
        //zipファイルアップロード処理
        // リソースファイルをアップロード
        uploadApi = UpLoadApi();
        uploadApi?.delegate = self;
        
    }
    
    
    
    @IBAction func resumeDownload(_ sender: Any) {
        NetWorkManager.instance.resumeDownLoadOrUpLoad()
    }
    
    @IBAction func downloadPause(_ sender: Any) {
        NetWorkManager.instance.pauseDownLoadOrUpLoad()
    }
    
    @IBAction func networkAction(_ sender: Any) {
        //呼び出す
        //newsApi?.getNews(page: "1", per_page: "3")
        //
        //downLoadApi?.downLoadZip(fileURL: CommonConst.APIImage)
        
        //let fileURL = Bundle.main.url(forResource: "test", withExtension: "pptx")
        //uploadApi?.UpLoadZip(fileURL: fileURL!);
        downLoadApi?.downLoadZip(fileURL: CommonConst.APIImage)
    }
    
}

// MARK: - TaskDelegate
extension NewsViewController: APIDelegate {
    
    func complete(result: AnyObject) {
        // 処理
        var news_ary:[ArticleMode] = result as! [ArticleMode]
        self.resultLable.text = news_ary[0].profile_image_url
    }
    
    func downLoadComplete(result: Bool,filepath:String) {
        // 処理
        if (result){
            //self.resultLable.text = news_ary[0].profile_image_url
            self.resultLable.text = filepath
        }
        
    }
    
    func upLoadComplete(result: AnyObject) {
        // 処理
            //self.resultLable.text = news_ary[0].profile_image_url
            self.resultLable.text = result as? String
    }
    
    func failed(error: NSError) {
        // 処理
        self.resultLable.text = "データを見つかりませんでした！"
    }
}
