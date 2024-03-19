//
//  AnimatedShimmer+GradientEffect.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import SwiftUI

extension AnimatableBodyView {
  static func linearGradient(
    animation: Animation,
    parameters: LinearGradientEffect.Parameters,
    @ViewBuilder content: @escaping () -> some View
  ) -> AnimatableBodyView {
    AnimatableBodyView(animation: animation) {
      animationProgress in
      LinearGradientEffect(
        parameters: parameters,
        stop: animationProgress,
        content: content
      )
    }
  }
  
  static func solidLinearGradient(
    animation: Animation,
    parameters: SolidLinearGradientEffect.Parameters,
    @ViewBuilder content: @escaping () -> some View
  ) -> AnimatableBodyView {
    AnimatableBodyView(animation: animation) {
      animationProgress in
      SolidLinearGradientEffect(
        parameters: parameters,
        stop: animationProgress,
        content: content
      )
      
    }
  }
  
  static func radialGradient(
    animation: Animation,
    parameters: RadialGradientEffect.Parameters,
    @ViewBuilder content: @escaping () -> some View
  ) -> AnimatableBodyView {
    AnimatableBodyView(animation: animation) {
      animationProgress in
      RadialGradientEffect(
        parameters: parameters,
        stop: animationProgress,
        content: content
      )
    }
  }
  
  static func solidRadialGradient(
    animation: Animation,
    parameters: SolidRadialGradientEffect.Parameters,
    @ViewBuilder content: @escaping () -> some View
  ) -> AnimatableBodyView {
    AnimatableBodyView(animation: animation) {
      animationProgress in
      SolidRadialGradientEffect(
        parameters: parameters,
        stop: animationProgress,
        content: content
      )
    }
  }
}
