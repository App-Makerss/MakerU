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

    let horizontalInset: CGFloat = 29

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecitonView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), primaryAction: UIAction(handler: {_ in
            let vc = NotificationsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        navigationController?.navigationBar.tintColor = .systemPurple
    }

    //MARK: Setups
    func setupCollecitonView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "listCell")
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
            default:
                section = self.makeAddProjectSection(layoutEnvironment)
                break
            }

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(52))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    /// Create third section of CollectionView - the static section
    /// - Returns: a section
    func makeAddProjectSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false

        let section = NSCollectionLayoutSection.list(using: configuration,
                                                     layoutEnvironment: layoutEnvironment)

        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: horizontalInset, bottom: 0, trailing: horizontalInset)
        return section
    }

}

//MARK: CollectionViewDelegate and CollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        switch indexPath.section {
        default:
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! UICollectionViewListCell
            let btn = UIButton()
            btn.setTitle("Adicionar Projeto", for: .normal)
            btn.setTitleColor( .systemPurple, for: .normal)
            btn.titleLabel?.setDynamicType(font: .systemFont(style: .callout, weight: .medium), textStyle: .callout)
            btn.tintColor = .systemPurple
            btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            btn.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.15)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)

            listCell.accessibilityTraits = [.button]
            listCell.addSubview(btn)
            btn.setupConstraints(to: listCell)
            btn.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

            cell = listCell
            break
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as? TitleSupplementaryView else {
            fatalError("cannot dequeue TitleSupplementaryView")
        }
        if indexPath.section == 0 {
            header.textLabel.text = "Projetos"
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = AddProjectFirstStepTableViewController(style: .insetGrouped)
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }

}
