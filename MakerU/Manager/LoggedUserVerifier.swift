//
//  LoggedUserVerifier.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 17/11/20.
//

import UIKit
import AuthenticationServices

struct LoggedUserVerifier {
    var verifierVC: UIViewController
    
    func verifyLoggedUser() -> Bool {
        guard let _ = UserDefaults.standard.string(forKey: "loggedUserId") else {self.isUserLogged(); return false }
        return true
    }
    private func isUserLogged(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
                case .authorized:
                    break // The Apple ID credential is valid.
                case .revoked, .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    DispatchQueue.main.async {
                        let login = LogInViewController()
                        let navigation = UINavigationController(rootViewController: login)
                        self.verifierVC.present(navigation, animated: true, completion: nil)
                    }
                default:
                    break
            }
        }
    }
}
