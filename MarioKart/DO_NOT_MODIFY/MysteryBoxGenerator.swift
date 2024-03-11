//
//  MysteryBoxGenerator.swift
//  MarioKart
//
//  Created by Mari Batilando on 3/10/23.
//  Copyright © 2023 Charles Hieger. All rights reserved.
//

import Foundation

/*
 * DO NOT MODIFY ANYTHING IN THIS FILE
 */
struct MysteryBox {
  let mysteryEffect: AnyObject
  init() {
    let possibleEffects = ["translate", "rotate", "scale"]
    mysteryEffect = ["effect": possibleEffects.randomElement()!] as AnyObject
  }
}

struct MysteryBoxGenerator {
  static func generateMysteryBox() -> MysteryBox {
    return MysteryBox()
  }
}
