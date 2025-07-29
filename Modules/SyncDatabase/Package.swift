// swift-tools-version:5.10
import PackageDescription

let package = Package(
	name: "SyncDatabase",
	platforms: [.macOS(.v13), .iOS(.v17)],
	products: [
		.library(
			name: "SyncDatabase",
			type: .dynamic,
			targets: ["SyncDatabase"]),
	],
	dependencies: [
		.package(path: "../Articles"),
		.package(path: "../RSCore"),
		.package(path: "../RSDatabase"),
	],
	targets: [
		.target(
			name: "SyncDatabase",
			dependencies: [
				"RSCore",
				"RSDatabase",
				"Articles",
			]),
	]
)
