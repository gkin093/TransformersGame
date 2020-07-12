//
//  ViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 08/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    private var transformers: [Transformer] = []
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var duelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        configureTableView()
        setupObservables()
        viewModel.generateToken()
        duelButton.layer.borderWidth = 2
        duelButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 2
        createButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @IBAction func create(_ sender: UIButton) {
        self.route(nil)
    }
    
    @IBAction func duelAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let duelViewController = storyboard.instantiateViewController(withIdentifier: "DuelViewController") as! DuelViewController
        duelViewController.viewModel.transformersList = self.viewModel.list
        self.present(duelViewController, animated: true, completion: nil)
    }
    func setupObservables() {
        viewModel.hasToken.subscribe { hasToken in
            if hasToken.element ?? false {
                self.viewModel.listTransformers()
            } else {
                //dar algum alerta de erro
            }
        }.disposed(by: disposeBag)
        
        viewModel.transformersList.asObservable().bind(to: tableView.rx.items(cellIdentifier: TransformerTableViewCell.identifier, cellType: TransformerTableViewCell.self)) { row, transformer, cell in
            cell.backgroundColor = UIColor.clear
            cell.transformer = transformer
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let cell = self?.tableView.cellForRow(at: indexPath) as? TransformerTableViewCell,
                    let transformer = cell.transformer {
                    self?.route(transformer)
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func route(_ transformer: Transformer?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formViewController = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        formViewController.viewModel.transformer = transformer
        self.present(formViewController, animated: true, completion: nil)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "TransformerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TransformerTableViewCell.identifier)
    }
    
    private func configureTableView() {
        registerCell()
        tableView.rowHeight = 96
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.rx.itemDeleted.subscribe(onNext: { self.viewModel.delete(at: $0) }).disposed(by: disposeBag)
    }
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        viewModel.listTransformers()
        refreshControl.endRefreshing()
    }
}
