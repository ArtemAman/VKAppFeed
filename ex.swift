//
//  ex.swift
//  
//
//  Created by Artyom Amankeldiev on 27.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var textFieldWidthConstraint: NSLayoutConstraint!
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.alpha = 0.3
    
        return view
    }()
    
    private lazy var textField: TextField = {
        let field = TextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Сумма"
        field.font = .systemFont(ofSize: 14)
        field.textAlignment = .right
        field.rightLabel = "₽"
        
        return field
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableHeaderView = header
        
        return table
    }()
    
    lazy var header = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table"
        
        view.addSubview(separatorView)
        view.addSubview(textField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        textFieldWidthConstraint = textField.widthAnchor.constraint(equalToConstant: 0)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! HeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    func calculateTextHeight(forText text: String?) -> CGFloat {
        guard let text = text else {
            return 0
        }
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize: 14)]

        let attributedString : NSAttributedString = NSAttributedString(string: text, attributes: attributes)
        let rect: CGRect = attributedString.boundingRect(with: CGSize(width: CGFloat(UIScreen.main.bounds.width - 20 * 2),
                                                                      height: 40),
                                                         options: .usesLineFragmentOrigin, context: nil)
        let height = rect.height
        return height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let textSize = calculateTextHeight(forText: textField.text)
        textFieldWidthConstraint.constant = textSize
        view.layoutSubviews()
    }
    
}


extension UIViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .brown
        vc.title = "VIewController"
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc1 = UIViewController()
            vc1.view.backgroundColor = .red
            nc.pushViewController(vc1, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            nc.popViewController(animated: true)
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Section"
    }
    
}
