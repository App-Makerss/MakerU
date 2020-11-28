//
//  LoginBioViewController.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 11/11/20.
//

import Foundation
import UIKit

class LoginBioViewController: SingleTextTableViewController {
    
    var user: User!

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
        placeholderValue = "Ex: Sou apaixonado por fotografia e trabalho com projetos de cenografia."
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
        "Adicione uma descrição pessoal para que outros usuários possam te conhecer melhor."
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }


    override func okBarItemTapped() {
        if stringUpdate != "" {
            self.user.description = stringUpdate
            let nextVC = LoginImageTableViewController(style: .insetGrouped)
            nextVC.user = self.user
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
