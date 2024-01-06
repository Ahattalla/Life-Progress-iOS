//
//  OnboardingLifeExpectancyView.swift
//  Life Progress - Calendar
//
//  Created by Bartosz Król on 03/05/2023.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingLifeExpectancyView: View {
    
    @Environment(\.theme) var theme
    
    let store: StoreOf<OnboardingReducer>
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(spacing: 24) {
                        HStack {
                            Spacer()
                            Image(systemName: "staroflife.circle")
                                .font(.system(size: 72))
                                .foregroundColor(theme.color)
                            Spacer()
                        }
                        
                        Text("Select Your Life Expectancy")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .listRowBackground(Color.clear)
                
                Section {
                    LifeExpectancyView(
                        store: self.store.scope(
                            state: \.lifeExpectancy,
                            action: OnboardingReducer.Action.lifeExpectancy
                        )
                    )
                } footer: {
                    Text("This information allows us to customize your experience and deliver relevant insights. Your data is safe and will not be shared with anyone. The global average life expectancy is around 72.8 years, but this can vary based on factors such as genetics, lifestyle, healthcare, and socioeconomic status.")
                }
            }
            
            Button {
                self.store.send(.continueButtonTapped)
            } label: {
                Text("Continue")
                    .font(.headline)
            }
            .tint(theme.color)
            .padding()
        }
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: OnboardingReducer.State()) {
        OnboardingReducer()
    }
    
    return NavigationStack {
        OnboardingLifeExpectancyView(store: store)
    }
}
