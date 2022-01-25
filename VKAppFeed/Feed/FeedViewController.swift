//
//  FeedViewController.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 24.01.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.request { data, error in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
            }
            guard let data = data else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
        
        title = "VK Feed"
        view.backgroundColor = .green
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
