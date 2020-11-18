//
//  NotificationsTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/11/20.
//

import UIKit

class NotificationsTableViewController: UITableViewController{
    
    var recentNotifications: [GlobalNotification] = []
    var elderNotifications: [GlobalNotification] = []
    let globalNotificationService = GlobalNotificationService()
    
    private func setupTableView() {
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 100
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        globalNotificationService.listRecents() {
            recents, error in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                self.recentNotifications = recents!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        globalNotificationService.listElder {
            elders, error in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                self.elderNotifications = elders!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        navigationItem.title = "Notificações"
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        recentNotifications.count + elderNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        var item: GlobalNotification
        if indexPath.section < recentNotifications.count {
            item = recentNotifications[indexPath.section]
        }else {
            item = elderNotifications[indexPath.section-recentNotifications.count]
        }
        
        cell.titleLabel.text = item.title
        cell.messageLabel.text = item.message
        cell.wasAtLabel.text = item.creationDate.howMuchTimeAsString()
        
        cell.messageLabel.sizeToFit()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)
        
        view.addSubview(label)
        label.accessibilityTraits = .header
        label.setupConstraints(to: view, leadingConstant: 4, bottomConstant: -8)
        
        switch section {
            case recentNotifications.count:
                label.text = "Anterior"
            case 0:
                label.text = "Recente"
            default:
                return nil
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0 || section == recentNotifications.count{
            return UITableView.automaticDimension
        }else{
            return 8
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if  section == recentNotifications.count-1{
            return 24
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
}
