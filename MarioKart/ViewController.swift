//
//  ViewController.swift
//  Mario Cart
//
//  Created by Charles Hieger on 1/25/19.
//  Copyright © 2019 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UIGestureRecognizerDelegate,
                      SettingsViewControllerDelegate {
  // Bowser
  @IBOutlet weak var kartView0: UIImageView!
  // Mario
  @IBOutlet weak var kartView1: UIImageView!
  // Toad
  @IBOutlet weak var kartView2: UIImageView!
  // Mushroom
  @IBOutlet weak var mushroomView: UIImageView!
  // Mystery Box
  @IBOutlet weak var mysteryBox: UIImageView!
  
  // Keeps track of the original position of the karts when the view is initially loaded
  var originalKartCenters = [CGPoint]()
  // Acts as a multiplier to determine how fast to translate the kart
  private var speedMultiplier = 1.0
  // Settings applied from the settings screen
  var settings: [String: Any]?
  
  // Called when the view controller has awakened and is finished
  // setting up it's views
  override func viewDidLoad() {
    super.viewDidLoad()
    
    originalKartCenters = [kartView0.center,
                           kartView1.center,
                           kartView2.center]
  }
  
  //  Called when user double-taps a kart
  @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
    translate(kart: sender.view, by: view.frame.width)
  }
  
  // Called when the user pans on a kart
  @IBAction func didPanKart(_ sender: UIPanGestureRecognizer) {
    moveKart(using: sender)
  }
  
  // Called when the user long-presses on the background
  @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      resetKarts()
    }
  }
  
  
  // Called when user taps on the mushroom
  @IBAction func didTapMushroom(_ sender: UITapGestureRecognizer) {
      animateMushroom()
      guard let powerup = MushroomGenerator.maybeGenerateMushroomPowerup() else {
          // code inside this curly brace will run if the unwrapped value is nil
          print("Didn't get powerup")
          return
      }
      // code below here will run and `powerup` now contains a non-nil value
      // unlike if-let, `powerup` is accessible below the guard statement and outside of its curly brace
      useMushroomPowerupOnMario(powerup: powerup)

  }
  
  private func useMushroomPowerupOnMario(powerup: MushroomPowerup) {
    scale(kart: kartView1)
  }
  
  // This function is called when the user taps on the mystery box
  @IBAction func didTapMysteryBox(_ sender: UITapGestureRecognizer) {
    animateMysteryBox()
    let mysteryBox = MysteryBoxGenerator.generateMysteryBox()
    decipher(mysteryBox: mysteryBox)
      print(mysteryBox.mysteryEffect) // { effect = translate; }

  }
  
  private func decipher(mysteryBox: MysteryBox) {
      // Attempt to cast "mysteryEffect" to a Dictionary with a key of type String and value of type String
      // Assign the result to the variable "effectDictionary"
      guard let effectDictionary = mysteryBox.mysteryEffect as? [String: String] else {
        // If the cast fails, then throw an error and early return
        assertionFailure("Expecting value of type dictionary")
        return
      }
      // Make sure the effectDictionary["effect"] has a non-nil value
      // and assign the result to the "effect" variable
      guard let effect = effectDictionary["effect"] else {
        // If the value is nil, throw an error and early return
        assertionFailure("Expecting value of type String")
        return
      }
      // Apply the correct effect to Mario
      if effect == "translate" {
        translate(kart: kartView1, by: view.bounds.width)
      } else if effect == "rotate" {
        rotate(kart: kartView1)
      } else if effect == "scale" {
        scale(kart: kartView1)
      } else {
        assertionFailure("Unexpected effect")
      }

    
  }
  
  private func translate(kart: UIView?,
                         by xPosition: Double) {
    guard let kart = kart else { return }
    UIView.animateKeyframes(withDuration: 0.5 - 0.05 * Double(speedMultiplier),
                            delay: 0.0) {
      kart.center.x = kart.center.x + xPosition
    }
  }
  
  private func rotate(kart: UIView) {
    UIView.animate(withDuration: 0.25) {
      self.kartView1.transform = self.kartView1.transform.rotated(by: 180.0)
    }
  }
  
  private func scale(kart: UIView) {
    UIView.animate(withDuration: 0.25) {
      self.kartView1.transform = self.kartView1.transform.scaledBy(x: 1.05, y: 1.05)
    }
  }
  
  // Called with the user taps on the settings button
  @IBAction func didTapSettingsButton(_ sender: UIButton) {
    performSegue(withIdentifier: "SettingsViewControllerSegue", sender: nil)
  }
  
  // Prepare the settings screen before showing it to the user
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SettingsViewControllerSegue" {
      let navigationController = segue.destination as! UINavigationController
      let viewController = navigationController.topViewController as! SettingsViewController
      viewController.delegate = self
      viewController.preloadedSettings = settings
    }
  }
  
  // Applies the correct settings after exiting the settings screen
  // This function is called before dismissing the settings screen
  func didChangeSettings(settings: [String : Any]) {
    self.settings = settings
    print(settings)
    applyNumKartsSetting(settings)
    applyKartSizeSetting(settings)
    applySpeedMultiplierSetting(settings)
  }
  
  func applyNumKartsSetting(_ settings: [String : Any]) {
      // Optionally cast the value of `settings["numKarts"]` to an Int and assign it to `numKarts`
      guard let numKarts = settings["numKarts"] as? Int else {
        // If the cast fails, then throw an assertion and early terminate
        assertionFailure("Expecting Int, but got nil")
        return
      }
      // unhide the correct number of karts
      kartView0.isHidden = numKarts < 2
      kartView2.isHidden = numKarts < 3
  }
  
  func applyKartSizeSetting(_ settings: [String : Any]) {
        let kartSizeMultiplier = settings["kartSize"] as! Int // as! does forced casting
        let kartSize = 1.0 + 0.05 * Double(kartSizeMultiplier)
        let transform = CGAffineTransformIdentity.scaledBy(x: kartSize, y: kartSize)
        kartView0.transform = transform
        kartView1.transform = transform
        kartView2.transform = transform

  }
  
  func applySpeedMultiplierSetting(_ settings: [String : Any]) {
      guard let speedMultiplier = settings["speedMultiplier"] as? Int else {
         assertionFailure("Expecting Int, but got nil")
         return
       }
       self.speedMultiplier = Double(speedMultiplier)
    
  }
}

