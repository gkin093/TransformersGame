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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var duelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        viewModel.delegate = self
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
            if hasToken.element ?? .notCalled == .notCalled || hasToken.element ?? .notCalled == .success {
                self.loadingIndicator.startAnimating()
                self.viewModel.listTransformers()
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Ops, something went wrong!", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { (action) in
                        self.dismiss(animated: true) {
                            self.viewModel.generateToken()
                        }
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Later", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.transformersList.asObservable().bind(to: tableView.rx.items(cellIdentifier: TransformerTableViewCell.identifier, cellType: TransformerTableViewCell.self)) { row, transformer, cell in
            self.loadingIndicator.stopAnimating()
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
        formViewController.delegate = self
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
        tableView.rx.itemDeleted.subscribe(onNext: { self.deleteItem(at: $0) }).disposed(by: disposeBag)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        // create the alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to destroy this transformer?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action) in
            self.viewModel.delete(at: indexPath)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        viewModel.listTransformers()
        refreshControl.endRefreshing()
    }
}

extension MainViewController: FormViewControllerDelegate {
    func reloadData() {
        self.viewModel.listTransformers()
    }
}

extension MainViewController: MainViewModelDelegate {
    func onErrorList() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Ops, something went wrong!", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { (action) in
                self.dismiss(animated: true) {
                    self.viewModel.listTransformers()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Later", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
