//
//  ProjectSelectorTableViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 19/10/20.
//

import UIKit

protocol PickerSelectorTableViewCellDelegate: class {
    func didSelected(project: Project)
}

class ProjectSelectorTableViewCell: UITableViewCell {

    var projects: [Project] = []
    var selectedProject: Project?
    weak var delegate: PickerSelectorTableViewCellDelegate?

    lazy var picker = UIPickerView()

    
    init(projects: [Project], selectedProject: Project? = nil) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.projects = projects
        if selectedProject == nil {
            self.selectedProject = projects.first
        }else {
            self.selectedProject = selectedProject
        }
        commonInit()
    }
    
    fileprivate func commonInit() {
        picker.dataSource = self
        picker.delegate = self
        contentView.addSubview(picker)
        self.selectionStyle = .none
        
        if selectedProject != nil,
           let row = projects.firstIndex(where: {$0.id == selectedProject!.id}) {
            picker.selectRow(row, inComponent: 0, animated: true)
        }
        picker.setupConstraints(to: contentView, leadingConstant: 16, trailingConstant: -16)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProjectSelectorTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        projects.count // linhas do picker
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProject = projects[row]
        delegate?.didSelected(project: selectedProject!)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.textColor = .label
        pickerLabel?.text = projects[row].title

        return pickerLabel!
    }
}
