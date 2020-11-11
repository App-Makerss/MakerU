//
//  ProfileViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 10/11/20.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Inits
    fileprivate func initItems() {
        let item =  UITabBarItem()
        item.title = "Perfil"
        item.image = UIImage(systemName: "person.crop.circle.fill")
        self.tabBarItem = item
        navigationItem.title = "Perfil"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
