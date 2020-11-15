//
//  PickPhotoViewController.swift
//
//  Created by Bruno Cardoso Ambrosio on 23/08/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//
import UIKit

protocol PickPhotoViewControllerDelegate: class {
    func photoPicked(image: UIImage?, viewController: PickPhotoViewController)
}

class PickPhotoViewController: UIViewController {
    
    // MARK: - Propertie
    weak var delegate: PickPhotoViewControllerDelegate?
    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.addChild(picker)
        return picker
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(imagePicker)
        view.addSubview(imagePicker.view)
        navigationController?.navigationBar.tintColor = .systemPurple
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagePicker.view.frame = view.bounds
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PickPhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey: Any]) {
        
        
        let image =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
//        _ = navigationController?.popViewController(animated: true)
        delegate?.photoPicked(image: image, viewController: self)
    }
}

// MARK: - UINavigationControllerDelegate
extension PickPhotoViewController: UINavigationControllerDelegate {
}

