// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BRCBoxInputView",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "BRCBoxInputView",
            targets: ["BRCBoxInputView"]
        ),
    ],
    targets: [
        .target(
            name: "BRCBoxInputView",
            path: "BRCBoxInputView/Classes",
            exclude: [
                "BRCBoxInputView.h",
                "BRCBoxInputView.m",
                "BRCBoxInputViewConst.h",
            ]
        ),
        .target(
            name: "CBRCBoxInputView",
            path: "BRCBoxInputView/Classes",
            exclude: [
                "BRCBoxInput.swift",
            ],
            publicHeadersPath: "./"
        )
    ],
    cLanguageStandard: .c11
)
