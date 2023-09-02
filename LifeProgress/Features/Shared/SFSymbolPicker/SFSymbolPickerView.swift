//
//  SFSymbolPickerView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 16/04/2023.
//

import SwiftUI
import ComposableArchitecture
import SymbolPicker

struct SFSymbolPickerView: View {
        
    @Environment(\.theme) var theme

    let store: StoreOf<SFSymbolPickerReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let symbolName = viewStore.symbolName
            
            Button {
                viewStore.send(.showSheet)
            } label: {
                Image(systemName: symbolName)
                    .font(.title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .foregroundColor(theme.color)
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isSheetVisible,
                    send: SFSymbolPickerReducer.Action.hideSheet
                )
            ) {
                SymbolPicker(
                    symbol: viewStore.binding(
                        get: \.symbolName,
                        send: SFSymbolPickerReducer.Action.symbolNameChanged
                    )
                )
            }
        }
    }
}

// MARK: - Previews

struct SFSymbolPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store(initialState: SFSymbolPickerReducer.State()) {
            SFSymbolPickerReducer()
        }
        
        SFSymbolPickerView(store: store)
    }
}
