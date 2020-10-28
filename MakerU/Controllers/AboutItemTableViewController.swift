//
//  AboutItemTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 26/10/20.
//

import UIKit

class AboutItemTableViewController: UITableViewController {

    var scrollEdgeAppearanceTintColor: UIColor = .white
    var defaultTintColor: UIColor = .systemPurple

    var selectedRoom: Room? {
        didSet {
            navigationItem.title = selectedRoom?.title
        }
    }
    var selectedEquip: Equipment?{
        didSet {
            navigationItem.title = selectedEquip?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if selectedRoom != nil {
            setupCoverImage(image: UIImage(data: selectedRoom!.image ?? Data()))
        } else {
            setupCoverImage(image: UIImage(data: selectedEquip?.image ?? Data()))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    fileprivate func initItems() {
        setupNavigationBarColor()
    }

    override init(style: UITableView.Style) {
        super.init(style: style)
        initItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedRoom != nil {
            return selectedRoom!.descriptionStrings.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.text = "Sobre"

        switch section {
        default:
            return view
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if selectedRoom != nil {
            let string = selectedRoom!.descriptionStrings[row]
            let iconName = selectedRoom!.descriptionIconNames[row]

            cell.textLabel?.text = string
            cell.textLabel?.setDynamicType(font: .systemFont(style: .callout))
            cell.imageView?.image = UIImage(systemName: iconName)
            cell.imageView?.tintColor = .systemPurple
        } else {
            cell.textLabel?.text = selectedEquip?.description
            cell.textLabel?.setDynamicType(font: .systemFont(style: .body))
            cell.textLabel?.numberOfLines = 0
        }
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: scrollViewDelegate
extension AboutItemTableViewController: ScrollableCover {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}
