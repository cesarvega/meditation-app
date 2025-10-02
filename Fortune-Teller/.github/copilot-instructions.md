# Fortune-Teller iOS App - AI Agent Instructions

## Project Overview
This is a SwiftUI-based iOS application that appears to be a fortune-telling app. The project uses modern iOS development patterns with SwiftData for persistence and follows Apple's latest architectural recommendations.

## Architecture & Key Patterns

### SwiftData Integration
- **Model Layer**: `Item.swift` defines the core data model using `@Model` macro
- **Persistence**: App uses SwiftData with `ModelContainer` configured in `Fortune_TellerApp.swift`
- **Data Access**: Views use `@Environment(\.modelContext)` and `@Query` for data operations
- **Pattern**: All data operations should use `modelContext.insert()` and `modelContext.delete()` with `withAnimation` blocks

```swift
// Example data operations pattern used in ContentView.swift
private func addItem() {
    withAnimation {
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
    }
}
```

### SwiftUI Conventions
- **Navigation**: Uses `NavigationSplitView` for iPad-optimized layout
- **Previews**: All views include `#Preview` with in-memory model containers
- **Animations**: Data mutations wrapped in `withAnimation` blocks
- **State Management**: Relies on SwiftData's reactive updates via `@Query`

## File Structure & Responsibilities
- `Fortune_TellerApp.swift`: App entry point with ModelContainer configuration
- `ContentView.swift`: Main interface with list/detail navigation pattern
- `Item.swift`: Core data model (currently placeholder with timestamp)
- `Assets.xcassets/`: Standard iOS asset catalog for icons, colors, images

## Development Workflows

### Building & Running
- **Target Platform**: iOS (likely requires iOS simulator or physical device)
- **Common Issue**: "A build only device cannot be used to run this target" indicates:
  - Deployment target mismatch between project and selected device
  - Need to select iOS Simulator or connected iOS device for running
  - Build-only devices (like generic iOS device) cannot execute apps

### Xcode Project Structure
This appears to be part of a larger Xcode workspace/project located outside the current directory structure. The `.xcodeproj` or `.xcworkspace` files are not visible in this directory.

## Key Development Guidelines

### Data Model Expansion
When adding new fortune-telling features:
- Extend `Item.swift` or create new `@Model` classes
- Update the Schema in `Fortune_TellerApp.swift` to include new models
- Use proper SwiftData relationships (`@Relationship`) for complex data

### UI Development
- Follow the existing `NavigationSplitView` pattern for scalable interfaces
- Use `@Query` for reactive data binding
- Implement proper accessibility labels for fortune-telling content
- Consider iPad multitasking with the split view design

### Testing & Previews
- All new views should include `#Preview` with `.modelContainer(for: YourModel.self, inMemory: true)`
- Use in-memory containers for previews to avoid affecting real data

## Project-Specific Conventions
- File naming uses underscores for app files (`Fortune_TellerApp.swift`)
- All files include standard Apple file headers with creation date
- Data operations always wrapped in animations for smooth UX
- Uses `final class` for `@Model` objects following SwiftData best practices

## Integration Notes
- This workspace likely contains additional Xcode project files in parent directories
- The project structure suggests this is the source folder of a larger iOS project
- Consider the app's fortune-telling domain when adding features (predictions, readings, etc.)