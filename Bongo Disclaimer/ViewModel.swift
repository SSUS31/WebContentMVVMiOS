//
//  ViewModel.swift
//  Bongo Disclaimer
//
//  Created by Sahad on 24/7/20.
//  Copyright © 2020 Sahad. All rights reserved.
//

import Foundation
protocol ViewModelDelegate {
//    func fetchDataFromWebURL(urlString: String,completion:@escaping (String)->Void)
    var lastCharacter:(Character) -> Void { get set }
    var wordCountsInString:(String) -> Void { get set }
    /**
    This function will fetch data from web url
    - parameter urlString:The link where to grab data
    */
    func fetchWebContent(_ urlString:String?)
}

struct ViewModel:ViewModelDelegate {
    var wordCountsInString: (String) -> Void = { _ in }
    var lastCharacter: (Character) -> Void = { _ in }

    ///Singleton NetworkManger to handle network related operations
    let networkManager = NetworkManager.shared

    ///Example: https://bongobd.com/disclaimer
    fileprivate let webUrl = "https://www.bioscopelive.com/en/disclaimer"

    init() {}


    func fetchDataFromWebURL(urlString: String,completion:@escaping (String)->Void) {
        networkManager.getString(from: urlString) { (content) in
            let str = content.components(separatedBy: .whitespaces)
//            guard let self = self else { return }
//            print(str)
            print(content.last)
            completion(content)

        }
    }

    /**
    This function will fetch data from web url
    - parameter urlString:The link where to grab data
    */
    func fetchWebContent(_ urlString: String?) {
        let url = urlString ?? webUrl

        networkManager.getString(from: url) {(content) in

            if let lastCharacter = content.last {
                self.lastCharacter(lastCharacter)
            }

            DispatchQueue.global().async {
                self.wordCounts(_string: content)
            }

        }
    }

    func wordCounts(_string: String) {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = _string.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        var wordCounts = ""

        for word in words {
            if word.count > 0 {
                wordCounts += " \(word.count)"
            }

        }
        wordCountsInString(wordCounts)
    }
}
