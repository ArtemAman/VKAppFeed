//
//  AuthenticationViewController.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 23.01.2022.
//

import UIKit

class AuthenticationViewController: UIViewController, AuthenticationServiceDelegate{

    
    
    private var authService: AuthenticationService!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AppDelegate.shared().authService
        authService.delegate = self

        
    }
    
    @IBAction func loginAction() {
        print("login button pressed")
        authService.wakeUpSession()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: funcs of AuthenticationServiceDelegate
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        self.present(viewController, animated: true, completion: nil)
        print("мы завершили презент вьюхи")
    }
    
    func authServiceSignIn() {
        print(#function)
    }
    
    func authServiceDidSignInFail() {
        print(#function)
    }


}
