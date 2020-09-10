// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NavigationBarProgress",
  platforms: [.iOS(.v9)],
  products: [
    .library(
      name: "NavigationBarProgress",
      targets: ["NavigationBarProgress"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "NavigationBarProgress",
      dependencies: []
    ),
  ]
)
