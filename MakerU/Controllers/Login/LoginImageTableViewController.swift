//
//  LoginImageTableViewController.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 27/11/20.
//

import UIKit

class LoginImageTableViewController: UITableViewController {

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Cadastre-se"

        let nextButtonItem = UIBarButtonItem(title: "Concluir", style: .done, target: self, action: #selector(self.nextButtonItemTapped))
        nextButtonItem.tintColor = UIColor.systemPurple

        navigationItem.leftBarButtonItems?.removeAll()
        navigationController?.navigationBar.tintColor = .systemPurple

        self.navigationItem.rightBarButtonItem = nextButtonItem

        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)

        navigationItem.backButtonTitle = "Voltar"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "FOTO DE PERFIL" : nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Adicione uma imagem para ilustrar seu perfil. Este item é opcional. " : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.section {
        case 1:
            let listCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            let btn = UIButton()
            btn.setTitle("Adicionar Imagem", for: .normal)
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
        default:
            let imgCell = UITableViewCell(style: .default, reuseIdentifier: "imgCell")
            let img = user.profileImage != nil ? UIImage(data: user.profileImage!) : UIImage(named: "imgPlaceholder")
            let imgView = UIImageView(image: img)
            imgCell.contentView.addSubview(imgView)
            imgView.centerConstraints(centerYConstant: 1, centerXConstant: 1)
            imgView.heightAnchor.constraint(equalTo: imgCell.contentView.heightAnchor, multiplier: 0.75).isActive = true
            imgView.widthAnchor.constraint(equalTo:imgView.heightAnchor).isActive = true
            imgView.layer.cornerRadius = 53
            imgView.clipsToBounds = true
            imgCell.contentView.heightAnchor.constraint(equalToConstant: 140).isActive = true
            imgView.backgroundColor = .secondarySystemGroupedBackground
            imgView.contentMode = .scaleAspectFill
            imgCell.selectionStyle = .none
            imgCell.backgroundColor = .clear

            cell = imgCell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let vc = PickPhotoViewController()
            vc.delegate = self
            present(vc, animated: true, completion: nil)

        }
    }

    @objc func nextButtonItemTapped() {
        if self.user.id != nil {
            UserDAO().update(entity: user) { (updatedUser, error) in
                if let updatedUser = updatedUser {
                    UserDefaults.standard.setValue(updatedUser.id!, forKey: "loggedUserId")
                    NotificationCenter.default.post(name: NSNotification.Name("registrationDidFinish"), object: nil)
                    
                }else {
                    print(error?.localizedDescription)
                }
            }
        }else {
            UserDAO().save(entity: user) { (savedUser, error) in
                if let savedUser = savedUser {
                    UserDefaults.standard.setValue(savedUser.id!, forKey: "loggedUserId")
                    NotificationCenter.default.post(name: NSNotification.Name("registrationDidFinish"), object: nil)
                }else {
                    print(error?.localizedDescription)
                }
            }
        }
        dismiss(animated: true)
    }

}

extension LoginImageTableViewController: PickPhotoViewControllerDelegate {

    func photoPicked(image: UIImage?, viewController: PickPhotoViewController) {
        user.profileImage = image?.jpegData(compressionQuality: 1)
        viewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
}
