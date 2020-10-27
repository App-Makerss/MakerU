//
//  MakerspaceTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 22/10/20.
//

import UIKit

class MakerspaceViewController: UIViewController {
    
    var scrollEdgeAppearanceTintColor: UIColor = .white
    var defaultTintColor: UIColor = .systemPurple
    
    var collectionView: UICollectionView!
    
    var equipments: [Equipment] = [] {
        didSet {
            collectionView.reloadSections(IndexSet([0]))
        }
    }
    
    
    //MARK: Layout attributes
    let horizontalInset: CGFloat = 29
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCoverImage(image: UIImage(named: "test"))
        
        let pred = NSPredicate(format: "makerspace == %@", "35D91B38-ED05-C6C6-DD97-CE01D997D55E")
        EquipmentDAO().listAll(by: pred) { (equipments, error) in
            if let equipments = equipments {
                self.equipments = equipments
            }
        }
        
        
        //load rooms
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    func setupCollecitonView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
        collectionView.register(RoomCollectionViewCell.self, forCellWithReuseIdentifier: RoomCollectionViewCell.reuseIdentifier)
        collectionView.register(EquipmentCollectionViewCell.self, forCellWithReuseIdentifier: EquipmentCollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "listCell")
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.setupConstraints(to: view, topConstant: 5)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecitonView()
        
        self.view.backgroundColor = .systemBackground
        
    }
    
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

extension MakerspaceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        }
        return section == 0 ? equipments.count : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else {
            fatalError("cannot dequeue TitleSupplementaryView")
        }
        
        if indexPath.section == 0 {
            header.textLabel.text = "Equipamentos"
        }else if indexPath.section == 1 {
            header.textLabel.text = "Salas"
        }else {
            header.textLabel.text = "Entrar em contato"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell!
        switch indexPath.section {
            case 1:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCollectionViewCell.reuseIdentifier, for: indexPath) as! RoomCollectionViewCell
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
                listCell.contentConfiguration = content
                listCell.accessories = [.disclosureIndicator()]
                return listCell
            default:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: EquipmentCollectionViewCell.reuseIdentifier, for: indexPath) as! EquipmentCollectionViewCell
                break
        }
        return cell
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
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

            section.contentInsets.bottom = 29
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
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
    
    func makeSection2(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
                
        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        return section
    }
}

//MARK: scrollViewDelegate
extension MakerspaceViewController: ScrollableCover {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}
