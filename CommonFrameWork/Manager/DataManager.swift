//
//  DataManager.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/17.
//  Copyright © 2018年 sayi. All rights reserved.
//
import Foundation
import FMDB

class DataManager: NSObject {
    
    //シングルトン
    static let shareManager = DataManager()
    
    //データベースマネージ
    let appdb:FMDatabase!
    
    //初期化処理
    override init() {
        //データベースのパス設定
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir   = paths[0] as NSString
        let path  = dir.appendingPathComponent(CommonConst.DB_NAME)

        //データベースインスタンスを初期化する
        appdb = FMDatabase(path: path)
        //データベース存在しない場合、エラー情報を表示させる
        if !appdb.open() {
            print("データベースがアクセスできませんでした。")
            return
        }
    }
    
    var db: FMDatabase!{
        get {
            return self.appdb
        }
    }
    
    func closedb() {
        if !appdb.close() {
            print("データベースが閉じられていません。")
            return
        }
    }
    
    /// アルバムのDAOを作成する
    ///
    /// - Returns: Instance of the data access object.
    func albumDAO() -> AlbumDAO? {
        if appdb != nil {
            return AlbumDAO()
        }
        return nil
    }
    
    deinit {
        self.closedb()
    }

}
