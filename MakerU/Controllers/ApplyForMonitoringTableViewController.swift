//
//  ApplyForMonitoringTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 28/10/20.
//

import UIKit

class ApplyForMonitoringTableViewController: UITableViewController {
    
    var stringUpdate: String = ""

    func setupNavigations() {
        navigationItem.title = "Monitoria?"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar?", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
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
        tableView.register(UINib(nibName: "SkillsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SkillsTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "vai ter texto aqui?"
    }
    
    @objc func cancelBarItemTapped() {
        
        if stringUpdate.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }else  {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Descartar Alterações", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @objc func okBarItemTapped() {
        
    }
}


extension ApplyForMonitoringTableViewController: SkillsTableViewCellDelegate {
    func skillsDidChanged(skills: String) {
        //TODO: Do something with the text
        stringUpdate = skills
    }
    
    
}
