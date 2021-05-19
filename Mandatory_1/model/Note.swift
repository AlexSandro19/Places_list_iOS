//
//  Note.swift
//  Mandatory_1
//
//  Created by Veniamin Shandrovskiy on 07.04.2021.
//

import Foundation

class Note{
    var id:String
    var text:String
    var imageId:String
    
    init(id:String, text:String, imageId:String) {
        self.id = id
        self.text = text
        self.imageId = imageId
    }
}
