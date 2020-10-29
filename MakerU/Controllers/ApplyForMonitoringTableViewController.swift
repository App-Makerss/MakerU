//
//  ApplyForMonitoringTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import UIKit

class ApplyForMonitoringTableViewController: SingleTextTableViewController {
    
    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Monitoria?"
        navigationItem.rightBarButtonItem?.title = "Enviar?"
    }
    
    override func okBarItemTapped() {
        super.okBarItemTapped()
        print("num é que deu...")
        presentSuccessAlert(title: "Interesse Enviado!?", message: "Qual o texto?") { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Qual o texto?"
    }
}
