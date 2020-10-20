//
//  MatchViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 13/10/20.
//

import UIKit

class MatchViewController: UIViewController {

    let matchService = MatchService()
    
    var matchSuggestions: [MatchCard] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MatchCardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.masksToBounds = false
        cv.layer.shadowRadius = 4
        cv.layer.shadowOpacity = 0.25
        cv.layer.shadowOffset = CGSize(width: 0, height:2)
        return cv
    }()


    let configDisplayButton: UIControl = {
        
        let control = UIControl()
        control.backgroundColor = .systemBackground
        control.layer.cornerRadius = 15
        control.translatesAutoresizingMaskIntoConstraints = false
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "notToReuse")
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: "person.2.square.stack")
        cell.imageView?.tintColor = .systemPurple
        cell.textLabel?.text = "Configurações de exibição"
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.isUserInteractionEnabled = false
        
        control.addSubview(cell)
        
        cell.topAnchor.constraint(equalTo: control.topAnchor).isActive = true
        cell.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: 5).isActive = true
        cell.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -5).isActive = true
        cell.bottomAnchor.constraint(equalTo: control.bottomAnchor).isActive = true

        control.addTarget(self, action: #selector(Self.configDisplayButtonTapped), for: .touchUpInside)
        
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(configDisplayButton)
        view.addSubview(collectionView)
        view.backgroundColor = .systemGray6

        collectionView.delegate = self
        collectionView.dataSource = self

        setupNavigations()
        setupContraints()
        
        CategoryDAO().listAll { (categories, error) in
            if let categories = categories{
                self.matchService.matchSuggestions(by: "8A0C55B3-0DB5-7C76-FFC7-236570DF3F77", categories: categories) { (matchCards, error) in
                    if let matchCards = matchCards{
                        self.matchSuggestions.append(contentsOf: matchCards)
                    }
                }
            }
        }
        
       
    }
    
    func setupNavigations() {
        navigationItem.title = "Encontrar pessoas"
        let item = UITabBarItem()
        item.title = "Match"
        item.image = UIImage(systemName: "square.fill.on.square.fill")
        self.tabBarItem = item
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
    
    @objc func configDisplayButtonTapped() {
        let displayConfigurationVC = MatchDisplayConfigurationTableViewController(style: .insetGrouped)
        let navigation = UINavigationController(rootViewController: displayConfigurationVC)
        present(navigation, animated: true, completion: nil)
    }

    func setupContraints() {

        // constraint CollectionView
        collectionView.backgroundColor = .clear
        let safeAnchors = view.safeAreaLayoutGuide
        collectionView.topAnchor.constraint(equalTo: safeAnchors.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: configDisplayButton.topAnchor, constant: -16).isActive = true

        // constraint Button
        configDisplayButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        configDisplayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        configDisplayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        configDisplayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -99).isActive = true
    }
}

extension MatchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matchSuggestions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MatchCardCollectionViewCell
        cell.delegate = self
        cell.cardFace = .front
        let item = matchSuggestions[indexPath.row]
        cell.cardTitle.text = item.title
        cell.cardSubtitle.text = item.subtitle
        cell.cardImageView.image = item.image
        cell.cardFirstSessionTitle.text = item.firstSessionTitle
        cell.cardFirstSessionDescription.text = item.firstSessionLabel
        cell.cardSecondSessionTitle.text = item.secondSessionTitle
        cell.cardSecondSessionDescription.text = item.secondSessionLabel
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: configDisplayButton.bounds.width, height: collectionView.bounds.height*0.98)
    }
}


extension MatchViewController: MatchCardCollectionViewCellDelegate {
    fileprivate func removeCard(for currentIndex: IndexPath) {
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [currentIndex])
            self.matchSuggestions.remove(at: currentIndex.row)
        }, completion:nil)
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
                    self.collectionView.layer.shadowOpacity = 0
                    cell.cardFace = .back
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.removeCard(for: currentIndex)

                    self.collectionView.layer.shadowOpacity = 0.25
                }
            }else{
                DispatchQueue.main.async {
                    self.removeCard(for: currentIndex)
                }
            }
            
        }
            
        
    }
}
