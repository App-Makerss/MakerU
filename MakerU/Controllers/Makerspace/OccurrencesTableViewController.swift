//
//  OccurrencesTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 29/10/20.
//

import Foundation
import UIKit

class OccurrencesTableViewController: SingleTextTableViewController {
    let activityIndicatorManager = ActivityIndicatorManager()
    var selectedEquipment: Equipment?
    let occurrenceService = OccurrenceService()
    
    override var stringUpdate: String {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = stringUpdate != ""
        }
    }
    
    override func setupNavigations() {
        super.setupNavigations()
        navigationItem.title = "Ocorrência"
        navigationItem.rightBarButtonItem?.title = "Reportar"
        navigationItem.rightBarButtonItem?.isEnabled = false
        destructiveTitle = "Descartar Ocorrência"
        activityIndicatorManager.rightBarButtons = navigationItem.rightBarButtonItems!
    }
        
    override func okBarItemTapped() {
        super.okBarItemTapped()
        if !stringUpdate.isEmpty {
            activityIndicatorManager.startLoading(on: navigationItem)
            occurrenceService.report(problem: stringUpdate, onEquipment: selectedEquipment?.id) { (saved, error) in
                DispatchQueue.main.async { [self] in
                    if saved?.id != nil {
                        activityIndicatorManager.stopLoading(on: navigationItem)
                        presentSuccessAlert(title: "Ocorrência Reportada!", message: "Agradecemos a sua contribuição.") { _ in
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
