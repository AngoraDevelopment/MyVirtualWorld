//
//  NavigationController.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

final class NavigationController {

    var targetPosition: SIMD3<Float>? = nil
    var stoppingDistance: Float = 0.2

    func update(player: Player, deltaTime: Float) {
        guard let target = targetPosition else { return }

        let toTarget = target - player.transform.position
        let distance = simd_length(toTarget)

        if distance < stoppingDistance {
            targetPosition = nil
            return
        }

        let direction = simd_normalize(toTarget)
        player.transform.position += direction * player.moveSpeed * deltaTime
    }
}
