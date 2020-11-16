//
//  AddProjectFourthStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 12/11/20.
//

import UIKit

class AddProjectFourthStepTableViewController: SingleTextTableViewController {

    override var stringUpdate: String {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = stringUpdate != ""
        }
    }
    var createProject: Project!

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderValue = "Ex: Bruno Ambrosio e Gabriel Branco"
    }

    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Novo Projeto"
        navigationItem.rightBarButtonItem?.title = "Próximo"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItems?.removeAll()
        navigationController?.navigationBar.tintColor = .systemPurple
        
        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        
        // button back at secondStep
        navigationItem.backButtonTitle = "Voltar"
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Autores"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Adicione o nome dos responsáveis pelo seu projeto. Este item é opcional."
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        104
    }
    
    
    override func okBarItemTapped() {
        if stringUpdate != "" {
            createProject.collaborators = stringUpdate
            let vc = AddProjectFifthStepTableViewController(style: .insetGrouped)
            vc.createProject = createProject
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
