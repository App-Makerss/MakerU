//
//  ApplyForMonitoringTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import UIKit

class ApplyForMonitoringTableViewController: SingleTextTableViewController {
    
    let monitorInterestService = MonitorInterestService()
    
    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Monitoria"
        navigationItem.rightBarButtonItem?.title = "Aplicar"
    }
    
    override func okBarItemTapped() {
        super.okBarItemTapped()
        if !stringUpdate.isEmpty {
            monitorInterestService.submitInterest(message: stringUpdate) { (saved, error) in
                DispatchQueue.main.async {
                    if saved?.id != nil {
                        self.presentSuccessAlert(title: "Mensagem enviada!", message: "Agradecemos seu contato.") { _ in
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
        "Manifeste seu interesse em ser monitor. Não esqueça de enviar seu contato. Se possível, passe informações sobre sua disponibilidade de horários."
    }
}
