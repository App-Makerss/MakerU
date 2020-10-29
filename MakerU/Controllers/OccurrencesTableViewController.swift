//
//  OccurrencesTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import UIKit

class OccurrencesTableViewController: SingleTextTableViewController {
    
    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Ocorrência"
        navigationItem.rightBarButtonItem?.title = "Reportar"
        destructiveTitle = "Descartar Ocorrência"
    }
        
    override func okBarItemTapped() {
        super.okBarItemTapped()
        print("num é que deu...")
        presentSuccessAlert(title: "Ocorrência Reportada!", message: "Agradecemos a sua contribuição.") { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Descreva os problemas a serem tratados. Se possível, registre também a causa do problema."
    }
}
