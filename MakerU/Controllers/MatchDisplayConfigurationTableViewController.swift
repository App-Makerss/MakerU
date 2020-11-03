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
    
    var selectedProject: Project? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                self.tableView.reloadSections([2,3,4], with: .automatic)
            }
        }
    }
    var selectedUser: User? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        tableView.register(UINib(nibName: "UserBioTableViewCell", bundle: nil), forCellReuseIdentifier: "UserBioTableViewCell")
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

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? secondSectionRowCount : 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 && configSegmentedControl.selectedSegmentIndex == 1 {
            isPickerVisible.toggle()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return configSegmentedControl.selectedSegmentIndex == 0 ? "Habilidades pessoais" : "Habilidades procuradas"
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            case 2:
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    return "Acesse seu perfil para alterar suas informações."
                }else {
                    return "Edite a descrição acessando seu projeto em perfil."
                }
            case 3:
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    return "Descreva brevemente suas habilidades que podem ser úteis para colaboração em projetos."
                }else {
                    return "Descreva brevemente as habilidades desejáveis no perfil de um possível colaborador para o projeto."
                }
            case 4:
                return "Ao habilitar a exibição, as informações acima estarão visíveis para os demais usuários do espaço."
            default:
               return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 3 {
            return 16
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 3{
            return nil
        }
        return UITableViewHeaderFooterView()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section > 1 {
            return UITableViewHeaderFooterView()
        }else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section > 1 {
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
            cell.contentView.addSubview(configSegmentedControl)
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
                    cell.detailTextLabel?.text = selectedProject?.title
                }
                cell.detailTextLabel?.textColor = isPickerVisible ? .systemPurple : .secondaryLabel
                resultCell = cell
                break
            } else {
                let cell = ProjectSelectorTableViewCell(projects: self.projects, selectedProject: selectedProject)
                cell.delegate = self
                resultCell = cell
                break
            }
        case 2:
            let identifier = configSegmentedControl.selectedSegmentIndex == 0 ? "UserBioTableViewCell" : "ProjectDescriptionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
            if configSegmentedControl.selectedSegmentIndex == 0 {
                (cell as! UserBioTableViewCell).descriptionText.text = selectedUser?.description
            }else {
                (cell as! ProjectDescriptionTableViewCell).descriptionLabel.text = selectedProject?.description
            }
            resultCell = cell
            break
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell")!
            let skills = configSegmentedControl.selectedSegmentIndex == 0 ? selectedUser?.skills : selectedProject?.skillsInNeed
            (cell as! TextViewTableViewCell).textView.text = skills
            (cell as! TextViewTableViewCell).delegate = self
            cell.selectionStyle = .none
            resultCell = cell
            break
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowProfileTableViewCell")!
            let isOn = configSegmentedControl.selectedSegmentIndex == 0 ? (selectedUser?.canAppearOnMatch == true) : (selectedProject?.canAppearOnMatch == true)
            (cell as! ShowProfileTableViewCell).showSwitchControll.setOn(isOn, animated: true)
            (cell as! ShowProfileTableViewCell).showSwitchControll.addTarget(self, action: #selector(self.switchChanged), for: .valueChanged)
            resultCell = cell
            break
        }
        return resultCell
    }
    
    
    @objc func selectedSegmentChanged(sender: UISegmentedControl) {
        tableView.reloadData()
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
        if !stringUpdates.isEmpty || !boolUpdates.isEmpty,
            var selectedProject = selectedProject {
            
            selectedProject.skillsInNeed = stringUpdates["projectSkills"] ?? selectedProject.skillsInNeed
            selectedProject.canAppearOnMatch = boolUpdates["projectCanAppearOnMatch"] ?? selectedProject.canAppearOnMatch
            
            if var selectedUser = selectedUser {
                selectedUser.skills = stringUpdates["userSkills"] ?? selectedUser.skills
                selectedUser.canAppearOnMatch = boolUpdates["userCanAppearOnMatch"] ?? selectedUser.canAppearOnMatch
                UserDAO().update(entity: selectedUser)
            }
            
            ProjectDAO().update(entity: selectedProject)
            
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

extension MatchDisplayConfigurationTableViewController: PickerSelectorTableViewCellDelegate {
    
    func didSelected(project: Project) {
        selectedProject = project
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


