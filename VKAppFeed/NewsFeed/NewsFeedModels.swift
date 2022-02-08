//
//  NewsFeedModels.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 03.02.2022.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getNewsFeed
          case getUser
          case revealPostIds(postId: Int)
          case getextBatch
      }
    }
    struct Response {
      enum ResponseType {
          case presentData(feed: FeedResponse, revealedIds: [Int])
          case presentUser(user: UserResponse)
          case presentFooterLoader
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsFeed(feedViewModel: FeedViewModel)
        case displayUser(userViewModel: UserViewModel)
        case displayFooterLoader
      }
    }
  }
}


struct UserViewModel:TitleViewModel {
    var imageUrlString: String?
    
}


struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var post: String?
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var photos: [PhotoAttachmentVeiwPhoto]
        var sizes: CellFeedSizes
        
    }
    
    struct CellPhoto: PhotoAttachmentVeiwPhoto {
        
        var photoUrl: String?
        var width: Int
        var height: Int
        
         
    }
    
    let cells: [Cell]
    let footerTitle: String?
}

