//
//  AddProjectFifthStepTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/11/20.
//

import UIKit

class AddProjectFifthStepTableViewController: UITableViewController {
    
    let projectService = ProjectService()
    let activityIndicatorManager = ActivityIndicatorManager()
    
    var createProject: Project!{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .none)
            }
        }
    }
    
    var isInlinePickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Novo Projeto"
        let nextButtonItem = UIBarButtonItem(title: "Concluir", style: .done, target: self, action: #selector(self.finishButtonItemTapped))
        nextButtonItem.tintColor = UIColor.systemPurple
        
        self.navigationItem.rightBarButtonItem = nextButtonItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        // button back at secondStep
        navigationItem.backButtonTitle = "Voltar"
        activityIndicatorManager.rightBarButtons = navigationItem.rightBarButtonItems!
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isInlinePickerVisible ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Estado de andamento"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Selecione um estado que represente o estágio de desenvolvimento do seu projeto."
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell!
        switch indexPath.row {
            case 1:
                let items = ProjectStatus.allCases.compactMap{GenericRow<ProjectStatus>(type: $0, showText: $0.stringValue.capitalized)}
                let cell = PickerViewTableViewCell(withItems: items)
                cell.selectedItem = items.first{$0.type == createProject.status}
                cell.pickerDelegate = self
                resultCell = cell
            default:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                cell.textLabel?.text = "Estado"
                cell.detailTextLabel?.text = createProject.status.stringValue.capitalized
                cell.accessibilityHint = "toque duas vezes para editar"
                cell.detailTextLabel?.textColor = (isInlinePickerVisible) ? .systemPurple : .secondaryLabel
                resultCell = cell
        }
        
        return resultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            isInlinePickerVisible.toggle()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func finishButtonItemTapped() {
        DispatchQueue.main.async {
            self.activityIndicatorManager.startLoading(on: self.navigationItem)
        }
        projectService.saveIfNeeded(createProject) { (projectSaved, error, wasNeeded) in
            if wasNeeded && projectSaved?.id != nil{
                DispatchQueue.main.async {
                    self.activityIndicatorManager.stopLoading(on: self.navigationItem)
                }
                self.presentSuccessAlert(title: "Projeto adicionado!", message: "Agora você pode encontrar pessoas ou projetos semelhantes para colaboração.") { _ in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
}

extension AddProjectFifthStepTableViewController: PickerViewTableViewCellDelegate{
    func pickerCellDidSelected(item: Any) {
        if let row = item as? GenericRow<ProjectStatus> {
            createProject.status = row.type
        }
    }
}
