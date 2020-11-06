//
//  ReservationCalendarTableViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 06/11/20.
//

import UIKit

protocol ReservationCalendarTableViewCellDelegate: class {
    func didSelected(_ date: Date)
}

class ReservationCalendarTableViewCell: UITableViewCell {
    
    var nextWeekButton: UIButton!
    var previousWeekButton: UIButton!
    var weekControlsView: UIStackView!
    weak var delegate: ReservationCalendarTableViewCellDelegate?
    
    var selectedDate: Date = Date() {
        didSet {
            showingDays = selectedDate.getDaysInThisWeek()
        }
    }
    
    private func designDayLabel(_ lbl: UILabel?,_ index: Int) {
        let isToday = showingDays[index].isToday()
        let isSelected = showingDays[index].isSameDay(as: selectedDate)
        let isSelectedDateToday = isSelected && isToday
        if isSelected {
            lbl?.setDynamicType(font: .systemFont(style: .title3, weight: .semibold), textStyle: .title3)
            lbl?.layer.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.15).cgColor
            lbl?.textColor = .systemPurple
            if isSelectedDateToday {
                lbl?.layer.backgroundColor = UIColor.systemPurple.cgColor
                lbl?.textColor = .white
            }
        }else {
            lbl?.setDynamicType(font: .systemFont(style: .title3))
            lbl?.layer.backgroundColor = UIColor.clear.cgColor
            lbl?.textColor = .label
            if isToday {
                lbl?.textColor = .systemPurple
            }
        }
    }
    
    fileprivate func designDays() {
        for index in 0..<showingDays.count {
            let day = showingDays[index].getDay()
            DispatchQueue.main.async { [self] in
                let lbl = daysView.subviews[index].subviews.first as? UILabel
                lbl?.text = "\(day)"
                
                designDayLabel(lbl, index)
            }
        }
    }
    
    var showingDays:[Date] = []{
        didSet {
            designDays()
            monthAndYearLabel.text = showingDays.first!.asString(with: "")
        }
    }

    private let monthAndYearLabel: UILabel = {
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .semibold), textStyle: .title3)
        return label
    }()

    private let daysView: UIStackView = {
        let daysView = UIStackView()
        for _ in 0..<7 {
            let lbl = UILabel()
            lbl.setDynamicType(font: .systemFont(style: .title3))
            lbl.textColor = .label
            lbl.textAlignment = .center
            lbl.layer.cornerRadius = 23
            let control = UIControl()
            control.addSubview(lbl)
            lbl.setupConstraints(to: control)
            daysView.addArrangedSubview(control)
        }
        daysView.distribution = .fillEqually
        daysView.translatesAutoresizingMaskIntoConstraints = false
        return daysView
    }()
    
    private func genSelectedDateView() -> UIStackView {
        let expandMonthAndYearButton = UIButton(type: .custom)
        expandMonthAndYearButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        expandMonthAndYearButton.setImage(UIImage(systemName: "chevron.down"), for: .selected)
        expandMonthAndYearButton.tintColor = .systemPurple
        
        let selectedMonthView = UIStackView(arrangedSubviews: [monthAndYearLabel, expandMonthAndYearButton])
        
        return selectedMonthView
    }
    
    private func genWeekControlsView()  {
        previousWeekButton = UIButton(type: .custom)
        previousWeekButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        previousWeekButton.tintColor = .systemPurple
        previousWeekButton.addTarget(self, action: #selector(self.previousWeek), for: .touchUpInside)
        
        nextWeekButton = UIButton(type: .custom)
        nextWeekButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextWeekButton.tintColor = .systemPurple
        nextWeekButton.addTarget(self, action: #selector(self.nextWeek), for: .touchUpInside)
        
        weekControlsView = UIStackView(arrangedSubviews: [previousWeekButton, nextWeekButton])
        weekControlsView.spacing = 30.96
        
    }
    
    private func genTopView() -> UIView {
        let topView = UIView()
        let selectedMonthView = genSelectedDateView()
        
        topView.addSubview(selectedMonthView)
        selectedMonthView.setupConstraintsOnlyTo(to: topView, leadingConstant: 16)
        selectedMonthView.centerConstraints(centerYConstant:0)
        
        genWeekControlsView()
        topView.addSubview(weekControlsView)
        weekControlsView.setupConstraintsOnlyTo(to: topView, trailingConstant: -16)
        weekControlsView.centerConstraints(centerYConstant:0)
        
        return topView
    }
    
    private func genWeekdaysStaticView() -> UIStackView {
        let weekdaysStaticView = UIStackView()
        let daysArr = Calendar.current.shortWeekdaySymbols
        daysArr.forEach({ day in
            let lbl = UILabel()
            lbl.text = day.uppercased()
            lbl.setDynamicType(font: .systemFont(style: .footnote, weight: .semibold), textStyle: .footnote)
            lbl.textColor = .secondaryLabel
            lbl.textAlignment = .center
            weekdaysStaticView.addArrangedSubview(lbl)
        })
        weekdaysStaticView.distribution = .fillEqually
        return weekdaysStaticView
    }
    
    private func genCalendarContentView() -> UIStackView {
        let calendarContent = UIStackView(arrangedSubviews: [genWeekdaysStaticView(), daysView])
        calendarContent.axis = .vertical
        daysView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeLeft.direction = .left
        calendarContent.addGestureRecognizer(swipeRight)
        calendarContent.addGestureRecognizer(swipeLeft)
        return calendarContent
    }
    
    private func setupDaySelection() {
        daysView.subviews.forEach { view  in
            let control = view as? UIControl
            control?.addTarget(self, action: #selector(self.selectDay(sender:)), for: .touchUpInside)
        }
    }
    
    private func commonInit(){
        selectionStyle = .none
        let topView = genTopView()
        let calendarContent = genCalendarContentView()
        
        
        contentView.addSubview(topView)
        topView.setupConstraintsOnlyTo(to: contentView, leadingConstant: 0, topConstant: 0, trailingConstant: 0)
        topView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        contentView.addSubview(calendarContent)
        calendarContent.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
        calendarContent.setupConstraintsOnlyTo(to: contentView, leadingConstant: 16, trailingConstant: -16, bottomConstant: -10)
        
        self.selectedDate = Date()
        setupDaySelection()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    @objc func selectDay(sender: UIControl) {
        if let index = daysView.subviews.firstIndex(of: sender) {
            selectedDate = showingDays[index]
            designDays()
            delegate?.didSelected(selectedDate)
        }
    }
    
    @objc func nextWeek() {
        showingDays = showingDays.first!.advanceAWeek().getDaysInThisWeek()
    }
    @objc func previousWeek() {
        showingDays = showingDays.first!.backAWeek().getDaysInThisWeek()
    }
    
    @objc func swiped(_ sender: UISwipeGestureRecognizer ) {
        if  sender.direction == .left {
            nextWeek()
        }else {
            previousWeek()
        }
    }
}
