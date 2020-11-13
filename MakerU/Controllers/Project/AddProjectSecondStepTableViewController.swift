//
//  AddProjectSecondStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 11/11/20.
//

import UIKit

class AddProjectSecondStepTableViewController: SingleTextTableViewController {

    var createProject: Project!

    override var stringUpdate: String {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = stringUpdate != ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        placeholderValue = "Ex: O QUE COLOCAMO AQUI??"
    }

    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Novo Projeto"
        navigationItem.rightBarButtonItem?.title = "Próximo"
        navigationItem.rightBarButtonItem?.isEnabled = false

        navigationItem.leftBarButtonItems?.removeAll()
        navigationController?.navigationBar.tintColor = .systemPurple

        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "DESCRIÇÃO"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Adicione uma breve descrição para que seja possível conhecer seu projeto em maiores detalhes."
    }


    override func okBarItemTapped() {
        if stringUpdate != "" {
            createProject.description = stringUpdate
            let vc = AddProjectThirdStepTableViewController(style: .insetGrouped)
            vc.createProject = createProject
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
