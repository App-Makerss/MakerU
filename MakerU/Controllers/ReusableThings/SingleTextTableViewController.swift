//
//  SingleTextTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 28/10/20.
//

import UIKit

class SingleTextTableViewController: UITableViewController {
    
    var destructiveTitle: String? = nil
    
    var stringUpdate: String = ""
    var placeholderValue: String?

    func setupNavigations() {
        navigationItem.title = "Monitoria?"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        let okButtonItem = UIBarButtonItem(title: "Enviar?", style: .done, target: self, action: #selector(self.okBarItemTapped))
        okButtonItem.tintColor = UIColor.systemPurple
        
        
        self.navigationItem.rightBarButtonItem = okButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        setupNavigations()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextViewTableViewCell
        cell.textView.text = stringUpdate
        cell.textView.placeholder = placeholderValue
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }

    @objc func cancelBarItemTapped() {
        
        if stringUpdate.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }else  {
            presentDiscardChangesActionSheet(destructiveTitle: destructiveTitle) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func okBarItemTapped() {

    }
}


extension SingleTextTableViewController: TextViewTableViewCellDelegate {
    @objc func textDidChanged(_ text: String) {
        //TODO: Do something with the text
        stringUpdate = text
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "managePlaceholderVisibility"), object: nil)
    }
}
