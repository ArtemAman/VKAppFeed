//
//  NetworkService.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 25.01.2022.
//

import Foundation

final class NetworkService {
    
    
    let authService: AuthenticationService
    
    init(authService: AuthenticationService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(completion: @escaping(Data?, Error?) -> Void) {
        guard let url = getUrl() else { return }
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    
    
    func getUrl () -> URL? {
        guard let token = authService.token else { return nil }
        let params = ["filters":"post,photo"]
        var allParams = params
        allParams["v"] = API.version
        allParams["access_token"] = token
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.method
        components.queryItems = allParams.map {URLQueryItem(name:$0, value: $1)}
        print("URL --- \(components.url!)")
        return components.url!
    }
}
