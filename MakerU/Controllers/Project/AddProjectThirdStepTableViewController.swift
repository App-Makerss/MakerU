//
//  AddProjectThirdStepTableViewController.swift
//  MakerU
//
//  Created by Victoria Faria on 12/11/20.
//

import UIKit

class AddProjectThirdStepTableViewController: UITableViewController {

    var createProject: Project!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Novo Projeto"

        let nextButtonItem = UIBarButtonItem(title: "Próximo", style: .done, target: self, action: #selector(self.nextButtonItemTapped))
        nextButtonItem.tintColor = UIColor.systemPurple

        navigationItem.leftBarButtonItems?.removeAll()
        navigationController?.navigationBar.tintColor = .systemPurple

        self.navigationItem.rightBarButtonItem = nextButtonItem

        tableView.contentInset = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)

        // button back at secondStep
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
        section == 0 ? "IMAGEM DE CAPA" : nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        section == 0 ? "Adicione uma imagem de capa para ilustrar seu projeto. Este item é opcional." : nil
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
            let img = createProject.coverImage != nil ? UIImage(data: createProject.coverImage!) : UIImage(named: "imgPlaceholder")
            let imgView = UIImageView(image: img)
            imgCell.contentView.addSubview(imgView)
            imgView.setupConstraints(to: imgCell.contentView)
            imgView.heightAnchor.constraint(equalToConstant: 140).isActive = true
            imgView.contentMode = .scaleAspectFill
            imgCell.selectionStyle = .none

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
        let vc = AddProjectFourthStepTableViewController(style: .insetGrouped)
        vc.createProject = createProject
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension AddProjectThirdStepTableViewController: PickPhotoViewControllerDelegate {

    func photoPicked(image: UIImage?, viewController: PickPhotoViewController) {
        createProject.coverImage = image?.jpegData(compressionQuality: 1)
        viewController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
}
