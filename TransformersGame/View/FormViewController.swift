//
//  FormViewController.swift
//  TransformersGame
//
//  Created by Gustavo Kin on 10/07/20.
//  Copyright © 2020 Gustavo Kin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var strengthValueLabel: UILabel!
    @IBOutlet weak var strengthStepper: UIStepper!
    @IBOutlet weak var intelligenceValueLabel: UILabel!
    @IBOutlet weak var intelligenceStepper: UIStepper!
    @IBOutlet weak var speedValueLabel: UILabel!
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var enduranceValueLabel: UILabel!
    @IBOutlet weak var enduranceStepper: UIStepper!
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var rankStepper: UIStepper!
    @IBOutlet weak var courageValueLabel: UILabel!
    @IBOutlet weak var courageStepper: UIStepper!
    @IBOutlet weak var firepowerValueLabel: UILabel!
    @IBOutlet weak var firepowerStepper: UIStepper!
    @IBOutlet weak var skillValueLabel: UILabel!
    @IBOutlet weak var skillStepper: UIStepper!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerTeam: UIPickerView!
    
    let viewModel = FormViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.teams.bind(to: pickerTeam.rx.itemTitles) { row, element in
            return element.rawValue
        }.disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.transformer == nil {
            saveButton.titleLabel?.text = "CREATE"
        } else {
            saveButton.titleLabel?.text = "UPDATE"
        }
    }
    
    func setupUI() {
        if let transformer = viewModel.transformer {
            nameTextField.text = transformer.name
            strengthValueLabel.text = String(transformer.strength)
            strengthStepper.value = Double(transformer.strength)
            intelligenceValueLabel.text = String(transformer.intelligence)
            intelligenceStepper.value = Double(transformer.intelligence)
            speedValueLabel.text = String(transformer.speed)
            speedStepper.value = Double(transformer.speed)
            enduranceValueLabel.text = String(transformer.endurance)
            enduranceStepper.value = Double(transformer.endurance)
            rankValueLabel.text = String(transformer.rank)
            rankStepper.value = Double(transformer.rank)
            courageValueLabel.text = String(transformer.courage)
            courageStepper.value = Double(transformer.courage)
            firepowerValueLabel.text = String(transformer.firepower)
            firepowerStepper.value = Double(transformer.firepower)
            skillValueLabel.text = String(transformer.skill)
            skillStepper.value = Double(transformer.skill)
            pickerTeam.selectRow(transformer.team == "A" ? 0 : 1, inComponent: 0, animated: true)
        }
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 2
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender == strengthStepper {
            strengthValueLabel.text = sender.value.clean
        } else if sender == intelligenceStepper {
            intelligenceValueLabel.text = sender.value.clean
        } else if sender == enduranceStepper {
            enduranceValueLabel.text = sender.value.clean
        } else if sender == speedStepper {
            speedValueLabel.text = sender.value.clean
        } else if sender == rankStepper {
            rankValueLabel.text = sender.value.clean
        } else if sender == courageStepper {
            courageValueLabel.text = sender.value.clean
        } else if sender == firepowerStepper {
            firepowerValueLabel.text = sender.value.clean
        } else if sender == skillStepper {
            skillValueLabel.text = sender.value.clean
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if viewModel.transformer == nil {
            createChar()
        } else {
            updateChar()
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateChar() {
        if viewModel.transformer != nil {
            viewModel.transformer?.name = nameTextField.text ?? ""
            viewModel.transformer?.strength = Int(strengthStepper.value)
            viewModel.transformer?.intelligence = Int(intelligenceStepper.value)
            viewModel.transformer?.speed = Int(speedStepper.value)
            viewModel.transformer?.endurance = Int(enduranceStepper.value)
            viewModel.transformer?.rank = Int(rankStepper.value)
            viewModel.transformer?.courage = Int(courageStepper.value)
            viewModel.transformer?.firepower = Int(firepowerStepper.value)
            viewModel.transformer?.skill = Int(skillStepper.value)
            viewModel.transformer?.team = self.viewModel.getSelectedTeam(pickerTeam.selectedRow(inComponent: 0))
            self.viewModel.updateChar()
        }
    }
    
    func createChar() {
        let char = Transformer(name: nameTextField.text ?? "", strength: Int(strengthStepper.value), intelligence: Int(intelligenceStepper.value), speed: Int(speedStepper.value), endurance: Int(enduranceStepper.value), rank: Int(rankStepper.value), courage: Int(courageStepper.value), firepower: Int(firepowerStepper.value), skill: Int(skillStepper.value), team: self.viewModel.getSelectedTeam(pickerTeam.selectedRow(inComponent: 0)))
        
        viewModel.createChar(transformer: char)
    }
    
}

enum Team: String {
    case decepticons = "Decepticons"
    case autobots = "Autobots"
    
    func valueOfTeam() -> String {
        switch self {
        case .decepticons:
            return "D"
        case .autobots:
            return "A"
        }
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
