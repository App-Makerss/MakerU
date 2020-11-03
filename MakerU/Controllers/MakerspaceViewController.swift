//
//  MakerspaceTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 22/10/20.
//

import UIKit

class MakerspaceViewController: UIViewController {

    // MARK: Layout Config
    var scrollEdgeAppearanceTintColor: UIColor = .white
    var defaultTintColor: UIColor = .systemPurple
    let horizontalInset: CGFloat = 29

    // MARK: Outlet
    var collectionView: UICollectionView!

    // MARK: Attributes
    var equipments: [Equipment] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet([0]))
            }
        }
    }
    
    var rooms: [Room] = []{
        didSet {
            DispatchQueue.main.async {
                print("count \(self.rooms.count)")
                self.collectionView.reloadSections(IndexSet([1]))
            }
        }
    }
    
    
    //MARK: View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCoverImage(image: UIImage(named: "test"))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecitonView()

        self.view.backgroundColor = .systemBackground
        let makerspaceRef = EquipmentDAO().generateRecordReference(for: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77", action: .deleteSelf)
        let pred = NSPredicate(format: "makerspace == %@", makerspaceRef)
        EquipmentDAO().listAll(by: pred) { (equipments, error) in
            print(error?.localizedDescription)
            if let equipments = equipments {
                self.equipments = equipments
            }
        }
        RoomDAO().listAll(by: pred) { (rooms, error) in
            print(error?.localizedDescription)
            if let rooms = rooms {
                self.rooms = rooms.shuffled()
            }
        }
    }

    //MARK: Setups
    func setupCollecitonView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(RoomCollectionViewCell.self, forCellWithReuseIdentifier: RoomCollectionViewCell.reuseIdentifier)
        collectionView.register(EquipmentCollectionViewCell.self, forCellWithReuseIdentifier: EquipmentCollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "listCell")
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.setupConstraints(to: view, topSafeArea: true)
        
    }

    //MARK: Inits
    fileprivate func initItems() {
        let item =  UITabBarItem()
        item.title = "Espaço"
        item.image = UIImage(systemName: "house.fill")
        self.tabBarItem = item
        navigationItem.title = "Espaço"
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

//MARK: CollectionView Delegte and Data Source
extension MakerspaceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItens = 0
        switch section {
            case 1:
                numberOfItens = !rooms.isEmpty && rooms.count >= 4 ? 4 :rooms.count
                break
            case 2:
                numberOfItens = 2
                break
            default:
                numberOfItens = equipments.count
                break
        }
        return numberOfItens
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else {
            fatalError("cannot dequeue TitleSupplementaryView")
        }
        
        if indexPath.section == 0 {
            header.textLabel.text = "Equipamentos"
        }else if indexPath.section == 1 {
            header.textLabel.text = "Salas"
            header.showsTopDivider = true
        }else {
            header.textLabel.text = "Entrar em contato"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        switch indexPath.section {
            case 1:
                let roomCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCollectionViewCell.reuseIdentifier, for: indexPath) as! RoomCollectionViewCell
                let item = rooms[indexPath.row]
                roomCell.title.text = item.title
                roomCell.title.accessibilityTraits = .button
                roomCell.imageView.image = UIImage(data: item.image ?? Data())
                
                cell = roomCell
                break
            case 2:
                let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! UICollectionViewListCell
                listCell.backgroundColor = .systemBackground
                var content = UIListContentConfiguration.cell()
                content.textProperties.color = .systemPurple
                if indexPath.row == 0{
                    content.text = "Aplicar para monitoria"
                }else {
                    content.text = "Reportar ocorrência"
                }
                listCell.accessibilityTraits = [.button]
                listCell.contentConfiguration = content
                listCell.accessories = [.disclosureIndicator()]
                return listCell
            default:
                let equipCell = collectionView.dequeueReusableCell(withReuseIdentifier: EquipmentCollectionViewCell.reuseIdentifier, for: indexPath) as! EquipmentCollectionViewCell
                let equipItem = equipments[indexPath.row]
                equipCell.title.text = equipItem.title
                equipCell.title.accessibilityTraits = .button
                equipCell.subtitle.text = equipItem.metrics
                equipCell.imageView.image = UIImage(data: equipItem.image ?? Data())
                
                cell = equipCell
                break
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = AboutItemViewController()
        switch indexPath.section {
        case 1:
            let item = rooms[indexPath.row]
            vc.selectedRoom = item
            break
        case 2:
            if indexPath.row == 0 {
                let vc = ApplyForMonitoringTableViewController(style: .insetGrouped)
                present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }else {
                let vc = OccurrencesTableViewController(style: .insetGrouped)
                present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
            
            return
        default:
            let item = equipments[indexPath.row]
            vc.selectedEquip = item
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = {(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section: NSCollectionLayoutSection!
            switch sectionIndex {
                case 1:
                    section = self.makeSection1()
                    break
                case 2:
                    section = self.makeSection2(layoutEnvironment)
                    break
                default:
                    section = self.makeSection0()
                    break
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(52))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

            section.contentInsets.bottom = 29
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }


    /// Create first section of CollectionView - the equipment collection section
    /// - Returns: a section
    func makeSection0() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize
        
        groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.57), heightDimension: .absolute(170))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }

    /// Create second section of CollectionView - the room list section
    /// - Returns: a section
    func makeSection1() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize
        
        groupSize =  NSCollectionLayoutSize(widthDimension: .absolute(self.view.bounds.width-58), heightDimension: .fractionalHeight(0.17))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        section.interGroupSpacing = 16
        
        return section
    }

    /// Create third section of CollectionView - the static section
    /// - Returns: a section
    func makeSection2(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
                
        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        return section
    }
}

//MARK: scrollViewDelegate
extension MakerspaceViewController: ScrollableCover {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}
