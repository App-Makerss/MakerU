//
//  ReservationTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 30/10/20.
//

import UIKit

enum ReservationTableViewControllerPickerViews {
    case category
    case dateAndTime
    case time
    case none
}

class ReservationTableViewController: UITableViewController {
    
    var datetimeUpdates: [String: Date] = [:]
    
    var selectedCategory: Category? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    var categories: [Category] = []
    
    var selectedProject: Project? {
        didSet {
            if selectedProject?.id == nil && !categories.isEmpty {
                selectedCategory = categories.first(where: {$0.id == selectedProject?.category}) ?? categories.first
            }
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    var projects: [Project] = [] {
        didSet {
            selectedProject = projects.first
        }
    }
    
    var selectedDate: Date? = Date()
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .inline
        dp.minuteInterval = 5
        dp.minimumDate = Date()
        dp.tintColor = .systemPurple
        dp.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        dp.locale = Locale.init(identifier: "pt-BR")//TODO: remover quando a apple corrigir
        return dp
    }()
    
    var pickerKind: ReservationTableViewControllerPickerViews = .none{
        didSet {
            if oldValue == pickerKind {
                pickerKind = .none
                isInlinePickerVisible = false
            }
        }
    }
    
    var isInlinePickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([0,1], with: .automatic)
            }
        }
    }
    
    let projectService = ProjectService()

    func setupNavigations() {
        navigationItem.title = "Agendamento"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        let okButtonItem = UIBarButtonItem(title: "Confirmar", style: .done, target: self, action: #selector(self.okBarItemTapped))
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
        setupNavigations()
        hideKeyboardWhenTappedAround()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
        projectService.listLoggedUserProjectsSortedByCreationDate(by: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77") { (projects, error) in
            if let projects = projects{
                self.projects = projects
            }
        }
        
        CategoryDAO().listAll { (categories, error) in
            print(error?.localizedDescription)
            if let categories = categories {
                self.categories = categories
            }
        }
    }
    
    var projectSectionRowCount: Int {
        if selectedProject == nil || selectedProject?.id == nil{
            if isInlinePickerVisible && pickerKind == .category {
                return 4
            }
            return 3
        }
        return 1
    }

    var dateSelectorsRowCount: Int {
        isInlinePickerVisible && pickerKind == .time ? 4 : 3
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? dateSelectorsRowCount : projectSectionRowCount
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Associe uma atividade a sua reserva" : ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
            case 1:
                switch indexPath.row {
                    case 1:
                        resultCell.contentView.addSubview(datePicker)
                        datePicker.setupConstraints(to: resultCell.contentView)
                        break
                    case 2:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Termina"
                        cell.detailTextLabel?.textColor = (isInlinePickerVisible && pickerKind == .time) ? .systemPurple : .label
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .none
                        dateFormatter.timeStyle = .short
                        dateFormatter.locale = Locale.init(identifier: "pt-BR")
                        cell.detailTextLabel?.text = dateFormatter.string(from: datetimeUpdates["time"] ?? Date())
                        cell.accessibilityHint = "Toque duas vezess para editar"
                        resultCell = cell
                        break
                    case 3:
                        let cell = TimePickerTableViewCell()
                        cell.textLbl.text = "Horário"
                        cell.timePicker.addTarget(self, action: #selector(self.timePickerValueChanged(sender:)), for: .valueChanged)
                        cell.timePicker.minimumDate = datetimeUpdates["date&time"] ?? selectedDate
                        resultCell = cell
                        break
                    default:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Começa"
                        cell.detailTextLabel?.textColor = (isInlinePickerVisible && pickerKind == .dateAndTime) ? .systemPurple : .label
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        dateFormatter.locale = Locale.init(identifier: "pt-BR")
                        cell.detailTextLabel?.text = dateFormatter.string(from: selectedDate!)
                        cell.accessibilityHint = "Toque duas vezess para editar"
                        resultCell = cell
                        break
                }
            default:
                switch indexPath.row {
                    case 1:
                        let cell = FormFieldTableViewCell()
                        cell.label.text = "Título"
                        cell.value.text = selectedProject?.title
                        cell.value.addTarget(self, action: #selector(Self.newProjectTitleValueChanged(sender:)), for: .editingDidEnd)
                        resultCell = cell
                    case 2:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Categoria"
                        cell.detailTextLabel?.text = selectedCategory?.name
                        cell.detailTextLabel?.textColor = (isInlinePickerVisible && pickerKind == .category) ? .systemPurple : .secondaryLabel
                        resultCell = cell
                    case 3:
                        let items = categories.map({
                            GenericRow<Category>(type: $0, showText: $0.name)
                        })
                        let cell = PickerViewTableViewCell<Category>(withItems:items)
                        cell.selectedItem = items.first
                        cell.pickerDelegate = self
                        resultCell = cell
                    default:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "project")
                        cell.textLabel?.text = "Atividade"
                        var detailText: String?
                        if selectedProject != nil && selectedProject?.id != nil  && selectedProject?.title != "" {
                            detailText = selectedProject?.title
                        }else {
                            detailText = "Novo projeto"
                        }
                        cell.detailTextLabel?.text = detailText
                        cell.accessoryType = .disclosureIndicator
                        resultCell = cell
                }
                break
        }

        return resultCell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 1 && indexPath.row == 1 && ( pickerKind != .dateAndTime) {
            return 0
        }
        return UITableView.automaticDimension
    }
    func openProjectSelectorTableView() {
        var items = projects.map({
            GenericRow<Project>(type: $0, showText: $0.title)
        })
        items.insert(GenericRow<Project>(type: Project(), showText: "Novo projeto"), at: 0)
        let vc = PickerViewTableViewController(withItems: items)
        vc.selectedItem = selectedProject != nil ? GenericRow<Project>(type: selectedProject!, showText: selectedProject!.title) : items.first
        vc.pickerDelegate = self
        vc.navigationItem.title = "Atividade"
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 1:
                switch row {
                    case 0,2:
                        isInlinePickerVisible = true
                        if row == 0 {
                            pickerKind = .dateAndTime
                        }else {
                            pickerKind = .time
                        }
                    default:
                        isInlinePickerVisible = false
                }
            default:
                switch row {
                    case 2:
                        isInlinePickerVisible = true
                        pickerKind = .category
                    default:
                        if row == 0 {
                            openProjectSelectorTableView()
                        }
                        isInlinePickerVisible = false
                }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    //MARK: - objc funcs
    @objc func cancelBarItemTapped() {
        
        if  !datetimeUpdates.isEmpty || (selectedProject?.id == nil && selectedProject?.title != "") {
            presentDiscardChangesActionSheet { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }else  {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func okBarItemTapped() {
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date
        datetimeUpdates["date&time"] = sender.date
        datetimeUpdates["time"] = sender.date
        let datePickerHeaderRow = IndexPath(row: 0, section: 1)
        let timePickerHeaderRow = IndexPath(row: 2, section: 1)
        tableView.reloadRows(at: [datePickerHeaderRow,timePickerHeaderRow], with: .automatic)
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        datetimeUpdates["time"] = sender.date
        let datePickerHeaderRow = IndexPath(row: 2, section: 1)
        tableView.reloadRows(at: [datePickerHeaderRow], with: .automatic)
    }
    
    @objc func newProjectTitleValueChanged(sender: UITextField) {
        selectedProject?.title = sender.text ?? ""
    }
}

extension ReservationTableViewController: PickerViewTableViewControllerDelegate {
    func pickerTableViewDidSelected(_ viewController: UIViewController, item: Any) {
        navigationController?.popViewController(animated: true)
        if let row = item as? GenericRow<Project> {
            selectedProject = row.type
        }
    }
}

extension ReservationTableViewController: PickerViewTableViewCellDelegate {
    func pickerCellDidSelected(item: Any) {
        if let row = item as? GenericRow<Category> {
            selectedProject?.category = row.type.id ?? ""
        }
    }
}
