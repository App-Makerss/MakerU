//
//  LoginTitleViewController.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 11/11/20.
//

import Foundation
import UIKit
import AuthenticationServices

class LoginTitleViewController: UITableViewController {
    var user: User?
    
    var userIdentifierLabel: String?
    var givenNameLabel: String?
    var familyNameLabel: String?
    var emailLabel: String?
    var userOcupation: String?
    
    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigations()
        hideKeyboardWhenTappedAround()

        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func setupNavigations() {
        navigationItem.title = "Cadastre-se"
        navigationItem.backButtonTitle = "Voltar"
        navigationItem.backBarButtonItem?.tintColor = UIColor.systemPurple

        let nextButtonItem = UIBarButtonItem(title: "Próximo", style: .done, target: self, action: #selector(self.nextButtonItemTapped))
        nextButtonItem.tintColor = UIColor.systemPurple
        nextButtonItem.isEnabled = false

        self.navigationItem.rightBarButtonItem = nextButtonItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UITableViewHeaderFooterView()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "INFORMAÇÕES PESSOAIS" : ""
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Confirme seu nome e adicione um título para que outros usuários conheçam sua ocupação." : ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.row {
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
            cell.textLabel?.text = "Nome"
            cell.detailTextLabel?.text = givenNameLabel
            cell.accessibilityHint = "toque duas vezes para editar"
            cell.detailTextLabel?.textColor = .systemPurple
            resultCell = cell
        case 2:
            let cell = FormFieldTableViewCell()
            cell.label.text = "Título"
            cell.detailTextLabel?.text = userOcupation
            resultCell = cell
        default:
            let cell = FormFieldTableViewCell()
            cell.label.text = "Título"
            cell.detailTextLabel?.text = userOcupation
            resultCell = cell
        }
        return resultCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 1 && indexPath.row == 2 {
            return 0
        }
        return UITableView.automaticDimension
    }


    @objc func nextButtonItemTapped() {
        if userOcupation != "" {
            let vc = LoginBioViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

