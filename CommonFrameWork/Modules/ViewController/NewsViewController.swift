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
    
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var networkBtn: UIButton!
    @IBOutlet weak var pushBtn: UIButton!
    //APIの定義
    var newsApi:NewsApi?
    
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
    }
    
    @IBAction func networkAction(_ sender: Any) {
        //呼び出す
        newsApi?.getNews(page: "1", per_page: "3")
        //
    }
    
}

// MARK: - TaskDelegate
extension NewsViewController: APIDelegate {
    func complete(result: AnyObject) {
        // 処理
        var news_ary:[ArticleMode] = result as! [ArticleMode]
        self.resultLable.text = news_ary[0].profile_image_url
    }
    
    func failed(error: NSError) {
        // 処理
        self.resultLable.text = "データを見つかりませんでした！"
    }
}
