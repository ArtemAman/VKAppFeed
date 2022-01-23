//
//  AuthenticationService.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 23.01.2022.
//

import UIKit
import VK_ios_sdk

final class AuthenticationService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    let appId = "8057165"
    let vkSdk: VKSdk
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("ololo")
        
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    //MARK: VKSDK delegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    //MARK: VKSDK UIdelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
