//
//  ProfileViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 10/11/20.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: Outlet
    var collectionView: UICollectionView!
    fileprivate func loadReservations() {
        self.reservationService.loadUserReservations(of: self.user!) { (reservs, projs, error) in
            if let projs = projs {
                self.projects = projs
            }
            if let reservs = reservs {
                self.reservations = reservs
            }
        }
    }
    
    var user: User? = nil {
        didSet {
            DispatchQueue.main.async {
                if self.user != nil {
                    self.loadReservations()
                }
                self.collectionView.reloadData()
            }
        }
    }
    var reservations: [Reservation] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var projects: [Project] = []
    let horizontalInset: CGFloat = 16
    var reservationCardHeight: CGFloat {
        if traitCollection.preferredContentSizeCategory <= .large {
            return 120
        }else {
            let multplier:CGFloat = 0.05
            let coefficient = CGFloat(traitCollection.preferredContentSizeCategory.howMuchMoreThanLargeCategory())
            return 120 + (120 * (multplier*coefficient))
        }
        
    }
    // MARK: Attributes
    var loggedUserVerifier: LoggedUserVerifier!
    var reservationService = ReservationService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !loggedUserVerifier.verifyLoggedUser() {
            return
        }
        if user == nil {
            guard let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else { return }
            UserDAO().find(byId: loggedUserID) { (user, error) in
                if let user = user {
                    self.user = user
                }
            }
        }else {
            loadReservations()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecitonView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), primaryAction: UIAction(handler: {_ in
            let vc = NotificationsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        navigationController?.navigationBar.tintColor = .systemPurple
        view.backgroundColor = .systemGroupedBackground
        loggedUserVerifier = LoggedUserVerifier(verifierVC: self)
        if !loggedUserVerifier.verifyLoggedUser() {
            return
        }
    }

    //MARK: Setups
    func setupCollecitonView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "listCell")
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "addProjCell")
        collectionView.register(ReservationCollectionViewCell.self, forCellWithReuseIdentifier: ReservationCollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "celular")
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setupConstraints(to: view, topSafeArea: true)
    }


    //MARK: Inits
    fileprivate func initItems() {
        let item =  UITabBarItem()
        item.title = "Perfil"
        item.image = UIImage(systemName: "person.crop.circle.fill")
        self.tabBarItem = item
        navigationItem.title = "Perfil"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = {(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var section: NSCollectionLayoutSection!
            switch sectionIndex {
                case 1:
                    section = self.makeBioSection(layoutEnvironment)
                    break
                case 2:
                    section = self.makeAddProjectSection(layoutEnvironment)
                    break
                case 3:
                    section = self.makeReservationsSection()
                    break
                default:
                    section = self.makeHeaderProfile(layoutEnvironment)
                    break
            }

            if sectionIndex > 0 {
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    /// Create a section of CollectionView - the static section
    /// - Returns: a section
    func makeAddProjectSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false

        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 8, trailing: horizontalInset)
        return section
    }

    func makeBioSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false

        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 8, trailing: horizontalInset)
        return section
    }

    func makeHeaderProfile(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize: NSCollectionLayoutSize

        groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)

        return section
    }
    
    func makeReservationsSection() -> NSCollectionLayoutSection? {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize
        
        groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .absolute(reservationCardHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        
        return section
    }

    //MARK: View Code Setup

    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "profilePlaceholder")
        img.heightAnchor.constraint(equalToConstant: 75).isActive = true
        img.widthAnchor.constraint(equalToConstant: 75).isActive = true
        img.tintColor = .purple
        img.layer.cornerRadius = 36
        img.clipsToBounds = true
        return img
    }()

    let profileName: UILabel = {
        let name = UILabel()
        name.setDynamicType(font: .systemFont(style: .title2, weight: .bold))
        name.text = "Gabriel Branco"
        name.numberOfLines = 0
        name.textAlignment = .center
        name.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return name
    }()

    let profileSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        subtitle.textAlignment = .center
        subtitle.setDynamicType(font: .preferredFont(forTextStyle: .subheadline))
        subtitle.text = "Graduado em Engenharia da Computação"
        subtitle.numberOfLines = 0
        return subtitle
    }()
}

//MARK: CollectionViewDelegate and CollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 3 ? reservations.count : 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        switch indexPath.section {
            case 1:
                let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! UICollectionViewListCell
                var content = UIListContentConfiguration.valueCell()
                content.text = user?.description
                listCell.contentConfiguration = content
                listCell.selectedBackgroundView = nil
                
                cell = listCell
                break
                
            case 2:
                let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addProjCell", for: indexPath) as! UICollectionViewListCell
                listCell.subviews.forEach({$0.removeFromSuperview()})
                let btn = UIButton()
                btn.setTitle("Adicionar Projeto", for: .normal)
                btn.setTitleColor( .systemPurple, for: .normal)
                btn.titleLabel?.setDynamicType(font: .systemFont(style: .callout, weight: .medium), textStyle: .callout)
                btn.tintColor = .systemPurple
                btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                btn.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.15)
                btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
                btn.isUserInteractionEnabled = false
                
                listCell.accessibilityTraits = [.button]
                listCell.addSubview(btn)
                btn.setupConstraints(to: listCell)
                btn.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
                
                cell = listCell
                break
                
            case 3:
                let reservationCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReservationCollectionViewCell.reuseIdentifier, for: indexPath) as! ReservationCollectionViewCell
                let reservation = reservations[indexPath.row]
                let project = projects.first(where: { $0.id == reservation.project})
                reservationCell.item.configView(title: project?.title, subtitle: "\(reservation.startDate.timeAsString()) - \(reservation.endDate.timeAsString())")
                reservationCell.day.text = "\(reservation.startDate.getDay())"
                reservationCell.weekdayLabel.text = reservation.startDate.getWeekday().uppercased()
                cell = reservationCell
                break
                
            default:
                let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "celular", for: indexPath)
                let upStack = UIStackView(arrangedSubviews: [profileImageView, profileName])
                upStack.axis = .vertical
                upStack.spacing = 16
                upStack.alignment = .center
                
                let downStack = UIStackView(arrangedSubviews: [upStack, profileSubtitle, UIView()])
                downStack.axis = .vertical
                downStack.spacing = 8
                downStack.alignment = .center
                
                listCell.addSubview(downStack)
                downStack.setupConstraints(to: listCell)
                
                profileName.text = user?.name
                profileSubtitle.text = user?.ocupation
                
                cell = listCell
                break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else {
            fatalError("cannot dequeue TitleSupplementaryView")
        }
        if indexPath.section == 2 {
            header.textLabel.text = "Projetos"
        }
        if indexPath.section == 1 {
            header.textLabel.text = "Bio"
        }
        if indexPath.section == 3 {
            header.textLabel.text = "Reservas"
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            if !loggedUserVerifier.verifyLoggedUser() {
                return
            }
            let vc = AddProjectFirstStepTableViewController(style: .insetGrouped)
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
}
