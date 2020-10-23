//
//  MakerspaceTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 22/10/20.
//

import UIKit

class MakerspaceTableViewController: UITableViewController {
    var scrollEdgeAppearanceTintColor: UIColor = .white
    var defaultTintColor: UIColor = .systemPurple
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCoverImage(image: UIImage(named: "test"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        let item =  UITabBarItem()
        item.title = "Espaço"
        item.image = UIImage(systemName: "house.fill")
        self.tabBarItem = item
        navigationItem.title = "Espaço"
        setupNavigationBarColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(MakerspaceTableViewController(style: .insetGrouped), animated: true)
    }
}

//MARK: scrollViewDelegate
extension MakerspaceTableViewController: ScrollableCover {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}
