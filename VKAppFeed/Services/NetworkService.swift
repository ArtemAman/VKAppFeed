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
    
    func request(path: String, params:[String:String], completion: @escaping(Data?, Error?) -> Void) {
        guard let url = getUrl(path:path, params: params) else { return }
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    

    func getUrl (path: String, params:[String:String]) -> URL? {
        guard let token = authService.token else { return nil }
        var allParams = params
        allParams["v"] = API.version
        allParams["access_token"] = token
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = allParams.map {URLQueryItem(name:$0, value: $1)}
        return components.url!
    }
}
