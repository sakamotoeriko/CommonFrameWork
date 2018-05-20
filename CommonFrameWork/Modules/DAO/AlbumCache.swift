//
//  AlbumCache.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
/// Manager fot the album data.
class AlbumCache: NSObject {
    /// A collection of author names.
    var authors = Array<String>()
    
    /// Dictionary of album collection classified by author name.
    var albumsByAuthor = Dictionary<String, Array<AlbumMode>>()
    
    /// Initialize the instance.
    override init() {
        super.init()
    }
    
    /// 初期化処理.
    ///
    /// - Parameter albums: Collection of the album data.
    init(albums: Array<AlbumMode>) {
        super.init()
        
        albums.forEach({ (album) in
            if !self.add(album: album) {
                print("Faild to add album: " + album.author + " - " + album.title )
            }
        })
    }
    
    /// アルバム新規追加処理.
    ///
    /// - Parameter album: Album data.
    /// - Returns: "true" if successful.
    func add(album: AlbumMode) -> Bool {
        if album.albumId == AlbumMode.AlbumIdNone {
            return false
        }
        
        if var existAlbums = self.albumsByAuthor[album.author] {
            existAlbums.append(album)
            self.albumsByAuthor.updateValue(existAlbums, forKey: album.author)
        } else {
            var newAlbums = Array<AlbumMode>()
            newAlbums.append(album)
            self.albumsByAuthor[album.author] = newAlbums
            self.authors.append(album.author)
        }
        
        return true
    }
    
    /// アルバム削除処理.
    ///
    /// - Parameter album: Album data.
    /// - Returns: "true" if successful.
    func remove(album: AlbumMode) -> Bool {
        guard var albums = self.albumsByAuthor[album.author] else {
            return false
        }
        
        for i in 0..<albums.count {
            let existAlbum = albums[i]
            if existAlbum.albumId == album.albumId {
                albums.remove(at: i)
                self.albumsByAuthor.updateValue(albums, forKey: album.author)
                break
            }
        }
        
        if albums.count == 0 {
            return self.removeAuthor(author: album.author)
        }
        
        return true
    }
    
    /// アルバムの更新処理.
    ///
    /// - Parameter oldAlbum: New album data.
    /// - Parameter newAlbum: Old album data.
    /// - Returns: "true" if successful.
    func update(oldAlbum: AlbumMode, newAlbum: AlbumMode) -> Bool {
        if oldAlbum.author == newAlbum.author {
            return self.replaceAlbum(newAlbum: newAlbum)
        } else if self.remove(album: oldAlbum) {
            return self.add(album: newAlbum)
        }
        
        return false
    }
    
    /// アルバムデータの削除処理.
    ///
    /// - Parameter author: Name of the author.
    /// - Returns: "true" if successful.
    private func removeAuthor(author: String) -> Bool {
        self.albumsByAuthor.removeValue(forKey: author)
        for i in 0..<self.authors.count {
            let existAuthor = self.authors[i]
            if existAuthor == author {
                self.authors.remove(at: i)
                return true
            }
        }
        
        return false
    }
    
    /// アルバムデータの更新処理.
    ///
    /// - Parameter newAlbum: New album data.
    /// - Returns: "true" if successful.
    private func replaceAlbum(newAlbum: AlbumMode) -> Bool {
        guard var albums = self.albumsByAuthor[newAlbum.author] else {
            return false
        }
        
        for i in 0..<albums.count {
            let album = albums[i]
            if album.albumId == newAlbum.albumId {
                albums[i] = newAlbum
                self.albumsByAuthor.updateValue(albums, forKey: newAlbum.author)
                return true
            }
        }
        
        return false
    }
}
