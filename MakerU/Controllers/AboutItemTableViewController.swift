//
//  AboutItemTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 26/10/20.
//

import UIKit

class AboutItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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

        switch row {
        case 0:
            cell.textLabel?.text = "Até 6 pessoas"
            cell.imageView?.image = UIImage(systemName: "person.2")
            cell.imageView?.tintColor = .systemPurple
        case 1:
            cell.textLabel?.text = "Televisor 42'"
            cell.imageView?.image = UIImage(systemName: "tv")
            cell.imageView?.tintColor = .systemPurple
        default:
            cell.textLabel?.text = "Ar Condicionado"
            cell.imageView?.image = UIImage(systemName: "wind.snow")
            cell.imageView?.tintColor = .systemPurple
        }
        return cell
    }
}
