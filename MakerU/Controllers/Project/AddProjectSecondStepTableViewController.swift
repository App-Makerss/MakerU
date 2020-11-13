//
//  AddProjectSecondStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 11/11/20.
//

import UIKit

class AddProjectSecondStepTableViewController: SingleTextTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Novo Projeto"
        navigationItem.rightBarButtonItem?.title = "Próximo"

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TextViewTableViewCell
        cell.textView.placeholder = "Ex: Sou apaixonado por fotografia e trabalho com projetos de cenografia."

        return cell
    }

}
