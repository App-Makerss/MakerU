//
//  LogInViewController.swift
//  MakerU
//
//  Created by Patricia Amado Ferreira de Mello on 09/11/20.
//

import Foundation
import AuthenticationServices
import UIKit

class LogInViewController: UIViewController{
    
    //MARK: View Code Set up
    private let loginProviderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        stack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        stack.clipsToBounds = true
        
        return stack
    }()
    
    private let textContent: UIStackView = {
        let content = UIStackView()
        content.axis = .vertical
        content.spacing = 16
        content.distribution = .fillProportionally
        
        return content
    }()
    
    let viewTitle: UILabel = {
        let title = UILabel()
        title.setDynamicType(font: .systemFont(style: .largeTitle, weight: .light), textStyle: .largeTitle)
        title.text = "MakerU"
        title.heightAnchor.constraint(equalToConstant: 41).isActive = true
        title.widthAnchor.constraint(equalToConstant: 112).isActive = true
        title.numberOfLines = 0
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return title
    }()
    
    let cardSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        subtitle.setDynamicType(font: .systemFont(style: .callout), textStyle: .callout)
        subtitle.heightAnchor.constraint(equalToConstant: 49).isActive = true
        subtitle.widthAnchor.constraint(equalToConstant: 326).isActive = true
        subtitle.text = "Inicie uma sessão para poder utilizar os serviços de criação de projetos e reservas."
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        return subtitle
    }()
    
    let footnoteText: UILabel = {
        let footnote = UILabel()
        footnote.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        footnote.setDynamicType(font: .preferredFont(forTextStyle: .footnote))
        footnote.text = "Ao iniciar sessão você aceita nossos Termos de Uso e Política de Privacidade."
        footnote.heightAnchor.constraint(equalToConstant: 34).isActive = true
        footnote.widthAnchor.constraint(equalToConstant: 316).isActive = true
        footnote.textAlignment = .center
        footnote.numberOfLines = 0
        return footnote
    }()
    
    private func stackSetUp() -> UIStackView {
        let upStack = UIStackView(arrangedSubviews: [viewTitle,cardSubtitle])
        upStack.spacing = 16
        upStack.axis = .vertical
        upStack.distribution = .fillProportionally
        
        let content = UIStackView(arrangedSubviews: [upStack, loginProviderStackView])
        content.spacing = 44
        content.axis = .vertical
        
        let firstSessionStack = UIStackView(arrangedSubviews: [content, footnoteText])
        firstSessionStack.axis = .vertical
        firstSessionStack.spacing = 427
        
        return firstSessionStack
    }
    
    func setupNavigations() {
        let cancelBarItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelBarItemTapped))
        cancelBarItem.tintColor = UIColor.systemPurple
        
        self.navigationItem.leftBarButtonItem = cancelBarItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Voltar"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .popover
        self.setupNavigations()
        
        let stacks = stackSetUp()
        stacks.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stacks)
        setupContraints(stack: stacks)
        
        view.backgroundColor = .systemBackground
        
        setupProviderLoginView()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
        let authorizationButton = SignInWithAppleButton(self, action: #selector(self.handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        authorizationButton.cornerRadius = 6
        
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func setupContraints(stack: UIView) {
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 51).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func cancelBarItemTapped() {
        //Todo: passar as informaçoes pra volta
        self.dismiss(animated: true, completion: nil)
    }
}

extension LogInViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        print("Teria um segue para a proxima view")
        let viewController = LoginTitleViewController(style: .insetGrouped)

        //Removi o .text de todos os campos
        guard let makerspace = UserDefaults.standard.value(forKey: "selectedMakerspace") as? String else {return}
        let user = User(name: fullName!.givenName!, email: email!, password: "", projects: [], makerspaces: [makerspace])
        viewController.user = user
        viewController.userIdentifierLabel = userIdentifier
        if let givenName = fullName?.givenName {
            viewController.givenNameLabel = givenName
        }
        if let familyName = fullName?.familyName {
            viewController.familyNameLabel = familyName
        }
        if let email = email {
            viewController.emailLabel = email
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

