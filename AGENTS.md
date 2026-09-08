# AGENTS.md

## Development & Build
- **Platform**: Native Swift/SwiftUI iOS/macOS project.
- **Build**: Use `xcodebuild`. To list schemes: `xcodebuild -list -project "Side Search.xcodeproj"`.
- **Targets**: 
    - `Side Search`: Main application.
    - `SharedIntents`: Shared App Intents logic.
    - `WidgetExtension`: Widget implementation.
- **Testing**: No dedicated test suite exists at root. If adding tests, ensure they are added to a new test target linked to the relevant application/framework targets.

## Project Structure
- `SharedIntents/`: Core logic for AppIntents. Any changes here require verifying compatibility with `Side Search` and `WidgetExtension`.
- `WidgetExtension/`: Widget-specific UI and logic.

## Key Quirks
- **App Intents**: Central to the app's functionality. Changes to intents often require updating `Info.plist` or target entitlements.
- **Side Button Access**: Relies heavily on Apple's `AppIntents` framework. Refer to Apple documentation on "Launching your voice-based conversational app from the side button of iPhone" when modifying intent flow.
- **Entitlements**: `WidgetExtensionExtension.entitlements` handles specific capabilities for widgets. Ensure changes here align with App Store requirements.
- **Data Sharing**: The app relies on shared `UserDefaults` via `group.net.cizzuk.sidesearch` in `Constants.swift`. Any changes to entitlements (specifically App Groups) MUST be synchronized with this identifier.
- **Typo Check**: Always verify search engine presets in `Localizable.xcstrings` and `SearchEnginePresets.swift` for typos (e.g., "GitHub").
