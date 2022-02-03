//
//  UserRresponse.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 03.02.2022.
//

import Foundation


struct UserResponseWrapped: Decodable {
    
    let response: [UserResponse]
}


struct UserResponse: Decodable {
    
    var photo100: String?
    
}
