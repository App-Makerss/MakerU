//
//  AboutItemViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 26/10/20.
//

import UIKit

class AboutItemViewController: UIViewController {
    
    // MARK: Layout Config
    var scrollEdgeAppearanceTintColor: UIColor = .white
    var defaultTintColor: UIColor = .systemPurple
    
    // MARK: Outlet
    var tableView: UITableView!
    var reservationCell: ReservationCalendarTableViewCell!
    
    // MARK: Attributes
    var loggedUserVerifier:LoggedUserVerifier!
    var selectedRoom: Room? {
        didSet {
            navigationItem.title = selectedRoom?.title
            loadReservations()
        }
    }
    var selectedEquip: Equipment?{
        didSet {
            navigationItem.title = selectedEquip?.title
            loadReservations()
        }
    }
    
    var selectedDate: Date = Date() {
        didSet {
            if oldValue != selectedDate {
                loadReservations()
            }
        }
    }
    
    var reservationService = ReservationService()
    var reservations: [Reservation] = []
    var projects: [Project] = []
    
    func loadReservations() {
        let item = selectedRoom != nil ? selectedRoom!.id! : selectedEquip!.id!
        reservationService.loadReservations(of: item, by: selectedDate) { (reservs, projs, error) in
            print(error?.localizedDescription)
            if let reservs = reservs {
                self.reservations = reservs
            }else {
                print("could not load reservations")
            }
            if let projs = projs {
                self.projects = projs
            }else {
                print("could not load projects")
            }
            DispatchQueue.main.async {
                self.reservationCell.reloadReservations(reservations: self.reservations, projects: self.projects)
            }
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loggedUserVerifier = LoggedUserVerifier(verifierVC: self)
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
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        view.backgroundColor = tableView.backgroundColor
        
        tableView.clipsToBounds = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.setupConstraints(to: view, topConstant: 16, topSafeArea: true)
    }
    
    fileprivate func initItems() {
        setupNavigationBarColor()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Table view delegate and data source
extension AboutItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        selectedEquip != nil ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2:
                return 1
            case 1:
                return 2
            default:
                return selectedRoom?.descriptionStrings.count ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)

        view.addSubview(label)
        label.accessibilityTraits = .header
        label.setupConstraints(to: view, leadingConstant: 4)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        switch section {
            case 2:
                label.text = "Ocorrências"
            case 1:
                label.text = "Reservas"
            default:
                label.text = "Sobre"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        switch indexPath.section{
            case 2:
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Reportar"
                cell.textLabel?.setDynamicType(font: .systemFont(style: .body))
                cell.textLabel?.textColor = .systemPurple
                break
            case 1:
                if row == 1{
                    cell.accessoryType = .none
                    cell.selectionStyle = .none
                    let button = UIButton(type: .system)
                    button.setTitle("AGENDAR", for: .normal)
                    button.accessibilityLabel = "agendar"
                    button.backgroundColor = .systemPurple
                    button.layer.cornerRadius = 13
                    button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 14, bottom: 4, right: 14)
                    button.setTitleColor(.white, for: .normal)
                    cell.contentView.addSubview(button)
                    button.titleLabel?.setDynamicType(font: .systemFont(style: .footnote, weight: .semibold), textStyle: .footnote)
                    button.setupConstraintsOnlyTo(to: cell.contentView,topConstant: 18, trailingConstant: -22, bottomConstant: -18)
                    button.addTarget(self, action: #selector(self.reservationButtonTap), for: .touchUpInside)
                }else {
                    reservationCell = ReservationCalendarTableViewCell()
                    reservationCell.delegate = self
                    reservationCell.showingProjects = projects
                    reservationCell.showingReservations = reservations
                    cell = reservationCell
                }
                break
            default:
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
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            if !loggedUserVerifier.verifyLoggedUser() {
                return
            }
            let vc = OccurrencesTableViewController(style: .insetGrouped)
            vc.selectedEquipment = self.selectedEquip
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
    @objc func reservationButtonTap() {
        if !loggedUserVerifier.verifyLoggedUser() {
            return 
        }
        print("it will open reservation flow")
        let vc = ReservationTableViewController(style: .insetGrouped)
        vc.selectedEquipment = selectedEquip
        vc.selectedRoom = selectedRoom
        vc.selectedDate = selectedDate
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

//MARK: scrollViewDelegate
extension AboutItemViewController: ScrollableCover {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}

extension AboutItemViewController: ReservationCalendarTableViewCellDelegate {
    func didSelected(_ date: Date) {
        self.selectedDate = date
    }
}
