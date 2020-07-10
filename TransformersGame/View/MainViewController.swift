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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        setupObservables()
        viewModel.generateToken()
    }
    
    @IBAction func create(_ sender: UIButton) {
        let transformer = Transformer(name: "Teste", strength: 2, intelligence: 4, speed: 4, endurance: 5, rank: 6, courage: 5, firepower: 6, skill: 6, team: "D")
        viewModel.create(transformer)
    }
    
    func setupObservables() {
        viewModel.hasToken.subscribe { hasToken in
            if hasToken.element ?? false {
                //chamar listar
                self.viewModel.listTransformers()
            } else {
                //dar algum alerta de erro
            }
        }.disposed(by: disposeBag)
        
        viewModel.transformersList.asObservable().bind(to: tableView.rx.items(cellIdentifier: TransformerTableViewCell.identifier, cellType: TransformerTableViewCell.self)) { row, transformer, cell in
            cell.transformer = transformer
        }.disposed(by: disposeBag)
        
        
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
    //
    //    @IBAction func atualizar(_ sender: Any) {
    //        let transformer = Transformer(name: "Teste", strength: 2, intelligence: 4, speed: 4, endurance: 5, rank: 6, courage: 5, firepower: 6, skill: 6, team: "D")
    //        viewModel.update(transformer)
    //    }
    //
    //    @IBAction func deletar(_ sender: Any) {
    //        viewModel.delete(id: "dfsadf")
    //    }
}
