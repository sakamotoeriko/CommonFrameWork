//
//  AlbumDAO.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import FMDB

// アルバムテーブルの作成.
class AlbumDAO: NSObject {
    /// Query for the create table.
    private static let SQLCreate = "" +
        "CREATE TABLE IF NOT EXISTS album (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "author TEXT, " +
        "title TEXT, " +
        "create_date INTEGER" +
    ");"
    
    /// アルバム検索.
    private static let SQLSelect = "" +
        "SELECT " +
        "id, author, title, create_date " +
        "FROM " +
        "album;" +
        "ORDER BY " +
    "author, title;"
    
    /// アルバム追加.
    private static let SQLInsert = "" +
        "INSERT INTO " +
        "album (author, title, create_date) " +
        "VALUES " +
    "(?, ?, ?);"
    
    /// アルバム更新.
    private static let SQLUpdate = "" +
        "UPDATE " +
        "album " +
        "SET " +
        "author = ?, title = ?, create_date = ? " +
        "WHERE " +
    "id = ?;"
    
    /// 削除.
    private static let SQLDelete = "DELETE FROM album WHERE id = ?;"

    //ロック排他
    let lock = NSLock()

    // アルバムテーブルの作成処理
    func create() {
        DataManager.shareManager.db.executeUpdate(AlbumDAO.SQLCreate, withArgumentsIn: [])
    }
    
    /// アルバムの新規作成処理.
    ///
    /// - Parameters:
    ///   - author:      Author.
    ///   - title:       Title.
    ///   - createDate: create Date.
    /// - Returns: Added the album.
    func add(author: String, title: String, createDate: Date) -> AlbumMode? {
        var album: AlbumMode? = nil
        if DataManager.shareManager.db.executeUpdate(AlbumDAO.SQLInsert, withArgumentsIn: [author, title, createDate]) {
            let albumId = DataManager.shareManager.db.lastInsertRowId
            album = AlbumMode(albumId: Int(albumId), author: author, title: title, createDate: createDate)
        }
        
        return album
    }
    
    /// アルバムリストの取得処理（１件ずつ）.
    ///
    /// - Returns: Readed album.
    func read() -> Array<AlbumMode> {
        var albums = Array<AlbumMode>()
        if let results = DataManager.shareManager.db.executeQuery(AlbumDAO.SQLSelect, withArgumentsIn: []) {
            while results.next() {
                let album = AlbumMode(albumId: results.long(forColumnIndex: 0),
                                      author: results.string(forColumnIndex: 1)!,
                                      title: results.string(forColumnIndex: 2)!,
                                      createDate: results.date(forColumnIndex: 3)!)
                albums.append(album)
            }
        }
        
        return albums
    }
    
    /// アルバムの削除処理.
    ///
    /// - Parameter albumId: The identifier of the album to remove.
    /// - Returns: "true" if successful.
    func remove(albumId: Int) -> Bool {
        //ロック
        lock.lock()
        let result = DataManager.shareManager.db.executeUpdate(AlbumDAO.SQLDelete, withArgumentsIn: [albumId])
        //アンロック
        lock.unlock()
        return result
    }
    
    /// アルバムの更新処理.
    ///
    /// - Parameter album: The data of the album to update.
    /// - Returns: "true" if successful.
    func update(album: AlbumMode) -> Bool {
        //ロック
        lock.lock()
        let result = DataManager.shareManager.db.executeUpdate(AlbumDAO.SQLUpdate,
                                                              withArgumentsIn: [
                                                                album.author,
                                                                album.title,
                                                                album.createDate,
                                                                album.albumId])
        //アンロック
        lock.unlock()
        return result
    }
}
