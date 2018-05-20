//
//  AlbumMode.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
/// アルバムモデルの定義.
class AlbumMode: NSObject {
    /// Invalid album identifier.
    static let AlbumIdNone = 0

    /// Identifier.
    private(set) var albumId: Int
    
    /// Title.
    private(set) var title: String
    
    /// Author.
    private(set) var author: String
    
    /// Release date.
    private(set) var createDate: Date

    /// Initialize the instance.
    ///
    /// - Parameters:
    ///   - albumId:     Identifier
    ///   - author:      Author.
    ///   - title:       Title.
    ///   - releaseDate: Release Date
    init(albumId: Int, author: String, title: String, createDate: Date) {
        self.albumId     = albumId
        self.author      = author
        self.title       = title
        self.createDate  = createDate
    }
}
