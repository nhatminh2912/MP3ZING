//
//  Song.swift
//  ZINGMP3
//
//  Created by Nhật Minh on 3/6/17.
//  Copyright © 2017 Nhật Minh. All rights reserved.
//

import Foundation
import UIKit
struct Song {
    var title = ""
    var artistName = ""
    var thumbnail: UIImage
    var sourceOnline = ""
    var sourceLocal = ""
    var localThumbnail = ""
    let baseThumbnail = "http://image.mp3.zdn.vn//thumb/240_240/"
    init (title: String, artistName: String, thumbnail: String, source: String)
    {
        self.title = title
        self.artistName = artistName
        let thumbnailURL = baseThumbnail+thumbnail
        let dataImage = NSData(contentsOf: NSURL(string: thumbnailURL) as! URL)
        self.thumbnail = UIImage(data: dataImage! as Data)!
        self.sourceOnline = source
    }
    init (title: String, artistName: String, localThumbnail: String, localSource: String)
    {
        self.title = title
        self.artistName = artistName
        self.localThumbnail = localThumbnail
        let dataImage = NSData(contentsOfFile: self.localThumbnail)
        self.thumbnail = UIImage(data: dataImage! as Data)!
        self.sourceLocal = localSource
    }
}
