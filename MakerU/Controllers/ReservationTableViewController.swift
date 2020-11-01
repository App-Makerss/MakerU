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
        dp.minuteInterval = 5
        dp.minimumDate = Date()
        dp.tintColor = .systemPurple
        dp.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        dp.locale = Locale.init(identifier: "pt-BR")//TODO: remover quando a apple corrigir
        return dp
    }()
    
    var isTimepickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
        }
    }
    
    var isDatepickerVisible = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections([1], with: .automatic)
            }
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

    var dateSelectorsRowCount: Int {
        isTimepickerVisible ? 4 : 3
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 1 ? dateSelectorsRowCount : 1
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
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Termina"
                        cell.detailTextLabel?.textColor = isTimepickerVisible ? .systemPurple : .label
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .none
                        dateFormatter.timeStyle = .short
                        dateFormatter.locale = Locale.init(identifier: "pt-BR")
                        cell.detailTextLabel?.text = dateFormatter.string(from: datetimeUpdates["time"] ?? Date())
                        cell.accessibilityHint = "Toque duas vezess para editar"
                        resultCell = cell
                        break
                    case 3:
                        let cell = TimePickerTableViewCell()
                        cell.textLbl.text = "Horário"
                        cell.timePicker.addTarget(self, action: #selector(self.timePickerValueChanged(sender:)), for: .valueChanged)
                        cell.timePicker.minimumDate = selectedDate
                        resultCell = cell
                        break
                    default:
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell11")
                        cell.textLabel?.text = "Começa"
                        cell.detailTextLabel?.textColor = isDatepickerVisible ? .systemPurple : .label
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        dateFormatter.locale = Locale.init(identifier: "pt-BR")
                        cell.detailTextLabel?.text = dateFormatter.string(from: selectedDate!)
                        cell.accessibilityHint = "Toque duas vezess para editar"
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
        if indexPath.section == 1 && indexPath.row == 3 && !isTimepickerVisible {
            return 0
        }
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            isDatepickerVisible.toggle()
            isTimepickerVisible = false
        }else if indexPath.section == 1 && indexPath.row == 2 {
            isTimepickerVisible.toggle()
            isDatepickerVisible = false
        }else if isDatepickerVisible || isTimepickerVisible {
            isDatepickerVisible = false
            isTimepickerVisible = false
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
        datetimeUpdates["time"] = sender.date
        let datePickerHeaderRow = IndexPath(row: 2, section: 1)
        tableView.reloadRows(at: [datePickerHeaderRow], with: .automatic)
    }
}
