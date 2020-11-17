//
//  LoginBioViewController.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 11/11/20.
//

import Foundation
import UIKit

class LoginBioViewController: SingleTextTableViewController {
    
    var createUser: User!

    override var stringUpdate: String {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = stringUpdate != ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Cadastre-se"
        navigationItem.rightBarButtonItem?.title = "Concluir"
        navigationItem.rightBarButtonItem?.isEnabled = false

        navigationItem.leftBarButtonItems?.removeAll()
        navigationController?.navigationBar.tintColor = .systemPurple

        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)

        // button back at secondStep
        navigationItem.backButtonTitle = "Voltar"
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "BIO"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Confirme seu nome e adicione um título para que outros usuários conheçam sua ocupação."
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }


    override func okBarItemTapped() {
        if stringUpdate != "" {
            UserDAO().save(entity: createUser) { (savedUser, error) in
                if let savedUser = savedUser {
                    UserDefaults.standard.setValue(savedUser.id!, forKey: "loggedUserId")
                    
                }else {
                    print(error?.localizedDescription)
                }
            }
            //TODO: fazer um dissmiss
            dismiss(animated: true, completion: nil)
            
//            let vc = AddProjectThirdStepTableViewController(style: .insetGrouped)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
