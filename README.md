# Asset Tracker (iOS)

SwiftUI app for tracking personal assets — cash, physical items, stocks, crypto. It is the iOS client for the [asset-tracker-be](https://github.com/akhnafal-aban/asset-tracker-be) Go API: fetch, add, edit, and delete assets through a REST layer, with a dashboard of portfolio stats.

Built with Swift 5 MVVM — one view model per screen, views grouped per feature, no third-party dependencies.

## Screens

| Tab | What it does |
|---|---|
| **Dashboard** | Portfolio summary cards, value totals |
| **Assets** | List of assets by category; add, edit, delete; asset detail |
| **Settings** | App settings |

## Structure

```
Asset Tracker/
  App/                 app entry, AppConfig (API base URL)
  Core/
    Model/             Asset, AssetCategory, User
    Network/           Api.swift — thin URLSession wrapper (GET/POST/PUT/PATCH/DELETE)
  Screens/
    Root/              AppRootView (TabView)
    Main/              Dashboard + Assets + Toolbar (add asset)
    Components/        AssetRowView, StatCardView
    Settings/          SettingsView
```

View models live next to their screens (`DashboardViewModel`, `AssetViewModel`, `AssetDetailViewModel`, `AddAssetViewModel`).

## Running it

1. Start the backend first — see [asset-tracker-be](https://github.com/akhnafal-aban/asset-tracker-be) (`go run ./cmd/api`, listens on `:8080`)
2. Open `Asset Tracker.xcodeproj` in Xcode, run on a simulator
3. The API base URL is `http://localhost:8080/api/v1` in `App/AppConfig.swift` — change it if your backend runs elsewhere

Localhost HTTP requires permissive ATS settings for debug builds; use a real device on your LAN with the machine's IP instead of `localhost`.
