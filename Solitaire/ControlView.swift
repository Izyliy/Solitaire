//
//  ControlView.swift
//  Solitaire
//
//  Created by Павел Грабчак on 10.10.2024.
//

import SwiftUI

struct ControlView: View {
    let moveCount: Int
    let reloadAction: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 250/256, green: 250/256, blue: 227/256).opacity(0.9))
            // Color(red: 240/256, green: 230/256, blue: 140/256)
            HStack {
                Spacer()
                Button {
                    reloadAction()
                } label: {
                    Image(systemName: "arrow.2.circlepath")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                }
                Spacer()
                Text("Ход: \(moveCount)")
                Spacer()
            }
        }
        .frame(height: 64)
        .padding()
    }
}

#Preview {
    ContentView()
}
