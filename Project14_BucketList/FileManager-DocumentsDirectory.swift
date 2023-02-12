//
//  FileManager-DocumentsDirectory.swift
//  Project14_BucketList
//
//  Created by admin on 10.09.2022.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]

    }
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }

    func writeData(text message: String) {
        var url = getDocumentsDirectory().appendingPathComponent("message.txt")
        
        do {
            try message.write(to: url, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: url)
            print(input)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
