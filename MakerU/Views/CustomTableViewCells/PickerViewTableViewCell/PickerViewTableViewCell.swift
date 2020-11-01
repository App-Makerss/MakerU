//
//  PickerViewTableViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 31/10/20.
//

import UIKit

protocol PickerViewTableViewCellDelegate: class{
    func pickerCellDidSelected(item: Any)
}

class PickerViewTableViewCell<T: Equatable>: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Outlets
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    //MARK: - Attributes
    var items: [GenericRow<T>]
    var selectedItem: GenericRow<T>?{
        didSet {
            if let selectedIndex = items.firstIndex(where: {$0.type == selectedItem?.type}) {
                pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            }
        }
    }
    weak var pickerDelegate: PickerViewTableViewCellDelegate?
    
    // MARK: - Initializers
    init(withItems items: [GenericRow<T>]) {
        self.items = items
        super.init(style: .default, reuseIdentifier: "PickerViewTableViewCell")
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(pickerView)
        self.selectionStyle = .none
        pickerView.setupConstraints(to: contentView, leadingConstant: 16, trailingConstant: -16)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.textColor = .label
        pickerLabel?.text = items[row].showText
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = items[row]
        pickerDelegate?.pickerCellDidSelected(item: items[row])
    }
}

