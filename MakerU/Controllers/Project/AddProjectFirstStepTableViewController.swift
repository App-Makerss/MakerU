//
//  AddProjectFirstStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 09/11/20.
//

import UIKit

class AddProjectFirstStepTableViewController: UITableViewController, PickerViewTableViewCellDelegate {

    var categories: [Category] = [] {
        didSet {
            if !categories.isEmpty {
                selectedProject?.category = categories.first!.id!
            }
        }
    }
    let projectService = ProjectService()

    var selectedCategory: Category? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }

    var selectedProject: Project? = Project() {
        didSet {
            if selectedProject?.id == nil && !categories.isEmpty {
                selectedCategory = categories.first(where: {$0.id == selectedProject?.category}) ?? categories.first
            }
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigations()
        hideKeyboardWhenTappedAround()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        CategoryDAO().listAll { (categories, error) in
            print(error?.localizedDescription)
            if let categories = categories {
                self.categories = categories
            }
        }
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

//        let okButtonItem = UIBarButtonItem(title: "Confirmar", style: .done, target: self, action: #selector(self.okBarItemTapped))
//        okButtonItem.tintColor = UIColor.systemPurple


//        self.navigationItem.rightBarButtonItem = okButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
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
            cell.selectedItem = items.first
            cell.pickerDelegate = self
            resultCell = cell
        default:
            let cell = FormFieldTableViewCell()
            cell.label.text = "Título"
            cell.value.text = selectedProject?.title
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

    func pickerTableViewDidSelected(_ viewController: UIViewController, item: Any) {
        navigationController?.popViewController(animated: true)
        if let row = item as? GenericRow<Project> {
            selectedProject = row.type
        }
    }

    func pickerCellDidSelected(item: Any) {
        if let row = item as? GenericRow<Category> {
            selectedProject?.category = row.type.id ?? ""
        }
    }

    @objc func newProjectTitleValueChanged(sender: UITextField) {
        selectedProject?.title = sender.text ?? ""
    }

    @objc func cancelBarItemTapped() {
        if  selectedProject?.title != "" {
            presentDiscardChangesActionSheet { _ in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
