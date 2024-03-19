// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ShaderUI",
  platforms: [
    .iOS(.v17),
    .macOS(.v14),
    .macCatalyst(.v17),
    .tvOS(.v17),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "ShaderUI",
      targets: ["ShaderUI"]
    ),
  ],
  targets: [
    .target(
      name: "ShaderUI"
    ),
  ]
)
