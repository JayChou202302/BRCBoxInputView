//
//  BRCBoxInputView_SwiftUIApp.swift
//  BRCBoxInputView_SwiftUI
//
//  Created by sunzhixiong on 2024/8/15.
//

import SwiftUI
import BRCFastTest
import FLEX

@main
struct BRCBoxInputView_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            BRCMainContentView {
                BRCTestSwiftUITabBarView(tabBarItems: [
                    BRCTestSwiftUITabBarItem(title: "main", image: .init(systemName: "house"), contentView: {
                        MainView(select: 0)
                    }),
                    BRCTestSwiftUITabBarItem(title: "test", image: .init(systemName: "pencil.and.scribble"), contentView: {
                        MainView(select: 1)
                    })
                ])
            } onClickDebugButton: {
                FLEXManager.shared.toggleExplorer()
            }

        }
    }
}
