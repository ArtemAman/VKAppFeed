//
//  AuthenticationService.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 23.01.2022.
//

import UIKit
import VK_ios_sdk

protocol AuthenticationServiceDelegate: class {
    
    func authServiceShouldShow(_ viewController:UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class AuthenticationService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    let appId = "8057165"
    let vkSdk: VKSdk
    weak var delegate:AuthenticationServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("ololo")
        
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        
        let scope = ["offline", "wall", "friends"]
        
        VKSdk.wakeUpSession(scope) {[delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
//                VKSdk.authorize(scope, with: .disableSafariController)
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope, with: .disableSafariController)
            } else {
                print("Auth problem. state -- \(state), error -- \(error)")
                delegate?.authServiceDidSignInFail()
            }
        }
        
    }
    
    //MARK: VKSDK delegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
            print(result.token.hashValue)
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    //MARK: VKSDK UIdelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
