//
//  OccurrencesTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import UIKit

class OccurrencesTableViewController: SingleTextTableViewController {
    
    var selectedEquipment: Equipment?
    
    let occurrenceService = OccurrenceService()
    
    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Ocorrência"
        navigationItem.rightBarButtonItem?.title = "Reportar"
        destructiveTitle = "Descartar Ocorrência"
    }
        
    override func okBarItemTapped() {
        super.okBarItemTapped()
        if !stringUpdate.isEmpty {
            occurrenceService.report(problem: stringUpdate, onEquipment: selectedEquipment?.id) { (saved, error) in
                DispatchQueue.main.async {
                    if saved?.id != nil {
                        self.presentSuccessAlert(title: "Ocorrência Reportada!", message: "Agradecemos a sua contribuição.") { _ in
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Descreva os problemas a serem tratados. Se possível, registre também a causa do problema."
    }
}
