//
//  FileUtility.swift
//  Peggle
//
//  Created by Zhang Cheng on 31/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation

class FileUtility {

    static func getDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.path
    }

    static func fileURLInDocumentsDirectory(fileName: String,
        fileExtension: String) -> String {
        return self.getDocumentsDirectory() + "/" + fileName + fileExtension
    }
}
