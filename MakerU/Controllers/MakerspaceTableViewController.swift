//
//  MakerspaceTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 22/10/20.
//

import UIKit

class MakerspaceTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = navigationController as? ImageCoverNavigationController
        navigationItem.scrollEdgeAppearance = nav?.configureAppearance(image: UIImage(named: "test"))
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
extension MakerspaceTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navBar  = self.navigationController?.navigationBar
        else {return}
        
        let navBarHeight = navBar.bounds.height
        if navBarHeight >= 46{
            navBar.tintColor = .white
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        } else if navBarHeight <= 103 {
            navBar.tintColor = .link
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
