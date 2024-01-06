//
//  CalendarWithoutCurrentYear.swift
//  LifeProgress
//
//  Created by Bartosz Król on 10/03/2023.
//

import SwiftUI
import ComposableArchitecture

/**
 A view that displays a life calendar without the current year.
 
 This view is responsible for rendering a life calendar using a Canvas.
 It uses a Composable Architecture `store` to access the `life` and `calendarType` state.
 */
struct CalendarWithoutCurrentYear: View {
    
    let store: StoreOf<LifeCalendarReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            // Extract the current life expectancy and calendar type from the store.
            let life = viewStore.life
            let calendarType = viewStore.calendarType
            
            // Draw the life calendar using a canvas.
            Canvas { context, size in
                // Calculate the cell size and padding based on the canvas size and number of weeks in a year.
                let containerWidth = size.width
                let cellSize = containerWidth / Double(Life.totalWeeksInAYear)
                let cellPadding = cellSize / 12
                
                // Iterate over each year and week to draw the cells for each.
                for yearIndex in 0..<life.lifeExpectancy {
                    for weekIndex in 0..<Life.totalWeeksInAYear {
                        let cellPath = Path(CGRect(
                            x: Double(weekIndex) * cellSize + cellPadding,
                            y: Double(yearIndex) * cellSize + cellPadding,
                            width: cellSize - cellPadding * 2,
                            height: cellSize - cellPadding * 2
                        ))
                        
                        let currentYear = yearIndex + 1
                        let ageGroupColor = AgeGroup(age: currentYear).color
                        
                        // Fill the cell with the appropriate color based on the current year and life expectancy.
                        if currentYear < life.age {
                            context.fill(cellPath, with: .color(ageGroupColor))
                        } else if currentYear > life.age {
                            context.fill(cellPath, with: .color(Color(.systemFill)))
                        }
                    }
                }
            }
            .opacity(calendarType == .life ? 1 : 0)
            // Animate the canvas when the calendar type changes.
            .animation(calendarAnimation(for: calendarType), value: calendarType)
        }
    }
    
    /**
       Calculates the appropriate animation to use when changing the calendar type.
       
       - Parameter calendarType: A `CalendarType` object representing the current calendar type.

       - Returns: An `Animation` object representing the appropriate animation to use.
     */
    private func calendarAnimation(for calendarType: LifeCalendarReducer.State.CalendarType) -> Animation {
        let animation = Animation.easeInOut(duration: 0.4)
        guard calendarType == .life else {
            return animation.delay(0.4)
        }
        
        return animation
    }
}

// MARK: - Previews

#Preview {
    let store = Store(initialState: LifeCalendarReducer.State()) {
        LifeCalendarReducer()
    }
    
    return CalendarWithoutCurrentYear(store: store)
}
