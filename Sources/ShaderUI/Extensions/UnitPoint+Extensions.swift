//
//  UnitPoint+Extensions.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import SwiftUI

extension UnitPoint {
  static func -(lhs: UnitPoint, rhs: UnitPoint) -> UnitPoint {
    UnitPoint(
      x: lhs.x - rhs.x,
      y: lhs.y - rhs.y
    )
  }
}
