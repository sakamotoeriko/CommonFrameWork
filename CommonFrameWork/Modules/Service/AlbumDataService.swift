//
//  AlbumService.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import UIKit

/// Manage for the albumservice.
class AlbumDataService: NSObject {

     /// Collection of author names.
    var authors: Array<String> {
        get {
            return self.albumCache.authors
        }
    }
    
    // Dictionary of album collection classified by author name.
    var albumsByAuthor: Dictionary<String, Array<AlbumMode>> {
        get {
            return self.albumCache.albumsByAuthor
        }
    }

    /// アルバムDAO.
    private let albumDao: AlbumDAO
    /// Manager for the album data.
    private var albumCache: AlbumCache!
    /// Initialize the instance.
    ///
    /// - Parameter daoFactory: Factory of a data access objects.
    init(albumDao: AlbumDAO) {
        self.albumDao = albumDao
        super.init()
        if let dao = DataManager.shareManager.albumDAO() {
            //アルバムテーブルの作成処理
            dao.create()
            //アルバム初期化(アルバムテーブルからデータを読み込む)
            self.albumCache = AlbumCache(albums: dao.read())
        }
    }
    
    /// アルバム新規作成.
    ///
    /// - Parameter album: Album data.
    /// - Returns: "true" if successful.
    func add(album: AlbumMode) -> Bool {
        if let newAlbum = self.albumDao.add(author: album.author, title: album.title, createDate: album.createDate) {
            //
            return self.albumCache.add(album: newAlbum)
        }

        return false
    }
    
    /// アルバム削除処理.
    ///
    /// - Parameter album: album data.
    /// - Returns: "true" if successful.
    func remove(album: AlbumMode) -> Bool {
        if self.albumDao.remove(albumId: album.albumId) {
            return self.albumCache.remove(album: album)
        }
        
        return false
    }
    
    /// アルバム更新処理.
    ///
    /// - Parameter oldAlbum,: New album data.
    /// - Parameter newAlbum: Old album data.
    /// - Returns: "true" if successful.
    func update(oldAlbum: AlbumMode, newAlbum: AlbumMode) -> Bool {
        if self.albumDao.update(album: newAlbum) {
             return self.albumCache.update(oldAlbum: oldAlbum, newAlbum: newAlbum)
        }
        
        return false
    }
}
