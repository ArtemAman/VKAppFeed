//
//  ResponseFetcher.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 26.01.2022.
//

import Foundation

class ResponseFetcher {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchData(response: @escaping (FeedResponse?) -> Void) {
        
        networkService.request { data, error in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let info = try? decoder.decode(FeedResponseWrapped.self, from: data)
            response(info?.response)
        }
    }
}
