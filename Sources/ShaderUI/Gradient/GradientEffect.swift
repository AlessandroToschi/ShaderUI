//
//  GradientEffect.swift
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

import SwiftUI

public protocol GradientEffectParameters {
  static var `default`: Self { get }
}

public protocol GradientEffect: View, Animatable {
  associatedtype Parameters: GradientEffectParameters
  
  var parameters: Parameters { get set }
  var stop: Double { get set }
  var content: AnyView { get set }
  
  var shaderFunction: ShaderFunction { get }
}

public extension GradientEffect {
  var animatableData: Double {
    get { self.stop }
    set { self.stop = newValue }
  }
}

public struct LinearGradientEffect: GradientEffect {
  public struct Parameters: GradientEffectParameters {
    public var start: UnitPoint
    public var end: UnitPoint
    public var color: Color
    public var delta: Double
    public var smoothness: Double
    
    public static var `default`: Self {
      Parameters(
        start: .leading,
        end: .trailing,
        color: .white,
        delta: 0.2,
        smoothness: 0.8
      )
    }
    
    public init(
      start: UnitPoint,
      end: UnitPoint,
      color: Color,
      delta: Double,
      smoothness: Double
    ) {
      (self.start, self.end) = extend(start: start, end: end)
      self.color = color
      self.delta = delta
      self.smoothness = smoothness
    }
  }
  public var parameters: Parameters
  public var stop: Double
  public var content: AnyView
  
  public var shaderFunction: ShaderFunction {
    ShaderFunction(
      library: .bundle(.current),
      name: "shimmerui::linear_gradient"
    )
  }
  
  public init(
    parameters: Parameters,
    stop: Double,
    @ViewBuilder content: () -> some View
  ) {
    self.parameters = parameters
    self.stop = stop
    self.content = AnyView(content())
  }
  
  public var body: some View {
    self.content
      .colorEffect(
        Shader(
          function: self.shaderFunction,
          arguments: [
            .boundingRect,
            .float2(self.parameters.start.x, self.parameters.start.y),
            .float2(self.parameters.end.x, self.parameters.end.y),
            .color(self.parameters.color),
            .float(self.parameters.delta),
            .float(self.parameters.smoothness),
            .float(self.stop)
          ]
        )
      )
  }
}

public struct SolidLinearGradientEffect: GradientEffect {
  public struct Parameters: GradientEffectParameters {
    public var start: UnitPoint
    public var end: UnitPoint
    public var startColor: Color
    public var stopColor: Color
    public var endColor: Color
    public var smoothness: Double
    
    public static var `default`: Self {
      Parameters(
        start: .leading,
        end: .trailing,
        startColor: .gray,
        stopColor: .white,
        endColor: .gray,
        smoothness: 0.8
      )
    }
    
    public init(
      start: UnitPoint,
      end: UnitPoint,
      startColor: Color,
      stopColor: Color,
      endColor: Color,
      smoothness: Double
    ) {
      (self.start, self.end) = extend(start: start, end: end)
      self.startColor = startColor
      self.stopColor = stopColor
      self.endColor = endColor
      self.smoothness = smoothness
    }
  }
  
  public var parameters: Parameters
  public var stop: Double
  public var content: AnyView
  
  public var shaderFunction: ShaderFunction {
    ShaderFunction(
      library: .bundle(.current),
      name: "shimmerui::solid_linear_gradient"
    )
  }
  
  public init(
    parameters: Parameters,
    stop: Double,
    @ViewBuilder content: () -> some View
  ) {
    self.parameters = parameters
    self.stop = stop
    self.content = AnyView(content())
  }
  
  public var body: some View {
    self.content
      .colorEffect(
        Shader(
          function: self.shaderFunction,
          arguments: [
            .boundingRect,
            .float2(self.parameters.start.x, self.parameters.start.y),
            .float2(self.parameters.end.x, self.parameters.end.y),
            .color(self.parameters.startColor),
            .color(self.parameters.stopColor),
            .color(self.parameters.endColor),
            .float(self.parameters.smoothness),
            .float(self.stop)
          ]
        )
      )
  }
}

public struct RadialGradientEffect: GradientEffect {
  public struct Parameters: GradientEffectParameters {
    public var anchorPoint: UnitPoint
    public var color: Color
    public var delta: Double
    public var smoothness: Double
    
    public static var `default`: Self {
      Parameters(
        anchorPoint: .center,
        color: .white,
        delta: 0.05,
        smoothness: 0.8
      )
    }
  }
  
  public var parameters: Parameters
  public var stop: Double
  public var content: AnyView
  
  public var shaderFunction: ShaderFunction {
    ShaderFunction(
      library: .bundle(.current),
      name: "shimmerui::radial_gradient"
    )
  }
  
  public init(
    parameters: Parameters,
    stop: Double,
    @ViewBuilder content: () -> some View
  ) {
    self.parameters = parameters
    self.stop = stop
    self.content = AnyView(content())
  }
  
  public var body: some View {
    self.content
      .colorEffect(
        Shader(
          function: self.shaderFunction,
          arguments: [
            .boundingRect,
            .float2(self.parameters.anchorPoint.x, self.parameters.anchorPoint.y),
            .color(self.parameters.color),
            .float(self.parameters.delta),
            .float(self.parameters.smoothness),
            .float(self.stop)
          ]
        )
      )
  }
}

public struct SolidRadialGradientEffect: GradientEffect {
  public struct Parameters: GradientEffectParameters {
    public var anchorPoint: UnitPoint
    public var startColor: Color
    public var stopColor: Color
    public var endColor: Color
    public var smoothness: Double
    
    public static var `default`: Self {
      Parameters(
        anchorPoint: .center,
        startColor: .gray,
        stopColor: .white,
        endColor: .gray,
        smoothness: 0.8
      )
    }
  }
  public var parameters: Parameters
  public var stop: Double
  public var content: AnyView
  
  public var shaderFunction: ShaderFunction {
    ShaderFunction(
      library: .bundle(.current),
      name: "shimmerui::solid_radial_gradient"
    )
  }
  
  public init(
    parameters: Parameters,
    stop: Double,
    @ViewBuilder content: () -> some View
  ) {
    self.parameters = parameters
    self.stop = stop
    self.content = AnyView(content())
  }
  
  public var body: some View {
    self.content
      .colorEffect(
        Shader(
          function: self.shaderFunction,
          arguments: [
            .boundingRect,
            .float2(self.parameters.anchorPoint.x, self.parameters.anchorPoint.y),
            .color(self.parameters.startColor),
            .color(self.parameters.stopColor),
            .color(self.parameters.endColor),
            .float(self.parameters.smoothness),
            .float(self.stop)
          ]
        )
      )
  }
}

fileprivate func extend(start: UnitPoint, end: UnitPoint) -> (UnitPoint, UnitPoint) {
  let direction = end - start
  let xSign = direction.x.sign
  let ySign = direction.y.sign
  let xZero = direction.x.isZero
  let yZero = direction.y.isZero
  
  if xZero && !yZero {
    return switch ySign {
      case .plus: (.bottom, .top)
      case .minus: (.top, .bottom)
    }
  } else if !xZero && yZero {
    return switch xSign {
      case .plus: (.leading, .trailing)
      case .minus: (.trailing, .leading)
    }
  } else {
    let (s, e): (UnitPoint, UnitPoint) = switch (xSign, ySign) {
    case (.plus, .plus): (.topLeading, .bottomTrailing)
    case (.plus, .minus): (.bottomLeading, .topTrailing)
    case (.minus, .plus): (.topTrailing, .bottomLeading)
    case (.minus, .minus): (.bottomTrailing, .topLeading)
    }
    
    let anchorPoint = UnitPoint(x: 0.5, y: 0.5)
    
    let m = direction.y / direction.x
    let q = anchorPoint.y - (m * anchorPoint.x)
    
    let mr = -1.0 / m
    
    let q1 = s.y - (mr * s.x)
    let q2 = e.y - (mr * e.x)
    
    let x1 = (q1 - q) / (m - mr)
    let x2 = (q2 - q) / (m - mr)
    
    let y1 = mr * x1 + q1
    let y2 = mr * x2 + q2
    
    return (
      UnitPoint(x: x1, y: y1),
      UnitPoint(x: x2, y: y2)
    )
  }
}
