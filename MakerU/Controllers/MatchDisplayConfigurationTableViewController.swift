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
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
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
            print("atualizei")
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
            }
        }
    }

    let projectService = ProjectService()

    let configSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Perfil", "Projeto"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(Self.selectedSegmentChanged), for: .valueChanged)

        return segmented
    }()
    let rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: nil)
        barButtonItem.tintColor = UIColor.systemPurple
        return barButtonItem
    }()
    
    let leftBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: nil)
        barButtonItem.tintColor = UIColor.systemPurple
        return barButtonItem
    }()
    func setupNavigations() {
        navigationItem.title = "Exibição"
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
        tableView.register(UINib(nibName: "SkillsTableViewCell", bundle: nil), forCellReuseIdentifier: "SkillsTableViewCell")
        tableView.register(UINib(nibName: "ShowProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowProfileTableViewCell")

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
        section == 1 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard indexPath.section == 1 && indexPath.row == 1 && !isPickerVisible
        else { return UITableView.automaticDimension }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 && configSegmentedControl.selectedSegmentIndex == 1 {
            isPickerVisible.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
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
        let row = indexPath.row
        let section = indexPath.section

        switch section {
        case 0:
            let cell = UITableViewCell()
            cell.contentView.addSubview(configSegmentedControl)
            configSegmentedControl.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
            configSegmentedControl.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
            configSegmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
            configSegmentedControl.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            
            return cell
        case 1:
            if row == 0 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "PickerSelectorHeader")
                if configSegmentedControl.selectedSegmentIndex == 0 {
                    cell.textLabel?.text = "perfil"
                    cell.detailTextLabel?.text = selectedUser?.name
                }else {
                    cell.textLabel?.text = "Projeto"
                    cell.detailTextLabel?.text = selectedProject?.title
                }
                cell.detailTextLabel?.textColor = isPickerVisible ? .systemPurple : .label
                return cell
            } else {
                let cell = ProjectSelectorTableViewCell(projects: self.projects)
                cell.delegate = self
                return cell
            }
        case 2:
            let identifier = configSegmentedControl.selectedSegmentIndex == 0 ? "UserBioTableViewCell" : "ProjectDescriptionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
            if configSegmentedControl.selectedSegmentIndex == 0 {
                (cell as! UserBioTableViewCell).descriptionText.text = selectedUser?.description
            }else {
                (cell as! ProjectDescriptionTableViewCell).descriptionLabel.text = selectedProject?.description
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsTableViewCell")!
            let skills = configSegmentedControl.selectedSegmentIndex == 0 ? selectedUser?.skills : selectedProject?.skillsInNeed
            (cell as! SkillsTableViewCell).skillsTextView.text = skills
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowProfileTableViewCell")!
            let isOn = configSegmentedControl.selectedSegmentIndex == 0 ? (selectedUser?.canAppearOnMatch == true) : (selectedProject?.canAppearOnMatch == true)
            (cell as! ShowProfileTableViewCell).showSwitchControll.setOn(isOn, animated: true)
            return cell
        }
    }
    
    
    @objc func selectedSegmentChanged(sender: UISegmentedControl) {
        tableView.reloadData()
    }
}

extension MatchDisplayConfigurationTableViewController: PickerSelectorTableViewCellDelegate {
    
    func didSelected(project: Project) {
        selectedProject = project
    }
}


