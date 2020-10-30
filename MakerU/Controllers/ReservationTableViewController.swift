//
//  ReservationTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 30/10/20.
//

import UIKit

class ReservationTableViewController: UITableViewController {
    
    var projectUpdate: Project?
    var datetimeUpdates: [String: Date] = [:]
    
    var selectedProject: Project?
    var selectedDate: Date? = Date()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.preferredDatePickerStyle = .inline
        dp.tintColor = .systemPurple
        dp.locale = .current
        return dp
    }()
    
    var isDatepickerVisible = false {
        didSet {
            let datePickerRow = IndexPath(row: 1, section: 1)
            let datePickerHeaderRow = IndexPath(row: 0, section: 1)
            tableView.reloadRows(at: [datePickerHeaderRow,datePickerRow], with: .automatic)
        }
    }

    func setupNavigations() {
        navigationItem.title = "Agendamento"
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        let okButtonItem = UIBarButtonItem(title: "Confirmar", style: .done, target: self, action: #selector(self.okBarItemTapped))
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? 3 : 1
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Associe uma atividade a sua reserva" : ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
            case 1:
                switch indexPath.row {
                    case 1:
                        resultCell.contentView.addSubview(datePicker)
                        datePicker.setupConstraints(to: resultCell.contentView)
                        break
                    case 2:
                        let cell = SegmentedTableViewCell()
                        cell.textLbl.text = "Termina"
                        cell.timePicker.addTarget(self, action: #selector(self.timePickerValueChanged(sender:)), for: .valueChanged)
                        resultCell = cell
                        break
                    default:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Começa"
                        cell.detailTextLabel?.textColor = isDatepickerVisible ? .systemPurple : .secondaryLabel
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .full
                        dateFormatter.timeStyle = .short
                        dateFormatter.timeZone = .current
                        cell.detailTextLabel?.text = dateFormatter.string(from: selectedDate!)
                        resultCell = cell
                        break
                }
            default:
                break
        }

        return resultCell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 1 && indexPath.row == 1 && !isDatepickerVisible {
            return 0
        }
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            isDatepickerVisible.toggle()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - objc funcs
    @objc func cancelBarItemTapped() {
        
        if projectUpdate != nil || !datetimeUpdates.isEmpty {
            presentDiscardChangesActionSheet { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }else  {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func okBarItemTapped() {
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date
        datetimeUpdates["date&time"] = sender.date
        let datePickerHeaderRow = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [datePickerHeaderRow], with: .automatic)
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        print(sender.date)
        datetimeUpdates["time"] = sender.date
        let datePickerHeaderRow = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [datePickerHeaderRow], with: .automatic)
    }
}
