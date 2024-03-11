//
//  SettingsViewController.swift
//  MarioKart
//
//  Created by Mari Batilando on 3/12/23.
//  Copyright © 2023 Charles Hieger. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: NSObject {
  func didChangeSettings(settings: [String: Any])
}

class SettingsViewController: UIViewController {
  
  weak var delegate: SettingsViewControllerDelegate?
  
  @IBOutlet weak var numKartsLabel: UILabel!
  @IBOutlet weak var kartSizeLabel: UILabel!
  @IBOutlet weak var speedMultiplierLabel: UILabel!
  
  @IBOutlet weak var numberOfKartsStepper: UIStepper!
  @IBOutlet weak var kartSizeStepper: UIStepper!
  @IBOutlet weak var speedMultiplierStepper: UIStepper!
  
  var preloadedSettings: [String: Any]?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(didTapBackButton))
    if let preloadedSettings = self.preloadedSettings {
      preload(with: preloadedSettings)
    }
  }
  
  func preload(with settings: [String: Any]) {
    let numKarts = settings["numKarts"] as! Int
    numberOfKartsStepper.value = Double(numKarts)
    numKartsLabel.text = String(numKarts)
    
    let kartSize = settings["kartSize"] as! Int
    kartSizeStepper.value = Double(kartSize)
    kartSizeLabel.text = String(kartSize)
    
    let speedMultiplier = settings["speedMultiplier"] as! Int
    speedMultiplierStepper.value = Double(speedMultiplier)
    speedMultiplierLabel.text = String(speedMultiplier)
  }
  
  @objc private func didTapBackButton() {
    var settings = [String: Int]()
    settings["numKarts"] = Int(numberOfKartsStepper.value)
    settings["kartSize"] = Int(kartSizeStepper.value)
    settings["speedMultiplier"] = Int(speedMultiplierStepper.value)
    delegate?.didChangeSettings(settings: settings)
    dismiss(animated: true)
  }
  
  @IBAction func numKartsValueChanged(_ sender: UIStepper) {
    let minKarts = 1, maxKarts = 3
    let numKarts = max(minKarts, min(maxKarts, Int(sender.value)))
    sender.value = Double(numKarts)
    numKartsLabel.text = String(numKarts)
  }
  
  @IBAction func kartSizeValueChanged(_ sender: UIStepper) {
    let minSize = 1, maxSize = 5
    let kartSize = max(minSize, min(maxSize, Int(sender.value)))
    sender.value = Double(kartSize)
    kartSizeLabel.text = String(kartSize)
  }
  
  @IBAction func speedMultiplierValueChanged(_ sender: UIStepper) {
    let minSpeed = 1, maxSpeed = 5
    let speedMultiplier = max(minSpeed, min(maxSpeed, Int(sender.value)))
    sender.value = Double(speedMultiplier)
    speedMultiplierLabel.text = String(speedMultiplier)
  }
}
