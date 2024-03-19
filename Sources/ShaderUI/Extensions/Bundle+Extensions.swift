//
//  Bundle+Extension.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import Foundation

private class __PrivateClass__ { }

extension Bundle {
  static var current: Bundle {
    Bundle(for: __PrivateClass__.self)
  }
}
