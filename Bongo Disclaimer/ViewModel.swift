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
    var lastCharacterAndEvery10thCharacters:(Character,String) -> Void { get set }
    var wordCountsInString:(String) -> Void { get set }
    var allResponseFromWebUrl:(NSAttributedString) -> Void { get set }
    /**
    This function will fetch data from web url
    - parameter urlString:The link where to grab data
    */
    func fetchWebContent(_ urlString: String, _ showConsole: Bool)
}

class ViewModel:ViewModelDelegate {
    var allResponseFromWebUrl: (NSAttributedString) -> Void = { _ in }
    var lastCharacterAndEvery10thCharacters: (Character, String) -> Void = { _,_ in }
    var wordCountsInString: (String) -> Void = { _ in }

    ///Singleton NetworkManger to handle network related operations
    let networkManager = NetworkManager.shared

    ///Example: https://bongobd.com/disclaimer
    fileprivate let webUrl = "https://www.bioscopelive.com/en/disclaimer"

    init() {}

    /**
    This function will fetch data from web url
    - parameter urlString:The link where to grab data
    */
    func fetchWebContent(_ urlString: String = "", _ showConsole:Bool = false) {
        let url = urlString.isEmpty ? webUrl : urlString

        networkManager.getString(from: url) {(content) in
            if !showConsole {
                self.allResponseFromWebUrl(content)
                return
            }
            let stringValue = content.string

            if let lastCharacter = stringValue.last {
                //MARK:- Printing  the last character.
                print(lastCharacter)
                let every10thCharacters = self.getEveryCharacters(at: 10, for: stringValue)
                //MARK:- Printing every 10th character separated by space
                print(every10thCharacters)
                self.lastCharacterAndEvery10thCharacters(lastCharacter,every10thCharacters)
//                self.allResponseFromWebUrl(content)
            }
            DispatchQueue.global(qos: .background).async {
                self.wordCounts(_string: stringValue)
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
         //MARK:- Printing  the count of every word.
        print(wordCounts)
        wordCountsInString(wordCounts)
    }

    func getEveryCharacters(at position: Int, for string: String) -> String {
        let _position = position + 1

        return string.everyCharcters(at: _position)
    }
}
