//
//  ResponseFetcher.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 26.01.2022.
//

import Foundation

class ResponseFetcher {
    
    let networkService: NetworkService
    private let authService: AuthenticationService
    
    init(networkService: NetworkService, authService: AuthenticationService = AppDelegate.shared().authService) {
        self.networkService = networkService
        self.authService = authService
    }
    
    func fetchData(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networkService.request(path: API.method, params: params) { data, error in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else {
                print("Error occured")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let info = try? decoder.decode(FeedResponseWrapped.self, from: data)
            response(info?.response)
        }
    }
    
    
    func fetchUserData(response: @escaping (UserResponse?) -> Void) {
        
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
        networkService.request(path: API.user, params: params) { data, error in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
                response(nil)
            }
            guard let data = data else {
                print("Error occured")
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let info = try? decoder.decode(UserResponseWrapped.self, from: data)
            response(info?.response.first)
        }
    }
    
}
