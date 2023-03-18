//
//  RootView.swift
//  LifeProgress
//
//  Created by Bartosz Król on 17/03/2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: RootStore
    
    var body: some View {
        TabView {
            LifeCalendarView(
                store: store.scope(
                    state: \.lifeCalendar,
                    action: RootReducer.Action.lifeCalendar
                )
            )
            .tabItem {
                Label("Life Calendar", systemImage: "calendar")
            }
            
            
            ProfileView(
                store: store.scope(
                    state: \.profile,
                    action: RootReducer.Action.profile
                )
            )
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .modifier(
            ThemeApplicator(
                store: store.scope(state: \.profile.theme).actionless
            )
        )
    }
}

// MARK: - Previews

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store<RootReducer.State, RootReducer.Action>(
            initialState: RootReducer.State(),
            reducer: RootReducer()
        )
        RootView(store: store)
    }
}