//
//  NewsFeedCell.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 27.01.2022.
//

import UIKit



protocol NewsCellButtonPressDelegate: class {
    func revealPost(cell:NewsFeedCell)
}

protocol FeedCellViewModel {
    
    var iconUrlString:String { get }
    var name:String { get }
    var date:String { get }
    var post:String? { get }
    var likes:String? { get }
    var comments:String? { get }
    var reposts:String? { get }
    var views:String? { get }
    var photos: [PhotoAttachmentVeiwPhoto] { get }
    var sizes: CellFeedSizes { get }
    
    
} 

protocol CellFeedSizes {
    
    var postLabelFrame: CGRect{ get }
    var postImageFrame: CGRect { get }
    var totalHeight: CGFloat { get }
    var moreButtonFrame:CGRect { get }
}

protocol PhotoAttachmentVeiwPhoto {
    
    var photoUrl: String? { get }
    var width: Int { get }
    var height: Int { get }
    
}

class NewsFeedCell: UITableViewCell {
    
    static let reuseId: String = "customCell"
    
    weak var delegate: NewsCellButtonPressDelegate?

    // first layer
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.backgroundColor = .white
        return view
    } ()
    
    //second layer
    private lazy var topView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.font = CellConstants.postFont
        label.numberOfLines = 0
        return label
    } ()
    
    private lazy var moreButton:UIButton = {
        let but = UIButton()
        but.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        but.setTitleColor(.systemBlue, for: .normal)
        but.contentHorizontalAlignment = .left
        but.contentVerticalAlignment = .center
        but.setTitle("Show more ...", for: .normal)
        return but
    } ()
    
    private var galleryCollectionView: GalleryCollectionView = GalleryCollectionView()
    
    private lazy var postImage: WebImageView = {
        let image = WebImageView()
        image.backgroundColor = .systemCyan
        return image
    } ()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    // third layer mb
    
    private lazy var groupImage: WebImageView = {
        let image = WebImageView()
        image.backgroundColor = .systemGray
        image.layer.cornerRadius = CellConstants.topViewHeight / 2
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = CellConstants.nameFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = CellConstants.dateFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var likesView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var commentsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var repostsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var viewsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    // fourth layer
    
    private lazy var likesImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "like"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = CellConstants.bottomFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var commentsImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "comment"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    private lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = CellConstants.bottomFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var repostsImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "repost"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    private lazy var repostsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = CellConstants.bottomFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var viewsImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "view"))
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = CellConstants.bottomFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    
    override func prepareForReuse() {
        postImage.set(imageURL: nil)
        groupImage.set(imageURL: nil)
        print(galleryCollectionView.visibleCells.count)
    }
    
    
    
    
    // MARK: Init func
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        overlayMaker()
        moreButton.addTarget(self, action: #selector(moreTextButtonAction), for: .touchUpInside)
        self.backgroundColor = .systemIndigo
//
       
    }
    
    @objc func moreTextButtonAction() {
        
        delegate?.revealPost(cell: self)
        
    }
    
      
    
    
    private func overlayMaker() {
    
    // first
    contentView.addSubview(cardView)
    
    //second
    cardView.addSubview(topView)
    cardView.addSubview(postLabel)
    cardView.addSubview(moreButton)
    cardView.addSubview(galleryCollectionView)
    cardView.addSubview(postImage)
    cardView.addSubview(bottomView)
    
    //third
    
    topView.addSubview(groupImage)
    topView.addSubview(nameLabel)
    topView.addSubview(dateLabel)
    
    bottomView.addSubview(likesView)
    bottomView.addSubview(commentsView)
    bottomView.addSubview(repostsView)
    bottomView.addSubview(viewsView)
    
    // fourth
    likesView.addSubview(likesImage)
    likesView.addSubview(likesLabel)
    
    commentsView.addSubview(commentsImage)
    commentsView.addSubview(commentsLabel)
    
    repostsView.addSubview(repostsImage)
    repostsView.addSubview(repostsLabel)
    
    viewsView.addSubview(viewsImage)
    viewsView.addSubview(viewsLabel)
    
    
    NSLayoutConstraint.activate([
        
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
        topView.heightAnchor.constraint(equalToConstant: CellConstants.topViewHeight),
        
        
        
//            postLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
//            postLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
//            postLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
//
//
//            postImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
//            postImage.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 10),
//            postImage.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
//            postImage.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10),
        
        
        bottomView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
        bottomView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
        bottomView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0),
        bottomView.heightAnchor.constraint(equalToConstant: CellConstants.bottomViewHeight),
    
        groupImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0),
        groupImage.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
        groupImage.heightAnchor.constraint(equalToConstant: CellConstants.topViewHeight),
        groupImage.widthAnchor.constraint(equalToConstant: CellConstants.topViewHeight),
        
        nameLabel.leadingAnchor.constraint(equalTo: groupImage.trailingAnchor, constant: 10),
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2),
        nameLabel.heightAnchor.constraint(equalToConstant: (CellConstants.topViewHeight / 2) - 3),
        nameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10),

        
        dateLabel.leadingAnchor.constraint(equalTo: groupImage.trailingAnchor, constant: 10),
        dateLabel.heightAnchor.constraint(equalToConstant: (CellConstants.topViewHeight / 2) - 3),
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10),
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2),

        likesView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 0),
        likesView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        likesView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
        likesView.widthAnchor.constraint(equalToConstant: CellConstants.bottomViewElementWidth),
        
        commentsView.leadingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: 0),
        commentsView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        commentsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
        commentsView.widthAnchor.constraint(equalToConstant: CellConstants.bottomViewElementWidth),
        
        repostsView.leadingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: 0),
        repostsView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        repostsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
        repostsView.widthAnchor.constraint(equalToConstant: CellConstants.bottomViewElementWidth),
        
        viewsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0),
        viewsView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
        viewsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
        viewsView.widthAnchor.constraint(equalToConstant: CellConstants.bottomViewElementWidth),
        
        likesImage.centerYAnchor.constraint(equalTo: likesView.centerYAnchor),
        likesImage.leadingAnchor.constraint(equalTo: likesView.leadingAnchor, constant: 5),
        likesImage.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        likesImage.widthAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        
        likesLabel.centerYAnchor.constraint(equalTo: likesView.centerYAnchor),
        likesLabel.leadingAnchor.constraint(equalTo: likesImage.trailingAnchor, constant: 5),
        likesLabel.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        likesLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor, constant: -5 ),

        
        commentsImage.centerYAnchor.constraint(equalTo: commentsView.centerYAnchor),
        commentsImage.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor, constant: 5),
        commentsImage.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        commentsImage.widthAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        
        commentsLabel.centerYAnchor.constraint(equalTo: commentsView.centerYAnchor),
        commentsLabel.leadingAnchor.constraint(equalTo: commentsImage.trailingAnchor, constant: 5),
        commentsLabel.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        commentsLabel.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: -5 ),

        
        repostsImage.centerYAnchor.constraint(equalTo: repostsView.centerYAnchor),
        repostsImage.leadingAnchor.constraint(equalTo: repostsView.leadingAnchor, constant: 5),
        repostsImage.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        repostsImage.widthAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        
        repostsLabel.centerYAnchor.constraint(equalTo: repostsView.centerYAnchor),
        repostsLabel.leadingAnchor.constraint(equalTo: repostsImage.trailingAnchor, constant: 5),
        repostsLabel.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        repostsLabel.trailingAnchor.constraint(equalTo: repostsView.trailingAnchor, constant: -5 ),
        
        viewsImage.centerYAnchor.constraint(equalTo: viewsView.centerYAnchor),
        viewsImage.leadingAnchor.constraint(equalTo: viewsView.leadingAnchor, constant: 5),
        viewsImage.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        viewsImage.widthAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        
        viewsLabel.centerYAnchor.constraint(equalTo: viewsView.centerYAnchor),
        viewsLabel.leadingAnchor.constraint(equalTo: viewsImage.trailingAnchor, constant: 5),
        viewsLabel.heightAnchor.constraint(equalToConstant: CellConstants.kitHeight),
        viewsLabel.trailingAnchor.constraint(equalTo: viewsView.trailingAnchor, constant: -5 ),
        


    ])
}
    
    func setData(viewModel: FeedCellViewModel) {
        
        
        
        groupImage.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.post
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        repostsLabel.text = viewModel.reposts
        viewsLabel.text = viewModel.views

        
        postLabel.frame = viewModel.sizes.postLabelFrame
        moreButton.frame = viewModel.sizes.moreButtonFrame
         
        if let photo = viewModel.photos.first, viewModel.photos.count == 1 {
            postImage.set(imageURL: photo.photoUrl)
            postImage.isHidden = false
            galleryCollectionView.isHidden = true
            postImage.frame = viewModel.sizes.postImageFrame
        } else if viewModel.photos.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.postImageFrame
            postImage.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.set(photos: viewModel.photos)
        } else { 
            postImage.isHidden = true
            galleryCollectionView.isHidden = true
        } 
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
