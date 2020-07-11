//
//  DuelViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 10/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit

class DuelViewController: UIViewController {
    let viewModel = DuelViewModel()
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var survivorsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        survivorsLabel.text = ""
        let result = viewModel.fight()
        setupUI(with: result)
    }
    
    func setupUI(with result: FightResult) {
        switch result {
        case .allDestroyed:
            resultLabel.text = "All transformers are destroyed!!!"
            survivorsLabel.text = "An epic battle with Optimus Prime and Predaking"
        case .autobots:
            resultLabel.text = "Autobots won this battle"
            if viewModel.decepticonsSurvivors.count > 0 {
                survivorsLabel.text = "But, there are some decepticons survivors: \(viewModel.decepticonsSurvivors.count)"
            }
        case .decepticons:
            resultLabel.text = "Decepticons won this battle"
            if viewModel.autobotsSurvivors.count > 0 {
                survivorsLabel.text = "But, there are some autobots survivors: \(viewModel.autobotsSurvivors.count)"
            }
        case .autobotsWithSpecials:
            resultLabel.text = "Autobots won this battle"
            survivorsLabel.text = "It was an easy battle for Autobots"
        case .decepticonsWithSpecials:
            resultLabel.text = "Decepticons won this battle"
            survivorsLabel.text = "It was an easy battle for Decepticons"
        case .draw:
            resultLabel.text = "No one won this battle"
            survivorsLabel.text = "There is no survivors from this battle"
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
