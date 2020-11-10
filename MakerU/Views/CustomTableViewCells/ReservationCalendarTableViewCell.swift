//
//  ReservationCalendarTableViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 06/11/20.
//

import UIKit
import Foundation
protocol ReservationCalendarTableViewCellDelegate: class {
    func didSelected(_ date: Date)
}

class ReservationCalendarTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    var monthYearPicker: MonthYearPickerView!
    private var topView: UIView!
    private var nextWeekButton: UIButton!
    private var previousWeekButton: UIButton!
    private var weekControlsView: UIStackView!
    private var dividers: [UIView] = []
    private var itemViews: [ItemView] = [ItemView(),ItemView(),ItemView()]
    private let monthAndYearLabel: UILabel = {
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .semibold), textStyle: .title3)
        return label
    }()
    private let pageControl: UIPageControl = {
        let pg = UIPageControl()
        pg.hidesForSinglePage = true
        pg.pageIndicatorTintColor = .systemGray
        pg.currentPageIndicatorTintColor = .label
        return pg
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
            lbl.equalSize(heightMultiplier:0.9, widthMultiplier:0.9)
            lbl.centerConstraints(centerYConstant: 0, centerXConstant: 0)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.widthAnchor.constraint(equalTo: control.heightAnchor).isActive = true
            daysView.addArrangedSubview(control)
        }
        daysView.distribution = .fillEqually
        daysView.translatesAutoresizingMaskIntoConstraints = false
        return daysView
    }()
    var calendarContent: UIStackView!
    
    //MARK: - Attributes
    private var showingDays: [Date] = []{
        didSet {
            designDays()
            monthAndYearLabel.text = showingDays.first!.monthAndYearString()
        }
    }
    var selectedDate: Date = Date(){
        didSet {
            monthAndYearLabel.text = selectedDate.monthAndYearString()
        }
    }
    var showingReservations: [Reservation] = [] {
        didSet {
            let countDouble = Double(showingReservations.count)
            pageControl.numberOfPages = Int(ceil(countDouble/3))
            setupReservationsView()
        }
    }
    var showingProjects: [Project] = []
    
    //MARK: - delegates
    weak var delegate: ReservationCalendarTableViewCellDelegate?
    
    //MARK: - layout generators
    private func genSelectedDateView() -> UIControl {
        let expandMonthAndYearButton = UIButton(type: .custom)
        expandMonthAndYearButton.tag = 111
        expandMonthAndYearButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        expandMonthAndYearButton.setImage(UIImage(systemName: "chevron.down"), for: .selected)
        expandMonthAndYearButton.tintColor = .systemPurple
        expandMonthAndYearButton.isUserInteractionEnabled = false
        
        let selectedMonthView = UIStackView(arrangedSubviews: [monthAndYearLabel, expandMonthAndYearButton])
        selectedMonthView.isUserInteractionEnabled = false
        
        let control = UIControl()
        control.isUserInteractionEnabled = true
        control.addSubview(selectedMonthView)
        selectedMonthView.setupConstraints(to: control)
        control.addTarget(self, action: #selector(self.toggleContent(sender:)), for: .touchUpInside)
        return control
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
        selectedMonthView.setupConstraintsOnlyTo(to: topView, leadingConstant: 20)
        selectedMonthView.centerConstraints(centerYConstant:0)
        
        genWeekControlsView()
        topView.addSubview(weekControlsView)
        weekControlsView.setupConstraintsOnlyTo(to: topView, trailingConstant: -20)
        weekControlsView.centerConstraints(centerYConstant:0)
        topView.heightAnchor.constraint(lessThanOrEqualToConstant: 44.3333).isActive = true
        
        return topView
    }
    private func genWeekdaysStaticView() -> UIStackView {
        let weekdaysStaticView = UIStackView()
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "pt-BR")//TODO: remove it when apple fixes the locale localization
        
        var daysArr = calendar.shortWeekdaySymbols
        daysArr.append(daysArr.remove(at: 0))
        
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
        calendarContent = UIStackView(arrangedSubviews: [genWeekdaysStaticView(), daysView])
        calendarContent.axis = .vertical
        daysView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.daysSwiped(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.daysSwiped(_:)))
        swipeLeft.direction = .left
        daysView.addGestureRecognizer(swipeRight)
        daysView.addGestureRecognizer(swipeLeft)
        return calendarContent
    }
    private func genDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.backgroundColor = .systemGray3
        return divider
    }
    
    //MARK: - inits
    private func genItemsView() {
        let itemsStack = UIStackView(axis: .vertical, arrangedSubviews: [itemViews[0], dividers[0], itemViews[1], dividers[1], itemViews[2]])
        itemsStack.spacing = 8
        itemsStack.distribution = .fillProportionally
        
        let itemsView = UIView()
        itemsView.addSubview(itemsStack)
        itemsView.addSubview(pageControl)
        
        itemsStack.setupConstraintsOnlyTo(to: itemsView, leadingConstant: 0, topConstant: 8, trailingConstant: 0)
        pageControl.setupConstraintsOnlyTo(to: itemsView, bottomConstant: 0)
        itemsStack.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -8).isActive = true
        pageControl.centerConstraints(centerXConstant: 0)
        pageControl.heightAnchor.constraint(equalTo: itemsView.heightAnchor, multiplier: 0.12).isActive = true
        calendarContent.addArrangedSubview(genDivider())
        calendarContent.setCustomSpacing(8, after: calendarContent.subviews[1])
        calendarContent.addArrangedSubview(itemsView)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeLeft.direction = .left
        itemsView.addGestureRecognizer(swipeRight)
        itemsView.addGestureRecognizer(swipeLeft)
    }
    
    private func commonInit(){
        selectionStyle = .none
        pageControl.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)
        topView = genTopView()
        calendarContent = genCalendarContentView()
        dividers = [genDivider(),genDivider()]

        genItemsView()
        
        contentView.addSubview(topView)
        topView.setupConstraintsOnlyTo(to: contentView, leadingConstant: 0, topConstant: 8, trailingConstant: 0)
        topView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        contentView.addSubview(calendarContent)
        calendarContent.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
        calendarContent.setupConstraintsOnlyTo(to: contentView, leadingConstant: 12, trailingConstant: -12, bottomConstant: -10)
        
        self.selectedDate = Date()
        showingDays = selectedDate.getDaysInThisWeek()
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
    
    //MARK: - objc funcs
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
    
    @objc func pageChanged() {
        setupReservationsView()
    }
    
    @objc func daysSwiped(_ sender: UISwipeGestureRecognizer ) {
        if  sender.direction == .left {
            nextWeek()
        }else {
            previousWeek()
        }
    }
    
    @objc func swiped(_ sender: UISwipeGestureRecognizer ) {
        if  sender.direction == .left {
            if pageControl.currentPage+1 < pageControl.numberOfPages{
                pageControl.currentPage = +1
                setupReservationsView()
            }
        }else {
            if pageControl.currentPage-1 > -1{
                pageControl.currentPage = -1
                setupReservationsView()
            }
        }
    }
    
    @objc func monthYearPickerDateChanged(_ sender: MonthYearPickerView){
        showingDays = sender.date.getDaysInThisWeek()
        monthAndYearLabel.text = sender.date.monthAndYearString()
    }
    @objc func toggleContent(sender: UIControl) {
        guard let btn = sender.viewWithTag(111) as? UIButton else { return }
        btn.isSelected.toggle()
        calendarContent.subviews.forEach { $0.removeFromSuperview()}
        if btn.isSelected {
            monthAndYearLabel.textColor = .systemPurple
            weekControlsView.isHidden = true
            monthYearPicker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (calendarContent.bounds.height - 216) / 2), size: CGSize(width: calendarContent.bounds.width, height: 216)))
            monthYearPicker.minimumDate = Date()
            monthYearPicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
            monthYearPicker.locale = Locale.init(identifier: "pt-BR")
            monthYearPicker.addTarget(self, action: #selector(self.monthYearPickerDateChanged(_:)), for: .valueChanged)
            calendarContent.addArrangedSubview(monthYearPicker)
        }else {
            monthAndYearLabel.textColor = .label
            weekControlsView.isHidden = false
            let calendarContent = genCalendarContentView()
            genItemsView()
            
            contentView.addSubview(calendarContent)
            calendarContent.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
            calendarContent.setupConstraintsOnlyTo(to: contentView, leadingConstant: 16, trailingConstant: -16, bottomConstant: -10)
            
        }
    }
    
    //MARK: - behaviour funcs
    func reloadReservations(reservations: [Reservation], projects: [Project]) {
        showingReservations = reservations
        showingProjects = projects
        setupReservationsView()
    }
    
    private func setupReservationsView() {
        if showingReservations.isEmpty {
            let lbl = UILabel()
            lbl.text = "Nenhuma Reserva"
            lbl.setDynamicType(font: .systemFont(style: .body))
            lbl.textColor = .secondaryLabel
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 209.0).isActive = true
            calendarContent.subviews[3].removeFromSuperview()
            calendarContent.addArrangedSubview(lbl)
            return
        }else {
            calendarContent.subviews[2].removeFromSuperview()
            calendarContent.subviews[2].removeFromSuperview()
            genItemsView()
        }
        let pageIndex = pageControl.currentPage
        let cursor = pageIndex * 3
        let upperBound = 3*(pageIndex+1)
        for i in cursor..<upperBound{
            let viewIndex = i-cursor
            if showingReservations.indices.contains(i) {
                let project = showingProjects.first(where:{$0.id == showingReservations[i].project})
                let category = categories.first(where: {$0.id == project?.category})
                itemViews[viewIndex].configView(
                    title: project?.title,
                    subtitle: category?.name,
                    start: showingReservations[i].startDate.timeAsString(),
                    end: showingReservations[i].endDate.timeAsString())
                
                if viewIndex<2 {
                    dividers[viewIndex].backgroundColor = .systemGray3
                }
            }else {
                if viewIndex<2{
                    dividers[viewIndex].backgroundColor = .clear
                }
                itemViews[viewIndex].configView()
            }
        }
    }
    
    private func setupDaySelection() {
        daysView.subviews.forEach { view  in
            let control = view as? UIControl
            control?.addTarget(self, action: #selector(self.selectDay(sender:)), for: .touchUpInside)
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
    
    private func designDays() {
        for index in 0..<showingDays.count {
            let day = showingDays[index].getDay()
            DispatchQueue.main.async { [self] in
                let lbl = daysView.subviews[index].subviews.first as? UILabel
                lbl?.text = "\(day)"
                
                designDayLabel(lbl, index)
            }
        }
    }
    
    
}


class ItemView: UIView {
    let colorView = UIView()
    let itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.setDynamicType(font: .systemFont(style: .callout, weight: .semibold), textStyle: .callout)
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()
    let itemSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .secondaryLabel
        lbl.setDynamicType(font: .systemFont(style: .footnote))
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()
    let itemStart: UILabel = {
        let lbl = UILabel()
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.setDynamicType(font: .systemFont(style: .footnote))
        return lbl
    }()
    let itemEnd: UILabel = {
        let lbl = UILabel()
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.textColor = .secondaryLabel
        lbl.setDynamicType(font: .systemFont(style: .footnote))
        return lbl
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        let leftStack = UIStackView(axis: .vertical, arrangedSubviews: [itemTitle, itemSubtitle])
        let rightStack = UIStackView(axis: .vertical, arrangedSubviews: [itemStart, itemEnd])
        rightStack.distribution = .fillEqually
        rightStack.alignment = .trailing
        let itemContentStack = UIStackView(arrangedSubviews: [leftStack,rightStack])
        itemContentStack.spacing = 4
        
        self.addSubview(colorView)
        colorView.centerConstraints(centerYConstant: 0)
        colorView.setupConstraintsOnlyTo(to: self,leadingConstant: 0)
        colorView.layer.cornerRadius = 2
        colorView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        colorView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
        
        self.addSubview(itemContentStack)
        itemContentStack.setupConstraintsOnlyTo(to: colorView, leadingConstant: 8)
        itemContentStack.setupConstraintsOnlyTo(to: self, topConstant: 0, trailingConstant: 0, bottomConstant: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(title: String? = nil, subtitle: String? = nil, start: String? = nil, end: String? = nil){
        if title == nil {
            colorView.backgroundColor = .clear
        }else {
            colorView.backgroundColor = .systemPurple
        }
        itemTitle.text = title
        itemSubtitle.text = subtitle
        itemStart.text = start
        itemEnd.text = end
    }
    
}
