//
//  TrapezoidShape.swift
//  SuperScoreboard
//
//  Created by Aleksandrs Trubacs on 03/09/2025.
//

import SwiftUI

struct TrapezoidShape: Shape {
    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the trapezoid with wider top than bottom
        let topInset: CGFloat = 0      // No inset on top (full width)
        let bottomInset: CGFloat = 8  // Inset on bottom (narrower)
        let radius = min(cornerRadius, rect.height / 4) // Ensure radius doesn't exceed shape bounds

        // Define corner points (centers of the corner arcs)
        let topLeft = CGPoint(x: rect.minX + topInset + radius, y: rect.minY + radius)
        let topRight = CGPoint(x: rect.maxX - topInset - radius, y: rect.minY + radius)
        let bottomRight = CGPoint(x: rect.maxX - bottomInset - radius, y: rect.maxY - radius)
        let bottomLeft = CGPoint(x: rect.minX + bottomInset + radius, y: rect.maxY - radius)

        // Start from top edge (after top-left corner)
        path.move(to: CGPoint(x: topLeft.x, y: rect.minY))

        // Top edge to top-right arc start
        path.addLine(to: CGPoint(x: topRight.x, y: rect.minY))

        // Top-right corner arc
        path.addArc(
            center: topRight,
            radius: radius,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )

        // Right angled edge to bottom-right arc start
        path.addLine(to: CGPoint(x: bottomRight.x + radius, y: bottomRight.y))

        // Bottom-right corner arc
        path.addArc(
            center: bottomRight,
            radius: radius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )

        // Bottom edge to bottom-left arc start
        path.addLine(to: CGPoint(x: bottomLeft.x, y: rect.maxY))

        // Bottom-left corner arc
        path.addArc(
            center: bottomLeft,
            radius: radius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )

        // Left angled edge to top-left arc start
        path.addLine(to: CGPoint(x: topLeft.x - radius, y: topLeft.y))

        // Top-left corner arc
        path.addArc(
            center: topLeft,
            radius: radius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )

        return path
    }
}

#Preview {
    FollowBanner(isFavoritesEmpty: true) {
        print("Follow button tapped!")
    }
    .padding()
}
