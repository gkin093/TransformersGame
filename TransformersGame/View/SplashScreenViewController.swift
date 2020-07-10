//
//  SplashScreenViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit
import RxSwift

class SplashScreenViewController: UIViewController {
    fileprivate lazy var splashImage: UIImageView = UIImageView(image: UIImage(named: "splash_image"))
    let disposeBag = DisposeBag()
    let viewModel: SplashScreenViewModel = SplashScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.generateToken()
    }
    
    func setupView() {
        view.addSubview(splashImage)
        setupConstraints()
        splashImage.contentMode = .scaleAspectFit
    }
    
    func setupConstraints() {
        splashImage.translatesAutoresizingMaskIntoConstraints = false
        let leftImageConstraint = NSLayoutConstraint(item: splashImage, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: splashImage, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: splashImage, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: splashImage, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leftImageConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    func setupObservables() {
        viewModel.hasToken.subscribe { (hasToken) in
            let topViewController = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first?.rootViewController
            if hasToken.element ?? false {
                topViewController?.present(MainViewController(), animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Something went wrong, please try again later", preferredStyle: UIAlertController.Style.alert)
                topViewController?.present(alert, animated: false, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}
