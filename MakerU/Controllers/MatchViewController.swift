//
//  MatchViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import UIKit

class MatchViewController: UIViewController, UICollectionViewDelegate {
    //MARK: Config attributes
    var dataSource: UICollectionViewDiffableDataSource<String,MatchCard>!

    //MARK: Attributes
    let matchService = MatchService()
    var matchSuggestions: [MatchCard] = []
    
    //MARK: Outlets
    var collectionView: UICollectionView!
    let configDisplayButton: UIControl = {
        
        let control = UIControl()
        control.backgroundColor = .secondarySystemGroupedBackground
        control.layer.cornerRadius = 10
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "notToReuse")
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: "person.2.square.stack")
        cell.imageView?.tintColor = .systemPurple
        cell.textLabel?.text = "Configurações de exibição"
        cell.textLabel?.setDynamicType(font: .systemFont(style: .body))
        cell.isUserInteractionEnabled = false
        
        control.addSubview(cell)
        
        cell.setupConstraints(to: control)
        
        control.addTarget(self, action: #selector(Self.configDisplayButtonTapped), for: .touchUpInside)
        
        return control
    }()
    
    //MARK: Load data
    fileprivate func loadMatchSuggestions() {
        CategoryDAO().listAll { (categories, error) in
            if let categories = categories{
                self.matchService.matchSuggestions(by: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77", categories: categories) { (matchCards, error) in
                    if let matchCards = matchCards{
                        self.matchSuggestions = matchCards
                        self.updateSnapshot()
                    }
                }
            }
        }
    }
    
    
    //MARK: View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(configDisplayButton)
        view.backgroundColor = .systemGroupedBackground
        
        setupCollecitonView()
        setupContraints()
        setupNavigations()
        
        configureDataSource()
        configureSnapshot()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMatchSuggestions()
    }
    
    //MARK: Setups
    func setupCollecitonView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(MatchCardCollectionViewCell.self, forCellWithReuseIdentifier: MatchCardCollectionViewCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
        
    }

    func setupNavigations() {
        navigationItem.title = "Encontrar pessoas"
        let item = UITabBarItem()
        item.title = "Match"
        item.image = UIImage(systemName: "square.fill.on.square.fill")
        self.tabBarItem = item
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear

        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(self.presentMatchOnboarding))
        infoButton.tintColor = .systemPurple
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    func setupContraints() {
        
        // constraint CollectionView
        collectionView.backgroundColor = .clear
        collectionView.setupConstraints(to: view, leadingConstant: 0,topConstant: 0, trailingConstant: 0, topSafeArea: true)
        collectionView.bottomAnchor.constraint(equalTo: configDisplayButton.topAnchor, constant: -16).isActive = true
        
        // constraint Button
        configDisplayButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        configDisplayButton.setupConstraintsOnlyTo(to: view, leadingConstant: 16, trailingConstant: -16, bottomConstant: -16, bottomSafeArea: true)
    }
    
    //MARK: @ojbc funcs
    @objc func configDisplayButtonTapped() {
        let displayConfigurationVC = MatchDisplayConfigurationTableViewController(style: .insetGrouped)
        let navigation = UINavigationController(rootViewController: displayConfigurationVC)
        present(navigation, animated: true, completion: nil)
    }
    
    @objc func seeMoreButtonTapped() {
        let displayInfoVC = MatchCardInfoViewController()
        let navigation = UINavigationController(rootViewController: displayInfoVC)
        present(navigation, animated: true, completion: nil)
    }
    
    @objc func presentMatchOnboarding(){
        let presentMatchOnboardingVC = MatchOnboardingViewController()
        let navigation = UINavigationController(rootViewController: presentMatchOnboardingVC)
        present(navigation, animated: true, completion: nil)
    }
    
}

//MARK: UICollectionViewDiffableDataSource & UICollectionViewCompositionalLayout
extension MatchViewController  {
    typealias cardsDataSource = UICollectionViewDiffableDataSource<String,MatchCard>
    
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = {(sectionIdex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize: NSCollectionLayoutSize
            
            groupSize =  NSCollectionLayoutSize(widthDimension: .absolute(self.view.bounds.width-32), heightDimension: .fractionalHeight(0.99))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.interGroupSpacing = 8
            
            return section
            
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func configureDataSource() {
        dataSource = cardsDataSource(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, tutorial) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCardCollectionViewCell.reuseIdentifier, for: indexPath) as? MatchCardCollectionViewCell else {
                fatalError("Cannot create MatchCardCollectionViewCell")
            }
            cell.delegate = self
            cell.cardFace = .front
            let item = self.matchSuggestions[indexPath.row]
            cell.cardTitle.text = item.title
            cell.cardSubtitle.text = item.subtitle
            
            if item.type == .project {
                cell.cardTitle.accessibilityValue = "título do projeto"
                cell.cardSubtitle.accessibilityValue = "categoria"
            }else {
                cell.cardTitle.accessibilityValue = "Nome do usuário"
                cell.cardSubtitle.accessibilityValue = ""
            }
            
            if let imageData = item.image {
                cell.cardImageView.image = UIImage(data: imageData) ?? UIImage(systemName: "person.fill")
            }
            cell.cardFirstSessionTitle.text = item.firstSessionTitle
            cell.cardFirstSessionDescription.text = item.firstSessionLabel
            cell.cardSecondSessionTitle.text = item.secondSessionTitle
            cell.cardSecondSessionDescription.text = item.secondSessionLabel
            
            return cell
        })
    }
    func addSectionAndItens(_ currentSnapshot: inout NSDiffableDataSourceSnapshot<String, MatchCard>) {
        currentSnapshot.appendSections(["cards"])
        currentSnapshot.appendItems(self.matchSuggestions, toSection: "cards")
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<String, MatchCard>()
        addSectionAndItens(&currentSnapshot)
        dataSource.apply(currentSnapshot,animatingDifferences: false)
    }
    
    func updateSnapshot() {
        var currentSnapshot = self.dataSource.snapshot()
        if currentSnapshot.numberOfSections > 0 {
            if currentSnapshot.numberOfItems == 0{
                currentSnapshot.appendItems(self.matchSuggestions, toSection: "cards")
            }else {
                currentSnapshot.deleteAllItems()
                addSectionAndItens(&currentSnapshot)
            }
            self.dataSource.apply(currentSnapshot,animatingDifferences: true)
        }
    }
}

//MARK: MatchCardCollectionViewCellDelegate
extension MatchViewController: MatchCardCollectionViewCellDelegate {
    
    /// Present's the The MatchCardInfoViewController Modal
    /// - Parameter nextScreen: The MatchCardInfoViewController
    func seeMoreButtonButtonTapped(_ cell: MatchCardCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell)
        else {return}
        let displayInfoVC = MatchCardInfoViewController()
        displayInfoVC.config(with: matchSuggestions[indexPath.row])
        let navigation = UINavigationController(rootViewController: displayInfoVC)
        present(navigation, animated: true, completion: nil)
    }
    
    fileprivate func removeCard(for card: MatchCard) {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteItems([card])
        matchSuggestions.removeAll {$0.id == card.id}
        dataSource.apply(currentSnapshot, animatingDifferences: true)
        
    }
    
    func collaborateButtonTapped(_ cell: MatchCardCollectionViewCell) {
        //TODO: animates the card flowing up
        guard let currentIndex = collectionView.indexPath(for: cell),
              let loggedUserID = UserDefaults.standard.string(forKey: "loggedUserId") else {return}
        
        let card = matchSuggestions[currentIndex.row]
        
        let match = Match(id: nil, part1: loggedUserID, part2: card.id)
        
        matchService.verifyMatch(match: match) { isMutual in
            if isMutual {
                DispatchQueue.main.async {
                    cell.cardFace = .back
                }
                DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
                    self.removeCard(for: card)
                }
            }else{
                DispatchQueue.global().async {
                    self.removeCard(for: card)
                }
            }
        }
    }
}
