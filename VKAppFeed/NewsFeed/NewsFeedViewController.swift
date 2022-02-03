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
    
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .systemIndigo
        return table
    }()
    
    private var titleView = TitleView()
    
    // MARK: fetcher
    
  var interactor: NewsfeedBusinessLogic?
  var router: (NSObjectProtocol & NewsfeedRoutingLogic)?

    private var feedViewModel = FeedViewModel.init(cells: [])
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsfeedInteractor()
    let presenter             = NewsfeedPresenter()
    let router                = NewsfeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }

    
    // do no use - only for exp
    
    private func updateLayout(with size: CGSize) {
       self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func addConstraints() -> () {
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupAll() -> () {
        setup()
        setupTopBar()
        view.addSubview(tableView)
        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCell.reuseId)
        addConstraints()
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
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
        
    }
  
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
      
      switch viewModel {

      case .displayNewsFeed(feedViewModel: let feedViewModel):
          self.feedViewModel = feedViewModel
          tableView.reloadData()
      case .displayUser(userViewModel: let userViewModel):
          titleView.set(userViewModel: userViewModel)
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
        print("\(tableView.subviews.count) common cells")
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



