//
//  UIViewController+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 28/10/20.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func presentDiscardChangesActionSheet(destructiveTitle: String? = nil, onDiscardHandler: ((UIAlertAction) -> Void)? = nil) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: destructiveTitle ?? "Descartar Alterações", style: .destructive, handler: onDiscardHandler)
        actionSheet.view.tintColor = .systemPurple
        
        
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentSuccessAlert(title: String, message: String, onOKHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: onOKHandler)
        alert.view.tintColor = .systemPurple
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
