//
//  NewsFeedInteractor.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 03.02.2022.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
    
    private var fetcher: ResponseFetcher = ResponseFetcher(networkService: NetworkService())
    private var revealedIds = [Int]()
    private var feedResponse:FeedResponse?
    private var userResponse:UserResponse?

  
  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
      switch request {
      
      case .getNewsFeed:
          fetcher.fetchData { [weak self] response in
              guard let feedResponse = response else { return }
              self?.feedResponse = feedResponse
              self?.presentFeed()

              
              }
      case .getUser:
          fetcher.fetchUserData {[weak self] response in
              guard let userResponse = response else { return }
              self?.presenter?.presentData(response: .presentUser(user: userResponse))
          }
          
      case .revealPostIds(postId: let postId):
          revealedIds.append(postId)
          presentFeed()
      
      }
          
        
      }
    
    private func presentFeed() {
        guard let feedResponse = self.feedResponse else { return }
        presenter?.presentData(response: .presentData(feed: feedResponse, revealedIds: revealedIds))
    }
  }


