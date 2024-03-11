//
//  MushroomGenerator.swift
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
struct MushroomPowerup {}

struct MushroomGenerator {
  static func maybeGenerateMushroomPowerup() -> MushroomPowerup? {
    // Generate a random integer from 0 to 1 and see if it's an even number
    let randomInteger = Int.random(in: 0...1)
    if randomInteger % 2 == 0 {
      return MushroomPowerup()
    }
    return nil
  }
}
