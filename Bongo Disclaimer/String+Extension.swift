//
//  String+Extension.swift
//  Bongo Disclaimer
//
//  Created by Sahad on 24/7/20.
//  Copyright © 2020 Sahad. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }

    func everyCharcters(at number:Int) -> String {
        var characters = ""
        let count = Array(self).count


        for position in stride(from: number-1, through: count, by: number) {
            if position < count {
                let value = characters.count > 0 ? " \(self[position])" : "\(self[position])"

                characters.append(value)
            }
        }

        return characters
    }
}
