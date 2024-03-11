//
//  ViewController+Extensions.swift
//  MarioKart
//
//  Created by Mari Batilando on 3/10/23.
//  Copyright © 2023 Charles Hieger. All rights reserved.
//

import Foundation
import UIKit

/*
 * DO NOT MODIFY ANYTHING IN THIS FILE
 */
extension ViewController {
  func resetKarts() {
    UIView.animate(withDuration: 0.4) {
      let kartSizeMultiplier = self.settings?["kartSize"] as? Int
      let kartSize = 1.0 + 0.05 * Double(kartSizeMultiplier ?? 0)
      let transform = CGAffineTransformIdentity.scaledBy(x: kartSize, y: kartSize)
      self.kartView0.transform = transform
      self.kartView1.transform = transform
      self.kartView2.transform = transform
      
      self.kartView0.center = self.originalKartCenters[0]
      self.kartView1.center = self.originalKartCenters[1]
      self.kartView2.center = self.originalKartCenters[2]
    }
  }
  
  func moveKart(using gestureRecognizer: UIPanGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)
    let kartView = gestureRecognizer.view
    kartView?.center = location
  }
  
  func doPopAnimation(on view: UIView) {
    UIView.animate(withDuration: 0.25,
                   delay: 0.0,
                   options: [.autoreverse],
                   animations: {
      view.transform = view.transform.scaledBy(x: 1.05, y: 1.05)
    },
                   completion: { finished in
      view.transform = .identity
    })
  }
  
  func animateMushroom() {
    doPopAnimation(on: mushroomView)
  }
  
  func animateMysteryBox() {
    doPopAnimation(on: mysteryBox)
  }
}
