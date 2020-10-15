//
//  MatchViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import UIKit

class MatchViewController: UIViewController {
    
    let configDisplayButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Configurações de exibição", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(Self.configDisplayButtonTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(configDisplayButton)
        view.backgroundColor = .systemBackground
        
        configDisplayButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        configDisplayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        configDisplayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        configDisplayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -99).isActive = true
        
        setupNavigations()
    }
    
    func setupNavigations() {
        navigationItem.title = "Encontrar pessoas"
        let item = UITabBarItem()
        item.title = "Match"
        item.image = UIImage(systemName: "square.fill.on.square.fill")
        self.tabBarItem = item
    }
    
    @objc func configDisplayButtonTapped() {
        let displayConfigurationVC = MatchDisplayConfigurationTableViewController()
        let navigation = UINavigationController(rootViewController: displayConfigurationVC)
        present(navigation, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
