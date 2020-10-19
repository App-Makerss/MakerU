//
//  MatchDisplayConfigurationTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import UIKit

class MatchDisplayConfigurationTableViewController: UITableViewController {
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
            case 0:
                let cell = UITableViewCell()
                cell.contentView.addSubview(configSegmentedControl)
                return cell
            case 1 :
                let cell = UITableViewCell()
                self.initFromNib(xibName: "UserProfileTagTableViewCell", tableviewCell: cell)
                return cell
                
            case 2:
                let cell = UITableViewCell()
                self.initFromNib(xibName: "UserBioTableViewCell", tableviewCell: cell)
                return cell
                
            case 3:
                let cell = UITableViewCell()
                self.initFromNib(xibName: "SkillsTableViewCell", tableviewCell: cell)
                return cell
            case 4:
                let cell = UITableViewCell()
                self.initFromNib(xibName: "ShowProfileTableViewCell", tableviewCell: cell)
                return cell
            default:
                return UITableViewCell()
        }
    }

}
