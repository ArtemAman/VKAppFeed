//
//  NewsFeedViewController.swift
//  VKAppFeed
//
//  Created by Artyom Amankeldiev on 03.02.2022.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
    
    
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsCellButtonPressDelegate{
    
    
    private lazy var gradientLayer: UIView = GradientView()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset.top = 8
        return table
    }()
    
    
    private lazy var topBar:UIView = {
        let topBar = UIView()
        topBar.layer.backgroundColor = UIColor.white.cgColor
        topBar.layer.shadowOpacity = 0.3
        topBar.layer.shadowOffset = CGSize.zero
        topBar.layer.shadowRadius = 8
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.isHidden = true
        return topBar
    }()
    
    
    private var refreshControll:UIRefreshControl =  {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControll
    } ()
    
    private lazy var titleView = TitleView()
    private lazy var footerView = FooterView()
    
    // MARK: fetcher
    
  var interactor: NewsfeedBusinessLogic?
  var router: (NSObjectProtocol & NewsfeedRoutingLogic)?

    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsfeedInteractor()
    let presenter             = NewsfeedPresenter()
    let router                = NewsfeedRouter()
    viewController.interactor =  interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }

    
    private func addConstraints() -> () {
        
        NSLayoutConstraint.activate([
            
            gradientLayer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            gradientLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            gradientLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            gradientLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            
        ])
    }
    
    private func setupAll() -> () {
        setup()
        view.addSubview(gradientLayer)
        view.addSubview(tableView)
        setupTopBar()
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCell.reuseId)
        
        addConstraints()
        
        tableView.addSubview(refreshControll)
        tableView.tableFooterView = footerView
    }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
      setupAll()
      interactor?.makeRequest(request: .getNewsFeed)
      interactor?.makeRequest(request: .getUser)
      
      
  }
    
    
    private func setupTopBar() {
        
        self.view.addSubview(topBar)
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
        
    }
  
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
      
      switch viewModel {

      case .displayNewsFeed(feedViewModel: let feedViewModel):
          self.feedViewModel = feedViewModel
          footerView.setTitle(title: feedViewModel.footerTitle)
          tableView.reloadData()
          
          refreshControll.endRefreshing()
      case .displayUser(userViewModel: let userViewModel):
          titleView.set(userViewModel: userViewModel)
      case .displayFooterLoader:
          footerView.showLoader()
      }
  
  }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getextBatch)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (scrollView.contentOffset.y <= 0){
            topBar.isHidden = true
        } else {
            guard let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height else { return }
            guard height != 0 else { return }
            topBar.heightAnchor.constraint(equalToConstant: height).isActive = true
            topBar.updateConstraints()
            topBar.isHidden = false

        }
    }
    
    
    
    func revealPost(cell: NewsFeedCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedViewModel.cells.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseId, for: indexPath) as! NewsFeedCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.setData(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        interactor?.makeRequest(request: .getNewsFeed)
        
//        let vc = UIViewController()
//        vc.view.backgroundColor = .brown
//        vc.title = "VIewController"
//        let nc = UINavigationController(rootViewController: vc)
//        present(nc, animated: true, completion: nil)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let vc1 = UIViewController()
//            vc1.view.backgroundColor = .red
//            nc.pushViewController(vc1, animated: true)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            nc.popViewController(animated: true)
//        }
    }
    
    
}



