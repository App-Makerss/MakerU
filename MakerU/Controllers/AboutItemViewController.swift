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

    // MARK: Attributes
    var selectedRoom: Room? {
        didSet {
            navigationItem.title = selectedRoom?.title
        }
    }
    var selectedEquip: Equipment?{
        didSet {
            navigationItem.title = selectedEquip?.title
        }
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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

        tableView.setupConstraintsRelatedToSafeArea(to: view, topConstant: 16)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedRoom != nil {
            return selectedRoom!.descriptionStrings.count
        }
        return 1
    }

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()
        let label = UILabel()
        label.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.text = "Sobre"

        switch section {
        default:
            return view
        }
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

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
        return cell
    }
}

//MARK: scrollViewDelegate
extension AboutItemViewController: ScrollableCover {
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.adjustCoverScroll(scrollView)
    }
}
