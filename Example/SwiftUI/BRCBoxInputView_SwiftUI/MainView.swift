//
//  ContentView.swift
//  BRCBoxInputView_SwiftUI
//
//  Created by sunzhixiong on 2024/8/15.
//

import SwiftUI

struct MainView : View {
    var select : Int = 0;
    @State var isBoxInputFocus   : Bool = false;
    var body: some View {
        if (select == 0) {
            NavigationView {
                ScrollView {
                    VStack {
                        ContentView(isBoxInputFocus: $isBoxInputFocus);
                    }
                    .padding(.bottom,48)
                    .onAppear {
                        isBoxInputFocus = true
                    }
                }
                .navigationTitle("BRCBoxInputView")
            }
        } else {
            CustomContentView()
        }
    }
}

#Preview {
    MainView()
}

