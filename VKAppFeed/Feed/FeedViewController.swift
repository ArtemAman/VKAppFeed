//
//  FeedViewController.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 24.01.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: ResponseFetcher = ResponseFetcher(networkService: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchData { response in
            guard let feedResponse = response else { return }
            feedResponse.items.map { item in
                print(item.date)
            }
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
