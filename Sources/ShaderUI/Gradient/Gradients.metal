//
//  Gradients.metal
//  ShimmerUI
//
//  Created by Alessandro Toschi on 15/03/24.
//

#include <metal_stdlib>

using namespace metal;

namespace shimmerui {
  template <typename T>
  METAL_FUNC T remap(T old_value, T old_min, T old_max, T new_min, T new_max) {
    const T old_range = old_max - old_min;
    const T new_range = new_max - new_min;
    return (((old_value - old_min) * new_range) / old_range) + new_min;
  }
  
  [[ stitchable ]] half4 linear_gradient(float2 position,
                                         half4 sourceColor,
                                         float4 boundingRect,
                                         float2 start,
                                         float2 end,
                                         half4 color,
                                         float delta,
                                         float smoothness,
                                         float stop) {
    const half2 uv = half2(position / boundingRect.zw);
    const half2 direction = half2(end - start);
    const half2 p = uv - half2(start);
    
    const half x = dot(direction, p) / dot(direction, direction);
    const half stop_h = static_cast<half>(stop);
    const half delta_h = static_cast<half>(delta);
    const half smoothness_h = static_cast<half>(smoothness);
    
    half4 outputColor = sourceColor;
    
    if (abs(x - stop_h) > delta_h) {
      return sourceColor;
    }
    
    const half t = (x - (stop_h - delta_h)) / delta_h;
    const half smoothed_t = t * smoothness_h;
    
    outputColor = mix(outputColor, color, clamp(smoothed_t, 0.0h, smoothness_h));
    outputColor = mix(outputColor, sourceColor, saturate(t - 1.0h));
    outputColor *= sourceColor.a;
    return outputColor;
  }
  
  [[ stitchable ]] half4 solid_linear_gradient(float2 position,
                                               half4 sourceColor,
                                               float4 boundingRect,
                                               float2 start,
                                               float2 end,
                                               half4 startColor,
                                               half4 stopColor,
                                               half4 endColor,
                                               float smoothness,
                                               float stop) {
    const half2 uv = half2(position / boundingRect.zw);
    const half2 direction = half2(end - start);
    const half2 p = uv - half2(start);
    
    const half stop_h = static_cast<half>(stop);
    const half smoothness_h = static_cast<half>(smoothness);
    const half x = (dot(direction, p) / dot(direction, direction));
    const half y = (x - stop_h) / (1.0h - stop_h);
    
    half4 outputColor = mix(startColor, stopColor, clamp((x / stop_h) * smoothness_h, 0.0h, smoothness_h));
    outputColor = mix(outputColor, endColor, saturate(y));
    outputColor *= sourceColor.a;
    return outputColor;
  }
  
  [[ stitchable ]] half4 radial_gradient(float2 position,
                                         half4 sourceColor,
                                         float4 boundingRect,
                                         float2 anchorPoint,
                                         half4 stopColor,
                                         float delta,
                                         float smoothness,
                                         float stop) {
    const float aspectRatio = boundingRect.z / boundingRect.w;
    const float2 aspectRatioScaleFactor = float2(max(1.0f, aspectRatio), max(1.0f, 1.0f / aspectRatio));
    const float2 scaledAnchorPoint = anchorPoint * aspectRatioScaleFactor;
    
    const float l1 = distance(scaledAnchorPoint, float2(aspectRatioScaleFactor));
    const float l2 = length(scaledAnchorPoint); // distance(scaledAnchorPoint, float2(0.0f));
    const float l3 = distance(scaledAnchorPoint, float2(0.0f, 1.0f) * aspectRatioScaleFactor);
    const float l4 = distance(scaledAnchorPoint, float2(1.0f, 0.0f) * aspectRatioScaleFactor);
    const float radius = max(l1, max3(l2, l3, l4));
    
    const float2 uv = (position / boundingRect.zw) * aspectRatioScaleFactor;
    const float d = distance(uv, scaledAnchorPoint);
    const float stopRadius = stop * radius;
    
    half4 outputColor = sourceColor;
    
    if (abs(d - stopRadius) >= delta) {
      return outputColor;
    }
    
    const float t = (d - (stopRadius - delta)) / delta;
    const half smoothness_h = static_cast<half>(smoothness);
    const half smoothed_t = static_cast<half>(t) * smoothness_h;
    
    outputColor = mix(outputColor, stopColor, clamp(smoothed_t, 0.0h, smoothness_h));
    outputColor = mix(outputColor, sourceColor, saturate(static_cast<half>(t) - 1.0h));
    outputColor *= sourceColor.a;
    
    return outputColor;
  }
  
  [[ stitchable ]] half4 solid_radial_gradient(float2 position,
                                               half4 sourceColor,
                                               float4 boundingRect,
                                               float2 anchorPoint,
                                               half4 startColor,
                                               half4 stopColor,
                                               half4 endColor,
                                               float smoothness,
                                               float stop) {
    const float aspectRatio = boundingRect.z / boundingRect.w;
    const float2 aspectRatioScaleFactor = float2(max(1.0f, aspectRatio), max(1.0f, 1.0f / aspectRatio));
    const float2 scaledAnchorPoint = anchorPoint * aspectRatioScaleFactor;
    
    const float l1 = distance(scaledAnchorPoint, float2(aspectRatioScaleFactor));
    const float l2 = length(scaledAnchorPoint); // distance(scaledAnchorPoint, float2(0.0f));
    const float l3 = distance(scaledAnchorPoint, float2(0.0f, 1.0f) * aspectRatioScaleFactor);
    const float l4 = distance(scaledAnchorPoint, float2(1.0f, 0.0f) * aspectRatioScaleFactor);
    const float radius = max(l1, max3(l2, l3, l4));
    
    const float2 uv = (position / boundingRect.zw) * aspectRatioScaleFactor;
    const float d = distance(uv, scaledAnchorPoint);
    const float stopRadius = stop * radius;
    
    const float t = d / stopRadius;
    const float s = 1.0f - remap(d, stopRadius, radius, 1.0f, 0.0f);
    const half smoothness_h = static_cast<half>(smoothness);
    const half smoothed_t = static_cast<half>(t) * smoothness_h;
    
    half4 outputColor = mix(startColor, stopColor, clamp(smoothed_t, 0.0h, smoothness_h));
    outputColor = mix(outputColor, endColor, saturate(static_cast<half>(s)));
    outputColor *= sourceColor.a;
    
    return outputColor;
  }
}
