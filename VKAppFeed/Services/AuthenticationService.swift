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
    
    func wakeUpSession() {
        
        let scope = ["offline"]
        
        VKSdk.wakeUpSession(scope) { state, error in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
            } else {
                print("Auth problem. state -- \(state), error -- \(error)")
            }
        }
        
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
