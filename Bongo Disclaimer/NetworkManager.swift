//
//  NetworkManager.swift
//  Bongo Disclaimer
//
//  Created by Sahad on 23/7/20.
//  Copyright © 2020 Sahad. All rights reserved.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init (){}

    func getString(from urlString:String,_ completion: @escaping (String)->()) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, error == nil {
                if let content = String(data: data, encoding: .utf8) {
                    let _string = content.htmlToString

                    completion(_string)
                }
            } else {
                print("Something wrong")
                completion("xxxxx")
            }
        }.resume()
    }
}
