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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var countDownView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var result: FightResult = .draw
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        survivorsLabel.text = ""
        result = viewModel.fight()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }
    
    func setupAnimation() {
        UILabel.animate(withDuration: 1, animations: { () -> Void in
            self.countDownLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (finished: Bool) -> Void in
            UILabel.animate(withDuration: 1, animations: { () -> Void in
                self.countDownLabel.transform = CGAffineTransform.identity//CGAffineTransformIdentity
                self.countDownLabel.text = "2"
                UILabel.animate(withDuration: 1, animations: { () -> Void in
                    self.countDownLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }) { (finished: Bool) -> Void in
                    self.countDownLabel.transform = CGAffineTransform.identity//CGAffineTransformIdentity
                    self.countDownLabel.text = "1"
                    UILabel.animate(withDuration: 1, animations: { () -> Void in
                        self.countDownLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }) { (finished: Bool) -> Void in
                        self.countDownLabel.transform = CGAffineTransform.identity
                        self.setupUI(with: self.result)
                    }
                }
            })
        }
    }
    
    func setupUI(with result: FightResult) {
        countDownLabel.isHidden = true
        closeButton.isHidden = false
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.borderWidth = 2
        titleLabel.text = "RESULT"
        resultLabel.isHidden = false
        survivorsLabel.isHidden = false
        switch result {
        case .allDestroyed:
            backgroundImage.image = UIImage(named: "duel_all_destroyed_image")
            resultLabel.text = "ALL TRASNFORMERS ARE DESTROYED!!!"
            survivorsLabel.text = "AN EPIC BATTLE BETWEEN OPTIMUS PRIME AND PREDAKING"
        case .autobots:
            backgroundImage.image = UIImage(named: "duel_autobot_wins")
            resultLabel.text = "AUTOBOTS WON THIS BATTLE"
            if viewModel.decepticonsSurvivors.count > 0 {
                survivorsLabel.text = "BUT, THERE ARE SOME DECEPTICONS SURVIVORS:  \(viewModel.decepticonsSurvivors.count)"
            }
        case .decepticons:
            backgroundImage.image = UIImage(named: "duel_decepticon_wins_image")
            resultLabel.text = "DECEPTICONS WON THIS BATTLE"
            if viewModel.autobotsSurvivors.count > 0 {
                survivorsLabel.text = "BUT, THERE ARE SOME AUTOBOTS SURVIVORS:  \(viewModel.autobotsSurvivors.count)"
            }
        case .autobotsWithSpecials:
            backgroundImage.image = UIImage(named: "duel_autobot_wins")
            resultLabel.text = "AUTOBOTS WON THIS BATTLE"
            survivorsLabel.text = "IT WAS AN EASY BATTLE FOR AUTOBOTS"
        case .decepticonsWithSpecials:
            backgroundImage.image = UIImage(named: "duel_decepticon_wins_image")
            resultLabel.text = "DECEPTICONS WON THIS BATTLE"
            survivorsLabel.text = "IT WAS AN EASY BATTLE FOR DECEPTICONS"
        case .draw:
            backgroundImage.image = UIImage(named: "duel_all_destroyed_image")
            resultLabel.text = "NO ONE WON THIS BATTLE"
            survivorsLabel.text = "THERE IS NO SURVIVORS FROM THIS BATTLE"
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
