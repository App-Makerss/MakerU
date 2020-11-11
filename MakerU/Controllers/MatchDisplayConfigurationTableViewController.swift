//
//  MatchDisplayConfigurationTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import UIKit

class MatchDisplayConfigurationTableViewController: UITableViewController {

    var isPickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }
    }
    var isPreviewEnabled: Bool {
        if configSegmentedControl.selectedSegmentIndex == 1 && selectedProject?.id != nil {
            return true
        }else if configSegmentedControl.selectedSegmentIndex == 0 {
            return true
        }
        return false
    }
    
    var selectedProject: Project? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                self.tableView.reloadSections([1,2,3], with: .automatic)
            }
        }
    }
    var selectedUser: User? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadSections([1,2,3], with: .automatic)
            }
        }
    }

    var projects: [Project] = [] {
        didSet {
            reloadRowOrSection(at: IndexPath(row: 1, section: 1), numberOfRowsValidation: 2)
        }
    }
    
    var secondSectionRowCount: Int {
        configSegmentedControl.selectedSegmentIndex == 1 && isPickerVisible ? 2 : 1
    }
    
    func reloadRowOrSection(at indexPath: IndexPath, numberOfRowsValidation: Int) {
        DispatchQueue.main.async {
            if self.tableView.numberOfRows(inSection: indexPath.section) >= numberOfRowsValidation {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }else {
                self.tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
    }
    
    var stringUpdates: [String: String] = [:]
    var boolUpdates: [String: Bool] = [:]

    let projectService = ProjectService()

    let configSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Perfil", "Projeto"])
        segmented.backgroundColor = .clear
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(Self.selectedSegmentChanged), for: .valueChanged)

        return segmented
    }()
    
    func setupNavigations() {
        navigationItem.title = "Exibição"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        let okButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.okBarItemTapped))
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
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ProjectDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectDescriptionTableViewCell")
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
        tableView.register(UINib(nibName: "ShowProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowProfileTableViewCell")

        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
        UserDAO().find(byId: loggedUserID) { (user, error) in
            if let user = user {
                self.selectedUser = user
            }
        }
        projectService.listAllProjectsOfLoggedUser(by: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77") { (projects, error) in
            if let projects = projects, let firstProject =  projects.first {
                self.projects = projects
                self.selectedProject = firstProject
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 1 {
            rowCount = secondSectionRowCount
        }else if section == 3 {
            rowCount = isPreviewEnabled ? 2 : 1
        }else {
             rowCount = 1
        }
        return rowCount
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 && configSegmentedControl.selectedSegmentIndex == 1 && selectedProject?.id != nil{
            isPickerVisible.toggle()
        }else if indexPath.section == 3 && indexPath.row == 0 {
            
            var previewCard: MatchCard? = nil
            if configSegmentedControl.selectedSegmentIndex == 0 {
                previewCard = MatchCard(from: selectedUser!)
                previewCard?.secondSessionLabel = stringUpdates["userSkills"] ?? selectedUser?.skills ?? ""
            }else if selectedProject?.id != nil{
                previewCard = MatchCard(from: selectedProject!, with: categories.first(where:{$0.id == selectedProject!.category})!)
                previewCard?.secondSessionLabel = stringUpdates["projectSkills"] ?? selectedProject?.skillsInNeed ?? ""
            }
            if previewCard != nil {
                let displayInfoVC = MatchCardInfoViewController()
                
                displayInfoVC.config(with: previewCard!)
                let navigation = UINavigationController(rootViewController: displayInfoVC)
                    present(navigation, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return configSegmentedControl.selectedSegmentIndex == 0 ? "Habilidades pessoais" : "Habilidades procuradas"
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            case 1:
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    return "Acesse seu perfil caso deseje alterar informações."
                }else {
                    if selectedProject?.id != nil {
                        return "Selecione um de seus projetos para ser exibido."
                    }
                    return "Adicione um projeto a sua conta para poder exibi-lo."
                }
            case 2:
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    return "Descreva brevemente suas habilidades que podem ser úteis para colaboração em projetos."
                }else {
                    return "Descreva brevemente as habilidades desejáveis no perfil de um possível colaborador para o projeto."
                }
            case 3:
                return "Ao habilitar a exibição, as informações acima estarão visíveis para os demais usuários do espaço."
            default:
               return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 2 {
            return 16
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 2{
            return nil
        }
        return UITableViewHeaderFooterView()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section > 0 {
            return UITableViewHeaderFooterView()
        }else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section > 0 {
            return UITableView.automaticDimension
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell!
        let row = indexPath.row
        let section = indexPath.section

        switch section {
        case 0:
            let cell = UITableViewCell()
            self.configSegmentedControl.layer.cornerRadius = 8
            cell.contentView.addSubview(self.configSegmentedControl)
            cell.contentView.clipsToBounds = false
            cell.backgroundColor = .clear
            configSegmentedControl.setupConstraints(to: cell.contentView)
            
            resultCell = cell
            break
        case 1:
            if row == 0 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "PickerSelectorHeader")
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    cell.textLabel?.text = "Perfil"
                    cell.detailTextLabel?.text = selectedUser?.name
                    cell.selectionStyle = .none
                    
                }else {
                    cell.textLabel?.text = "Projeto"
                    cell.detailTextLabel?.text = selectedProject?.id != nil ? selectedProject?.title : "Nenhum projeto"
                    cell.selectionStyle = selectedProject?.id != nil ? .default : .none
                    cell.detailTextLabel?.textColor = isPickerVisible ? .systemPurple : (selectedProject?.id != nil ? .label :  .secondaryLabel)
                }
                resultCell = cell
                break
            } else {
                let items = projects.map {
                    GenericRow<Project>(type: $0, showText: $0.title)
                }
                let selectedItem = selectedProject != nil ? GenericRow<Project>(type: selectedProject!, showText: selectedProject!.title) : items.first
                let cell = PickerViewTableViewCell<Project>(withItems:items)
                cell.selectedItem = selectedItem
                cell.pickerDelegate = self
                resultCell = cell
                break
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell") as! TextViewTableViewCell
            let skills = configSegmentedControl.selectedSegmentIndex == 0 ? selectedUser?.skills : selectedProject?.skillsInNeed
            cell.textView.text = skills
            cell.delegate = self
            cell.selectionStyle = .none
            resultCell = cell
        default:
            if row == 0 && isPreviewEnabled {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Pré-visualizar exibição"
                cell.textLabel?.setDynamicType(font: .systemFont(style: .body))
                resultCell = cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowProfileTableViewCell") as! ShowProfileTableViewCell
                let show = configSegmentedControl.selectedSegmentIndex == 0 ? "Exibir perfil" : "Exibir projeto"
                cell.showProjectOrProfile.text = show
                let isOn = configSegmentedControl.selectedSegmentIndex == 0 ? (selectedUser?.canAppearOnMatch == true) : (selectedProject?.canAppearOnMatch == true)
                
                cell.showSwitchControll.setOn(isOn, animated: true)
                cell.showSwitchControll.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
                resultCell = cell
            }
        }
        return resultCell
    }
    
    
    @objc func selectedSegmentChanged(sender: UISegmentedControl) {
        DispatchQueue.main.async {
            self.tableView.reloadSections([1,2,3], with: .automatic)
            self.isPickerVisible = false
        }
    }
    
    @objc func cancelBarItemTapped() {
        
        if stringUpdates.isEmpty && boolUpdates.isEmpty {
            self.dismiss(animated: true, completion: nil)
        }else  {
            presentDiscardChangesActionSheet { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func okBarItemTapped() {
        if !stringUpdates.isEmpty || !boolUpdates.isEmpty {
            
            if var selectedProject = selectedProject{
            selectedProject.skillsInNeed = stringUpdates["projectSkills"] ?? selectedProject.skillsInNeed
            selectedProject.canAppearOnMatch = boolUpdates["projectCanAppearOnMatch"] ?? selectedProject.canAppearOnMatch
                ProjectDAO().update(entity: selectedProject)
            }
            
            if var selectedUser = selectedUser {
                selectedUser.skills = stringUpdates["userSkills"] ?? selectedUser.skills
                selectedUser.canAppearOnMatch = boolUpdates["userCanAppearOnMatch"] ?? selectedUser.canAppearOnMatch
                UserDAO().update(entity: selectedUser)
            }
            
            
            self.dismiss(animated: true, completion: nil)
            
        }else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func switchChanged(sender: UISwitch) {
        if configSegmentedControl.selectedSegmentIndex == 0 {
            boolUpdates["userCanAppearOnMatch"] = sender.isOn
        }else {
            boolUpdates["projectCanAppearOnMatch"] = sender.isOn
        }
    }
}

extension MatchDisplayConfigurationTableViewController: PickerViewTableViewCellDelegate {
    func pickerCellDidSelected(item: Any) {
        if let row = item as? GenericRow<Project> {
            selectedProject = row.type
        }
    }
}

extension MatchDisplayConfigurationTableViewController: TextViewTableViewCellDelegate {
    func textDidChanged(_ text: String) {
        if configSegmentedControl.selectedSegmentIndex == 0 {
            stringUpdates["userSkills"] = text
        }else {
            stringUpdates["projectSkills"] = text
            
        }
    }
}


