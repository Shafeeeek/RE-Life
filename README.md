# 🔥 RE-LIFE — Streak Tracker & Brain Rewiring App

> **Break the cycle. Rebuild your brain. Become your strongest self.**

RE-LIFE is a beautifully designed iOS streak tracker built with **SwiftUI** to help users overcome addiction, build discipline, and track their recovery journey — day by day.

---

## 📱 Screenshots

<img width="250" height="400" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-06 at 01 28 30" src="https://github.com/user-attachments/assets/cfad4389-02b9-4fcb-9ca8-d76c716fdb7f" />
<img width="250" height="400" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-06 at 01 37 30" src="https://github.com/user-attachments/assets/8697b3e0-37fd-4814-9499-a7f56d1a09d3" />
<img width="250" height="400" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-06 at 01 37 33" src="https://github.com/user-attachments/assets/fa90006b-a7d8-45af-8c40-258f596bedbe" />
<img width="250" height="400" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-06 at 01 37 35" src="https://github.com/user-attachments/assets/0669ee76-0293-43ef-97ea-58aec2f90f19" />
<img width="250" height="400" alt="Simulator Screenshot - iPhone 17 Pro - 2026-03-06 at 01 37 38" src="https://github.com/user-attachments/assets/f605f150-d7a8-46c0-9574-c462bb5c70a8" />

---

## ✨ Features

- 🔥 **Streak Tracker** — Track days, months, and years since your last relapse
- 🏆 **Badge System** — Unlock 9 milestone badges from Day 1 to Day 365
- 💡 **Urge Buster Tips** — 13 science-backed techniques to fight cravings in real time
- 🧠 **Brain Status** — Dynamic insights into how your brain is healing at each stage
- 📊 **Stats Dashboard** — View your best streak, total resets, points, and journey map
- 🎉 **Celebration Overlay** — Animated badge unlock screen with confetti
- 🌙 **Welcome Onboarding** — Clean first-launch experience with feature overview
- 🌑 **Dark Mode** — Fully native dark UI with custom color palette

---

## 🏅 Badge Milestones

| Badge | Days | Points |
|-------|------|--------|
| 🌱 First Sunrise | 1 | 100 |
| 🔥 Spark | 3 | 250 |
| ⚡ One Week | 7 | 500 |
| 🌊 Two Weeks | 14 | 900 |
| 👑 30-Day King | 30 | 1,800 |
| 🦁 Warrior | 60 | 3,200 |
| 🌟 Titan | 90 | 5,000 |
| 🚀 Half-Year Legend | 180 | 9,000 |
| 🏆 Year Champion | 365 | 20,000 |

---

## 🧱 Project Structure

```
RE-Life/
├── ContentView.swift        # Main entry — all views & logic
│
├── Models
│   ├── StreakData            # Codable data model (persisted via UserDefaults)
│   ├── Badge                 # Badge definition model
│   └── Tip                   # Tip/recommendation model
│
├── ViewModel
│   └── StreakViewModel       # ObservableObject, streak logic, badge checks
│
├── Views
│   ├── MainAppView           # Root tab navigation
│   ├── WelcomeView           # Onboarding screen (shown once)
│   ├── HomeView              # Streak counter, ring animation, reset button
│   ├── BadgesView            # Badge grid with unlock states
│   ├── TipsView              # Urge buster + tips list
│   ├── StatsView             # Brain status, stat tiles, journey map
│   └── CelebrationView       # Animated badge unlock overlay
│
└── Components
    ├── TimeChip              # Years / Months / Days display chips
    ├── BadgeCell             # Individual badge grid cell
    ├── TipRow                # Expandable tip list row
    ├── StatTile              # Stats grid tile
    ├── FeatureRow            # Welcome screen feature row
    └── ConfettiItem          # Confetti particle for celebration
```

---

## 🚀 Getting Started

### Requirements

- **Xcode** 15+
- **iOS** 17+
- **Swift** 5.9+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/RE-Life.git
   ```

2. Open in Xcode:
   ```bash
   cd RE-Life
   open RE-Life.xcodeproj
   ```

3. Select your target device or simulator and press **⌘ + R** to run.

> No external dependencies — pure SwiftUI, no SPM packages required.

---

## 🗃️ Data Persistence

User data is stored locally using `UserDefaults` via `@AppStorage` and manual `JSONEncoder/JSONDecoder`:

| Key | Type | Description |
|-----|------|-------------|
| `relife_v1` | `StreakData` (JSON) | Start date, points, badges, resets |
| `hasSeenWelcome` | `Bool` | Whether onboarding has been shown |

All data stays on-device. No accounts, no servers, no tracking.

---

## 🧠 Brain Recovery Stages

The app displays dynamic recovery insights based on current streak:

| Days | Status | Description |
|------|--------|-------------|
| 0–2 | 🌱 Detox Begins | Dopamine receptors start resetting |
| 3–6 | 💧 Withdrawal Phase | Cravings peak; discomfort means healing |
| 7–13 | ⚡ Energy Surge | Testosterone rising, sharper focus |
| 14–29 | 🌤 Fog Lifting | Prefrontal cortex activity increasing |
| 30–59 | 🔗 Deep Rewiring | Neural pathways rebuilding |
| 60–89 | 🧠 New Baseline | Dopamine system approaching healthy |
| 90+ | 🚀 Fully Rewired | Operating at full potential |

---

## 🎨 Design System

```swift
// Background
Color.bgDark   → rgb(0.06, 0.05, 0.12)   // deep dark purple-black
Color.cardDark → rgb(0.11, 0.10, 0.18)   // card background

// Accent
Color.orange1  → rgb(1.00, 0.43, 0.13)   // primary orange
Color.gold1    → rgb(1.00, 0.78, 0.10)   // gold highlight
```

All badge colors are defined per-badge as hex strings for easy customisation.

---

## 🛠️ Customisation

### Changing the Starting Streak (Dev/Testing)

In `StreakViewModel.init()`:

```swift
// Set a manual day count for testing
manualDays = 18   // ← change or set to nil to use real date
```

### Adding New Badges

Add a new entry to the `allBadges` array in `ContentView.swift`:

```swift
Badge(id: "d500", emoji: "🌌", name: "500 Days", subtitle: "Half a millennium", days: 500, colorHex: "1A237E", points: 50000)
```

### Adding New Tips

Add to the `allTips` array:

```swift
Tip(emoji: "🧊", title: "Ice Bath", body: "Cold exposure spikes norepinephrine 300%. Powerful urge reset.", tag: "Move")
```

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

1. Fork the project
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 💬 Acknowledgements

Built with ❤️ using SwiftUI. Designed for anyone trying to build discipline, beat addiction, and become the best version of themselves.

> *"Every day sober is a day your brain is healing."*

---

<p align="center">
  Made with 🔥 by <a href="https://github.com/YOUR_USERNAME">Your Name</a>
</p>
