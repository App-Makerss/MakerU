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


    }


}
