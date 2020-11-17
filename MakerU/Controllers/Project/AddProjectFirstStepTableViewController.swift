//
//  AddProjectFirstStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 09/11/20.
//

import UIKit

class AddProjectFirstStepTableViewController: UITableViewController, PickerViewTableViewCellDelegate {
    
    var selectedCategory: Category? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    var createProject: Project = Project() {
        didSet {
            if createProject.id == nil && !categories.isEmpty {
                selectedCategory = categories.first(where: {$0.id == createProject.category}) ?? categories.first
                createProject.category = selectedCategory?.id ?? ""
            }
            DispatchQueue.main.async { [self] in
                if createProject.title != "" && createProject.category != "" {
                    navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    navigationItem.rightBarButtonItem?.isEnabled = false
                }
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigations()
        hideKeyboardWhenTappedAround()
        createProject.category = categories.first!.name
        
        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    var projectSectionRowCount: Int {
        if isInlinePickerVisible {
            return 3
        }
        return 2
    }
    
    var isInlinePickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    func setupNavigations() {
        navigationItem.title = "Novo Projeto"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        let nextButtonItem = UIBarButtonItem(title: "Próximo", style: .done, target: self, action: #selector(self.nextButtonItemTapped))
        nextButtonItem.tintColor = UIColor.systemPurple
        nextButtonItem.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = nextButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
        
        // button back at secondStep
        navigationItem.backButtonTitle = "Voltar"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "IDENTIFICAÇÃO" : ""
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Adicione um título e selecione uma categoria para identificar seu projeto." : ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectSectionRowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
            case 1:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                cell.textLabel?.text = "Categoria"
                cell.detailTextLabel?.text = selectedCategory?.name
                cell.accessibilityHint = "toque duas vezes para editar"
                cell.detailTextLabel?.textColor = (isInlinePickerVisible) ? .systemPurple : .secondaryLabel
                resultCell = cell
            case 2:
                let items = categories.map({
                    GenericRow<Category>(type: $0, showText: $0.name)
                })
                let cell = PickerViewTableViewCell<Category>(withItems:items)
                cell.selectedItem = items.first(where: {$0.type.id == createProject.category})
                cell.pickerDelegate = self
                resultCell = cell
            default:
                let cell = FormFieldTableViewCell()
                cell.label.text = "Título"
                cell.value.text = createProject.title
                cell.value.addTarget(self, action: #selector(Self.newProjectTitleValueChanged(sender:)), for: .editingDidEnd)
                resultCell = cell
        }
        return resultCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row == 1 {
            isInlinePickerVisible.toggle()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 1 && indexPath.row == 2 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    //MARK: - PickerView
    func pickerCellDidSelected(item: Any) {
        if let row = item as? GenericRow<Category> {
            createProject.category = row.type.id!
        }
    }
    
    //MARK: - objc funcs
    @objc func newProjectTitleValueChanged(sender: UITextField) {
        createProject.title = sender.text ?? ""
    }
    
    @objc func cancelBarItemTapped() {
        if  createProject.title != "" {
            presentDiscardChangesActionSheet { _ in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func nextButtonItemTapped() {
        if createProject.title != "" && createProject.category != "" {
            let vc = AddProjectSecondStepTableViewController(style: .insetGrouped)
            vc.createProject = createProject
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
