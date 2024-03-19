//
//  AnimatedShimmer.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import SwiftUI

struct AnimatableBodyView: View {
  typealias AnimatableBody = (Double) -> AnyView
  
  let animation: Animation
  let animatableBody: AnimatableBody
  
  @State private var animationProgress: Double = 0.0
  
  init(
    animation: Animation,
    @ViewBuilder animatableBody: @escaping (Double) -> some View
  ) {
    self.animation = animation
    self.animatableBody = { AnyView(animatableBody($0)) }
  }
  
  var body: some View {
    self.animatableBody(self.animationProgress)
      .onChange(of: self.animation, initial: true) {
        _, newAnimation in
        DispatchQueue.main.asyncAfter(deadline: .now()) {
          self.animationProgress = 0.0
          withAnimation(newAnimation) {
            self.animationProgress = 1.0
          }
        }
      }
  }
}
