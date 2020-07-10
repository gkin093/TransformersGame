//
//  ViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 08/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        viewModel.generateToken()
    }

    @IBAction func listar(_ sender: UIButton) {
        viewModel.listTransformers()
    }
    
    @IBAction func criar(_ sender: Any) {
        let transformer = Transformer(name: "Teste", strength: 2, intelligence: 4, speed: 4, endurance: 5, rank: 6, courage: 5, firepower: 6, skill: 6, team: "D")
        viewModel.create(transformer)
        
    }
    
    @IBAction func atualizar(_ sender: Any) {
        let transformer = Transformer(name: "Teste", strength: 2, intelligence: 4, speed: 4, endurance: 5, rank: 6, courage: 5, firepower: 6, skill: 6, team: "D")
        viewModel.update(transformer)
    }
    
    @IBAction func deletar(_ sender: Any) {
        viewModel.delete(id: "dfsadf")
    }
}

