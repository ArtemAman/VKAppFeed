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
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
          case presentData(feed: FeedResponse, revealedIds: [Int])
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsFeed(feedViewModel: FeedViewModel)
      }
    }
  }
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
}

