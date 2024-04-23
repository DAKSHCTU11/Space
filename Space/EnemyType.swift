//
//  EnemyType.swift
//  Space
//
//  Created by Daksh Chaudhary on 19/04/24.
//

import SpriteKit

struct EnemyType: Codable{
    let name: String
    let shields: Int
    let speed: CGFloat
    let powerUpChance: Int
}
