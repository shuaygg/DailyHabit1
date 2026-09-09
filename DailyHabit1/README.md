# Daily Habits — SwiftUI Midterm Conversion

This folder is a SwiftUI conversion of the supplied Figma Make/React prototype.

## Screens included

1. Onboarding / Welcome
2. Onboarding / Name
3. Today / Home
4. Add Habit
5. Habit Detail
6. Progress
7. Profile

## MVC structure

- Models/Habit.swift — model/data types
- Controllers/HabitController.swift — app state and business logic
- Views/*.swift — SwiftUI screens
- Components/AppTheme.swift — reusable UI components and colors
- DailyHabitsApp.swift — application entry point

## How to put this into Xcode

1. Open Xcode.
2. File > New > Project.
3. Select iOS > App.
4. Product Name: `DailyHabits`
5. Interface: `SwiftUI`
6. Language: `Swift`
7. Create the project.
8. Delete the generated ContentView.swift if you do not need it.
9. Drag the folders/files from this package into the Xcode project navigator.
10. Make sure `Target Membership` is checked for every `.swift` file.
11. Build with Command+B.
12. Run with Command+R.

Recommended deployment target: iOS 16.0 or newer.

The app uses only SwiftUI/Foundation APIs, so no external package is required.
