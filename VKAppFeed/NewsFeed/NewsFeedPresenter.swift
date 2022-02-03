//
//  NewsFeedPresenter.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 03.02.2022.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
  weak var viewController: NewsfeedDisplayLogic?
    
    let cellLayoutCalculator: FeedCellLayoutCalculateProtocol = FeedCellLayoutCalculator()
    
    let dateFormatter:DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "dd MMMM yyyy в HH:mm"
        return dt
    }()
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
      
      switch response {
      
      case .presentData(feed: let feed, let revealedIds):
          let cells = feed.items.map { feedItem in
              cellViewModel(feedItem: feedItem, profiles: feed.profiles, groups: feed.groups, revealedIds: revealedIds)
          }
          
          let feedViewModel = FeedViewModel.init(cells: cells)
          viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel:feedViewModel))
      }
  }
    
    private func cellViewModel(feedItem:FeedItem, profiles:[Profile], groups:[Group], revealedIds:[Int]) -> FeedViewModel.Cell {
        
        let profile = profile(sourceId: feedItem.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let photos = photoAttachments(feedItem: feedItem)
        
        let isFullSized = revealedIds.contains { postId in
            return postId == feedItem.postId
        }
        
        let modifiedViews = checkViews(feedItem: feedItem)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photos, isFullSized: isFullSized)
    
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       post: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       reposts: String(feedItem.reposts?.count ?? 0),
                                       views: modifiedViews,
                                       photos: photos,
                                       sizes: sizes
        )
    }
    
    private func profile(sourceId:Int, profiles:[Profile], groups:[Group]) -> ProfileRepresentable {
        
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { myProfile in
            myProfile.id == normalSourceId
        }
        return profileRepresentable!
    }
    
    private func photoAttachments(feedItem :FeedItem) -> [FeedViewModel.CellPhoto] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap { attachment in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.CellPhoto.init(photoUrl: photo.src,
                                                width: photo.width,
                                                height: photo.height)
        }

    }
    
    private func checkViews(feedItem: FeedItem) -> String {
        let views = String(feedItem.views?.count ?? 0)
        let count = views.count
        if count >= 5 {
            let index = views.index(views.startIndex, offsetBy: count - 3)
            let mySubstring = views.prefix(upTo: index)
            return String(mySubstring) + "k"
        } else {
            return views
        }
        
    }
}

