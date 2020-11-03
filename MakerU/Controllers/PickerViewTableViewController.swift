//
//  PickerViewTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 31/10/20.
//

import UIKit
protocol PickerViewTableViewControllerDelegate: class{
    func pickerTableViewDidSelected(_ viewController: UIViewController, item: Any)
}
class PickerViewTableViewController<T: Equatable>: UITableViewController {

    var items: [GenericRow<T>]
    var selectedItem: GenericRow<T>? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    weak var pickerDelegate: PickerViewTableViewControllerDelegate?
    
    init(withItems items: [GenericRow<T>]) {
        self.items = items
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemPurple
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "none")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.showText
        if item.type == selectedItem?.type {
            cell.accessoryType = .checkmark
            cell.tintColor = .systemPurple
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        self.selectedItem = selectedItem
        pickerDelegate?.pickerTableViewDidSelected(self, item: selectedItem)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
}
