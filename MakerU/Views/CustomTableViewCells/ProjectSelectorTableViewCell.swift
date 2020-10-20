//
//  ProjectSelectorTableViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 19/10/20.
//

import UIKit

class ProjectSelectorTableViewCell: UITableViewCell {

    let projects = ["Apps para espaço maker", "Simulador imersivo de carrinho de rolimã", "Realidade aumentada para inclusão", "Trabaho de F 429"]

    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        picker.dataSource = self
        picker.delegate = self
        contentView.addSubview(picker)

        setupContraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupContraint(){
        picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        picker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }

}

extension ProjectSelectorTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        projects.count // linhas do picker
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = projects[row]
       return row // lista de projetos mandada pelo viewController
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = projects[row]
            pickerLabel?.textColor = UIColor.black

            return pickerLabel!
    }
}
