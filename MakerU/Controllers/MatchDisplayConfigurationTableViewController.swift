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
    private func initFromNib(xibName: String, tableviewCell: UITableViewCell) {
        if let nib = Bundle.main.loadNibNamed( xibName, owner: self, options: nil),
           let nibView = nib.first as? UIView {
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            tableviewCell.contentView.addSubview(nibView)
            nibView.translatesAutoresizingMaskIntoConstraints = false
            nibView.topAnchor.constraint(equalTo: tableviewCell.contentView.topAnchor).isActive = true
            nibView.leadingAnchor.constraint(equalTo: tableviewCell.contentView.leadingAnchor).isActive = true
            nibView.trailingAnchor.constraint(equalTo: tableviewCell.contentView.trailingAnchor).isActive = true
            nibView.bottomAnchor.constraint(equalTo: tableviewCell.contentView.bottomAnchor).isActive = true
        }
    }
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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projectService.listAllProjectsOfLoggedUser(by: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77") { (projects, error) in
            if let projects = projects {
                self.projects = projects
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        section == 1 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard indexPath.section == 1 && indexPath.row == 1 && !isPickerVisible
        else { return UITableView.automaticDimension }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isPickerVisible = indexPath.section == 1 && indexPath.row == 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section

        switch section {
        case 0:
            let cell = UITableViewCell()
            cell.contentView.addSubview(configSegmentedControl)
            return cell
        case 1:
            if row == 0 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "ProjectSelectorHeader")
                cell.textLabel?.text = "Projeto"
                cell.detailTextLabel?.text = selectedProject?.title
                return cell
            } else {
                let cell = ProjectSelectorTableViewCell()
                cell.delegate = self
                DispatchQueue.main.async {
                    cell.projects = self.projects
                }
                return cell
            }
        case 2:
            let cell = UITableViewCell()
            self.initFromNib(xibName: "UserBioTableViewCell", tableviewCell: cell)
            return cell
        case 3:
            let cell = UITableViewCell()
            self.initFromNib(xibName: "SkillsTableViewCell", tableviewCell: cell)
            return cell
        default:
            let cell = UITableViewCell()
            self.initFromNib(xibName: "ShowProfileTableViewCell", tableviewCell: cell)
            return cell
        }
    }
}

extension MatchDisplayConfigurationTableViewController: PickerSelectorTableViewCellDelegate {
    
    func didSelected(project: Project) {
        selectedProject = project
    }
}
