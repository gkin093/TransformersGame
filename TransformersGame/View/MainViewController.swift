//
//  MainViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 09/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    fileprivate lazy var createButton: UIButton = UIButton()
    fileprivate lazy var listButton: UIButton = UIButton()
    fileprivate lazy var duelButton: UIButton = UIButton()
    fileprivate lazy var container: UIStackView = UIStackView()
//    fileprivate lazy var container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    func setupComponents() {
        createButton.titleLabel?.text = "Create character"
        createButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        createButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        listButton.titleLabel?.text = "List all characters"
        listButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        listButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        duelButton.titleLabel?.text = "Let`s play!"
        duelButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        duelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.axis = NSLayoutConstraint.Axis.vertical
        container.distribution = .equalSpacing
        container.spacing = 16
        container.addArrangedSubview(createButton)
        container.addArrangedSubview(listButton)
        container.addArrangedSubview(duelButton)
        container.backgroundColor = UIColor.red
        self.view.addSubview(container)
    }
    
    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        let containerTopConstraint = NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let containerLeftConstraint = NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let containerRightConstraint = NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let containerBottomConstraint = NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([containerTopConstraint, containerLeftConstraint, containerRightConstraint, containerBottomConstraint])
    }
}
