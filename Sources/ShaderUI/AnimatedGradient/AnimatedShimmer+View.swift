//
//  AnimatedShimmer+View.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import SwiftUI

public extension View {
  @ViewBuilder
  func animatedLinearGradient(
    animation: Animation = .default.repeatForever(),
    parameters: LinearGradientEffect.Parameters,
    isActive: Bool = true
  ) -> some View {
    if isActive {
      AnimatableBodyView.linearGradient(
        animation: animation,
        parameters: parameters,
        content: { self }
      )
    } else { self }
  }
  
  @ViewBuilder
  func animatedSolidLinearGradient(
    animation: Animation = .default.repeatForever(),
    parameters: SolidLinearGradientEffect.Parameters,
    isActive: Bool = true
  ) -> some View {
    if isActive {
      AnimatableBodyView.solidLinearGradient(
        animation: animation,
        parameters: parameters,
        content: { self }
      )
    } else { self }
  }
  
  @ViewBuilder
  func animatedRadialGradient(
    animation: Animation = .default.repeatForever(),
    parameters: RadialGradientEffect.Parameters,
    isActive: Bool = true
  ) -> some View {
    if isActive {
      AnimatableBodyView.radialGradient(
        animation: animation,
        parameters: parameters,
        content: { self }
      )
    } else { self }
  }
  
  @ViewBuilder
  func animatedSolidRadialGradient(
    animation: Animation = .default.repeatForever(),
    parameters: SolidRadialGradientEffect.Parameters,
    isActive: Bool = true
  ) -> some View {
    if isActive {
      AnimatableBodyView.solidRadialGradient(
        animation: animation,
        parameters: parameters,
        content: { self }
      )
    } else { self }
  }
}
