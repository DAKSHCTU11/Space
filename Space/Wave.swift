//
//  Wave.swift
//  Space
//
//  Created by Daksh Chaudhary on 19/04/24.
//

import SpriteKit

struct Wave: Codable{
    struct WaveEnemy: Codable{
        let position: Int
        let xoffset: CGFloat
        let moveStraight: Bool
    }
    let name: String
    let enemies:[WaveEnemy]
}
