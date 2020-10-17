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
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MatchCardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()


    let configDisplayButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Configurações de exibição", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(Self.configDisplayButtonTapped), for: .touchUpInside)
        return btn
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
        let displayConfigurationVC = MatchDisplayConfigurationTableViewController()
        let navigation = UINavigationController(rootViewController: displayConfigurationVC)
        present(navigation, animated: true, completion: nil)
    }

    func setupContraints() {

        // constraint CollectionView
        collectionView.backgroundColor = .clear
        let safeAnchors = view.safeAreaLayoutGuide
        collectionView.topAnchor.constraint(equalTo: safeAnchors.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: configDisplayButton.topAnchor, constant: -16).isActive = true

        // constraint Button
        configDisplayButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
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
        CGSize(width: collectionView.bounds.width*0.9, height: collectionView.bounds.height)
    }
}
