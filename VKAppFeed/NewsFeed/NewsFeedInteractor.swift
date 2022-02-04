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
          fetcher.fetchData(nextBatchFrom: nil) { [weak self] response in
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
      
      case .getextBatch:
          fetcher.fetchData(nextBatchFrom: feedResponse?.nextFrom) {[weak self] response in
              
              guard let response = response else { return }
              guard self?.feedResponse?.nextFrom != response.nextFrom else { return }
              
              if self?.feedResponse == nil {
                  self?.feedResponse = response
              } else {
                  self?.feedResponse?.items.append(contentsOf: response.items)
                  self?.feedResponse?.items = response.items
                  self?.feedResponse?.nextFrom = response.nextFrom
                  
                  // check profiles
                  var profiles = response.profiles
                  if let oldProfiles = self?.feedResponse?.profiles {
                      let oldProfilesFiltered = oldProfiles.filter { profile in
                          !response.profiles.contains(where: { $0.id == profile.id })
                      }
                      profiles.append(contentsOf: oldProfilesFiltered)
                  }
                  
                  self?.feedResponse?.profiles = profiles
                  
                  // check groups
                  var groups = response.groups
                  if let oldGroups = self?.feedResponse?.groups {
                      let oldGroupsFiltered = oldGroups.filter { group in
                          !response.groups.contains(where: { $0.id == group.id })
                      }
                      groups.append(contentsOf: oldGroupsFiltered)
                  }
                  
                  self?.feedResponse?.groups = groups
              }
              
              guard let feedResponse = self?.feedResponse else {
                  return
              }

              self?.feedResponse = feedResponse
              self?.presentFeed()
          }
      }
          
        
      }
    
    private func presentFeed() {
        guard let feedResponse = self.feedResponse else { return }
        presenter?.presentData(response: .presentData(feed: feedResponse, revealedIds: revealedIds))
    }
  }

