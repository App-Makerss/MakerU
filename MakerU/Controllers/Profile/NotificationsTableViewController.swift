//
//  NotificationsTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 15/11/20.
//

import UIKit

class NotificationsTableViewController: UITableViewController{
    
    var recentNotifications: [GlobalNotification] = []
    let elderNotifications: [GlobalNotification] = []
    let globalNotificationService = GlobalNotificationService()
    
    fileprivate func setupTableView() {
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 150
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
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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

class NotificationTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    var wasAtLabel: UILabel!
    
    func commonInit() {
        selectionStyle = .none
        titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .headline)
        
        messageLabel = UILabel()
        messageLabel.setDynamicType(textStyle: .callout)
        messageLabel.numberOfLines = 0
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        wasAtLabel = UILabel()
        wasAtLabel.setDynamicType(textStyle: .subheadline)
        wasAtLabel.textColor = .secondaryLabel
        wasAtLabel.textAlignment = .right
        
        
        let header = UIStackView(arrangedSubviews: [titleLabel, wasAtLabel])
        header.distribution = .fillProportionally
        let rootGroup = UIStackView(axis: .vertical, arrangedSubviews: [header, messageLabel])
        rootGroup.distribution = .fillProportionally
        rootGroup.spacing = 9
        
        contentView.addSubview(rootGroup)
        
        rootGroup.setupConstraints(to: contentView, leadingConstant: 16, topConstant: 14, trailingConstant: -16, bottomConstant: -14)
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
