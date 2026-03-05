
//
//  ContentView.swift
//  RE-Life
//
//  Created by shafeek macbook pro on 05/03/2026.
//


import SwiftUI
internal import Combine

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Data Model
// ─────────────────────────────────────────────────────────────────────────────

struct StreakData: Codable {
    var startDate:         Date   = Date()
    var longestStreak:     Int    = 0
    var totalResets:       Int    = 0
    var points:            Int    = 0
    var unlockedBadgeIDs: [String] = []
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Badge Model
// ─────────────────────────────────────────────────────────────────────────────

struct Badge: Identifiable {
    let id:          String
    let emoji:       String
    let name:        String
    let subtitle:    String
    let days:        Int
    let colorHex:    String
    let points:      Int
}

let allBadges: [Badge] = [
    Badge(id: "d1",   emoji: "🌱", name: "First Sunrise",    subtitle: "24 hours of courage",   days: 1,   colorHex: "4CAF50", points: 100),
    Badge(id: "d3",   emoji: "🔥", name: "Spark",            subtitle: "3 days ignited",        days: 3,   colorHex: "FF6D00", points: 250),
    Badge(id: "d7",   emoji: "⚡", name: "One Week",          subtitle: "7 days of power",       days: 7,   colorHex: "FFD600", points: 500),
    Badge(id: "d14",  emoji: "🌊", name: "Two Weeks",        subtitle: "2 weeks in the zone",   days: 14,  colorHex: "00BCD4", points: 900),
    Badge(id: "d30",  emoji: "👑", name: "30-Day King",      subtitle: "One full month clean",  days: 30,  colorHex: "FFC107", points: 1800),
    Badge(id: "d60",  emoji: "🦁", name: "Warrior",          subtitle: "Two months of mastery", days: 60,  colorHex: "F44336", points: 3200),
    Badge(id: "d90",  emoji: "🌟", name: "Titan",            subtitle: "90 days — you rewired", days: 90,  colorHex: "9C27B0", points: 5000),
    Badge(id: "d180", emoji: "🚀", name: "Half-Year Legend", subtitle: "180 days of freedom",   days: 180, colorHex: "3F51B5", points: 9000),
    Badge(id: "d365", emoji: "🏆", name: "Year Champion",   subtitle: "365 days — LEGENDARY",  days: 365, colorHex: "FF6D00", points: 20000),
]

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Tip Model
// ─────────────────────────────────────────────────────────────────────────────

struct Tip: Identifiable {
    let id    = UUID()
    let emoji: String
    let title: String
    let body:  String
    let tag:   String
}

let allTips: [Tip] = [
    Tip(emoji: "🚿", title: "Cold Shower",       body: "2 minutes of cold water resets cortisol, spikes dopamine naturally, and kills cravings instantly.",              tag: "Move"),
    Tip(emoji: "🏃", title: "Sprint it Out",     body: "Do 6×20-second all-out sprints. Physical exhaustion is the fastest way to short-circuit an urge.",              tag: "Move"),
    Tip(emoji: "💪", title: "Drop & Do 50",      body: "50 push-ups right now. No thinking — just drop. Testosterone goes up, urge goes down.",                         tag: "Move"),
    Tip(emoji: "🧘", title: "4-7-8 Breath",      body: "Inhale 4s → Hold 7s → Exhale 8s. Do 4 rounds. Activates your parasympathetic nervous system instantly.",        tag: "Mind"),
    Tip(emoji: "✍️", title: "Journal Your Why",  body: "Write 3 sentences about WHY you started. Reconnect with your future self.",                                     tag: "Mind"),
    Tip(emoji: "🧠", title: "10-Min Meditation", body: "Close your eyes. Watch the urge like a cloud passing. It peaks and fades in under 10 minutes every time.",      tag: "Mind"),
    Tip(emoji: "📞", title: "Call Someone",      body: "Pick up the phone and call a friend or family member. Human voice is the fastest connection reset.",             tag: "Connect"),
    Tip(emoji: "🚶", title: "Walk Outside",      body: "Step outside for 10 minutes. Sunlight, fresh air, and movement are powerful dopamine regulators.",               tag: "Connect"),
    Tip(emoji: "🎵", title: "Music Surge",       body: "Put on your most energising playlist, turn it up loud, and move. Music is a direct emotional lever.",            tag: "Create"),
    Tip(emoji: "📚", title: "Read 10 Pages",     body: "Open a book — any book. Reading redirects the prefrontal cortex and crowds out cravings.",                      tag: "Create"),
    Tip(emoji: "🎨", title: "Create Something",  body: "Draw, write code, play an instrument, cook. Channeling energy into creation is the highest use of urge energy.", tag: "Create"),
    Tip(emoji: "😴", title: "Sleep by 10 PM",    body: "Most relapses happen late at night. Set a hard 10 PM phone-down rule. Sleep is your #1 recovery tool.",         tag: "Rest"),
    Tip(emoji: "🌙", title: "Night Routine",     body: "Plan tomorrow before sleep: gym time, meals, one hard task. Structure collapses triggers.",                      tag: "Rest"),
]

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Color helpers
// ─────────────────────────────────────────────────────────────────────────────

extension Color {
    static let bgDark    = Color(red: 0.06, green: 0.05, blue: 0.12)
    static let cardDark  = Color(red: 0.11, green: 0.10, blue: 0.18)
    static let orange1   = Color(red: 1.00, green: 0.43, blue: 0.13)
    static let gold1     = Color(red: 1.00, green: 0.78, blue: 0.10)

    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var n: UInt64 = 0
        Scanner(string: h).scanHexInt64(&n)
        self.init(
            red:   Double((n >> 16) & 0xFF) / 255,
            green: Double((n >> 8)  & 0xFF) / 255,
            blue:  Double( n        & 0xFF) / 255
        )
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – ViewModel
// ─────────────────────────────────────────────────────────────────────────────

class StreakViewModel: ObservableObject {
    @AppStorage("hasSeenWelcome") var hasSeenWelcome = false
    @Published var data             = StreakData()
    @Published var showCelebration  = false
    @Published var pendingBadge:    Badge? = nil
    
    // ✅ MANUAL STREAK OVERRIDE
    @Published var manualDays: Int? = nil
    
    private let saveKey = "relife_v1"

    init() {
        
        if let raw = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode(StreakData.self, from: raw) {
            data = decoded
        }
        
        // ✅ SET MANUAL DAYS HERE
        manualDays = 18
    }

    // ── Time ──────────────────────────────────────────────
    
    var currentDays: Int {
        // ✅ If manual value exists use it
        if let manualDays {
            return manualDays
        }
        
        return max(
            0,
            Calendar.current.dateComponents([.day], from: data.startDate, to: Date()).day ?? 0
        )
    }
    
    var displayYears:  Int { currentDays / 365 }
    var displayMonths: Int { (currentDays % 365) / 30 }
    var displayDays:   Int { currentDays % 30 }

    // ── Progress ──────────────────────────────────────────
    
    var progressToNext: Double {
        guard let next = nextBadge else { return 1 }
        let prev  = allBadges.last { $0.days <= currentDays && data.unlockedBadgeIDs.contains($0.id) }?.days ?? 0
        let range = next.days - prev
        guard range > 0 else { return 1 }
        return min(1, Double(currentDays - prev) / Double(range))
    }

    var nextBadge: Badge? {
        allBadges.first { !data.unlockedBadgeIDs.contains($0.id) && $0.days > currentDays }
    }

    var unlockedBadges: [Badge] {
        allBadges.filter { data.unlockedBadgeIDs.contains($0.id) }
    }

    // ── Helpers ───────────────────────────────────────────
    
    var flameEmoji: String {
        switch currentDays {
        case 0:        return "🌱"
        case 1...3:    return "🔥"
        case 4...7:    return "⚡"
        case 8...14:   return "💪"
        case 15...29:  return "🌟"
        case 30...89:  return "👑"
        default:       return "🚀"
        }
    }

    var motiveLine: String {
        switch currentDays {
        case 0:        return "Every legend starts on Day 0. Begin."
        case 1:        return "24 hours done. The hardest step is behind you."
        case 2...3:    return "Your brain is already recalibrating. Hold the line."
        case 4...7:    return "First week incoming. You're building something real."
        case 8...14:   return "Double digits. You are not the same person you were."
        case 15...29:  return "Halfway to 30. Dopamine receptors are healing."
        case 30:       return "🎉 ONE MONTH. You earned the crown today."
        case 31...89:  return "Elite territory. Most people never make it here."
        case 90:       return "🏆 90 DAYS. TITAN STATUS ACHIEVED."
        default:       return "You are proof that change is possible. Keep going."
        }
    }

    var startFormatted: String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: data.startDate)
    }

    // ── Manual Setter ─────────────────────────────────────
    
    func setManualDays(_ days: Int) {
        manualDays = max(0, days)
    }

    // ── Actions ───────────────────────────────────────────
    
    func checkBadges() {
        for badge in allBadges where currentDays >= badge.days && !data.unlockedBadgeIDs.contains(badge.id) {
            data.unlockedBadgeIDs.append(badge.id)
            data.points += badge.points
            pendingBadge   = badge
            showCelebration = true
            save()
        }
    }

    func reset() {
        if currentDays > data.longestStreak { data.longestStreak = currentDays }
        data.totalResets       += 1
        data.startDate          = Date()
        data.unlockedBadgeIDs   = []
        manualDays = 0
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Root View
// ─────────────────────────────────────────────────────────────────────────────

struct MainAppView: View{
    @StateObject private var vm  = StreakViewModel()
    @State private var tab: Int  = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.bgDark.ignoresSafeArea()

            Group {
                switch tab {
                case 0:  HomeView()
                case 1:  BadgesView()
                case 2:  TipsView()
                default: StatsView()
                }
            }
            .environmentObject(vm)

            // Tab bar
            HStack(spacing: 0) {
                tabBtn(icon: "flame.fill",     label: "Streak", index: 0)
                tabBtn(icon: "trophy.fill",    label: "Prizes",  index: 1)
                tabBtn(icon: "lightbulb.fill", label: "Tips",    index: 2)
                tabBtn(icon: "chart.bar.fill", label: "Stats",   index: 3)
            }
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(
                Color.black.opacity(0.6)
                    .background(.ultraThinMaterial)
                    .overlay(Divider().opacity(0.2), alignment: .top)
            )

            // Celebration overlay
            if vm.showCelebration, let badge = vm.pendingBadge {
                CelebrationView(badge: badge) {
                    withAnimation { vm.showCelebration = false }
                }
                .zIndex(99)
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private func tabBtn(icon: String, label: String, index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { tab = index }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: tab == index ? 22 : 18, weight: .semibold))
                    .foregroundColor(tab == index ? .orange1 : .gray.opacity(0.5))
                    .scaleEffect(tab == index ? 1.1 : 1)
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(tab == index ? .orange1 : .gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Home Screen
// ─────────────────────────────────────────────────────────────────────────────

struct HomeView: View {
    @EnvironmentObject var vm: StreakViewModel
    @State private var ringRotation: Double  = 0
    @State private var pulseScale: CGFloat   = 1.0
    @State private var appeared              = false
    @State private var showResetAlert        = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {

                // App title + emoji
                VStack(spacing: 6) {
                    Text("RE-LIFE")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .tracking(6)
                        .foregroundColor(.orange1)
                    Text(vm.flameEmoji)
                        .font(.system(size: 48))
                        .scaleEffect(pulseScale)
                }
                .padding(.top, 60)
                .opacity(appeared ? 1 : 0)

                // ── Orbit ring + counter ──────────────────
                ZStack {
                    // Glow
                    Circle()
                        .fill(RadialGradient(
                            colors: [.orange1.opacity(0.25), .clear],
                            center: .center,
                            startRadius: 50, endRadius: 120))
                        .frame(width: 250, height: 250)

                    // Spinning ring
                    Circle()
                        .trim(from: 0, to: 0.8)
                        .stroke(
                            AngularGradient(
                                colors: [.orange1, .gold1, .purple, .orange1],
                                center: .center),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 210, height: 210)
                        .rotationEffect(.degrees(ringRotation))

                    // Progress arc
                    Circle()
                        .trim(from: 0, to: CGFloat(vm.progressToNext))
                        .stroke(
                            LinearGradient(
                                colors: [.orange1, .gold1],
                                startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 11, lineCap: .round)
                        )
                        .frame(width: 190, height: 190)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1), value: vm.progressToNext)

                    // Day number
                    VStack(spacing: 2) {
                        Text("\(vm.currentDays)")
                            .font(.system(size: 68, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .gold1],
                                               startPoint: .top, endPoint: .bottom))
                        Text("DAYS")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .tracking(4)
                            .foregroundColor(.gray)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.7)

                // ── Years / Months / Days chips ───────────
                HStack(spacing: 12) {
                    TimeChip(value: vm.displayYears,  unit: "YRS",  color: Color(hex: "9C27B0"))
                    TimeChip(value: vm.displayMonths, unit: "MOS",  color: Color(hex: "00BCD4"))
                    TimeChip(value: vm.displayDays,   unit: "DAYS", color: .orange1)
                }
                .opacity(appeared ? 1 : 0)

                // ── Motivational card ─────────────────────
                VStack(spacing: 6) {
                    Text(vm.motiveLine)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.88))
                    Text("Since \(vm.startFormatted)")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.gray.opacity(0.6))
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(cardBg)
                .opacity(appeared ? 1 : 0)

                // ── Next badge progress ───────────────────
                if let next = vm.nextBadge {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("\(next.emoji) Next: \(next.name)")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(next.days - vm.currentDays) days left")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange1)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 7)
                                Capsule()
                                    .fill(LinearGradient(
                                        colors: [.orange1, .gold1],
                                        startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * CGFloat(vm.progressToNext), height: 7)
                                    .animation(.easeInOut(duration: 1), value: vm.progressToNext)
                            }
                        }
                        .frame(height: 7)
                    }
                    .padding(18)
                    .background(cardBg)
                    .opacity(appeared ? 1 : 0)
                }

                // ── Reset button ──────────────────────────
                Button { showResetAlert = true } label: {
                    Label("I Relapsed", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.1))
                                .overlay(Capsule().stroke(Color.red.opacity(0.3), lineWidth: 1))
                        )
                }
                .padding(.bottom, 100)
                .opacity(appeared ? 1 : 0)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { appeared = true }
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) { ringRotation = 360 }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { pulseScale = 1.2 }
            vm.checkBadges()
        }
        .alert("Start Over?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                withAnimation { vm.reset() }
            }
        } message: {
            Text("Your best streak (\(vm.data.longestStreak) days) will be saved. Stay strong next time. 💪")
        }
    }

    private var cardBg: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.09), lineWidth: 1)
            )
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Time Chip
// ─────────────────────────────────────────────────────────────────────────────

struct TimeChip: View {
    let value: Int
    let unit:  String
    let color: Color
    @State private var bounce = false

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundColor(color)
                .scaleEffect(bounce ? 1.08 : 1)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...1))
                    ) { bounce = true }
                }
            Text(unit)
                .font(.system(size: 9, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundColor(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(color.opacity(0.35), lineWidth: 1)
                )
        )
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Badges / Prizes
// ─────────────────────────────────────────────────────────────────────────────

struct BadgesView: View {
    @EnvironmentObject var vm: StreakViewModel
    let cols = Array(repeating: GridItem(.flexible(), spacing: 14), count: 3)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {

                // Points banner
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TOTAL POINTS")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .tracking(3)
                            .foregroundColor(.gray.opacity(0.7))
                        Text("\(vm.data.points)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.gold1, .orange1],
                                               startPoint: .leading, endPoint: .trailing))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("BADGES")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .tracking(3)
                            .foregroundColor(.gray.opacity(0.7))
                        Text("\(vm.unlockedBadges.count)/\(allBadges.count)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.cardDark)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    LinearGradient(colors: [.gold1.opacity(0.5), Color(hex: "9C27B0").opacity(0.4)],
                                                   startPoint: .leading, endPoint: .trailing),
                                    lineWidth: 1)
                        )
                )

                Text("ACHIEVEMENTS")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .tracking(5)
                    .foregroundColor(.gray.opacity(0.6))

                LazyVGrid(columns: cols, spacing: 14) {
                    ForEach(allBadges) { badge in
                        BadgeCell(badge: badge,
                                  unlocked: vm.data.unlockedBadgeIDs.contains(badge.id))
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
    }
}

struct BadgeCell: View {
    let badge:    Badge
    let unlocked: Bool
    @State private var pulse = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if unlocked {
                    Circle()
                        .stroke(Color(hex: badge.colorHex).opacity(pulse ? 0 : 0.5), lineWidth: 2)
                        .frame(width: 66, height: 66)
                        .scaleEffect(pulse ? 1.35 : 1)
                        .onAppear {
                            withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                                pulse = true
                            }
                        }
                }
                Circle()
                    .fill(unlocked
                          ? Color(hex: badge.colorHex).opacity(0.18)
                          : Color.white.opacity(0.04))
                    .frame(width: 58, height: 58)
                Text(unlocked ? badge.emoji : "🔒")
                    .font(.system(size: unlocked ? 26 : 20))
                    .grayscale(unlocked ? 0 : 1)
                    .opacity(unlocked ? 1 : 0.3)
            }

            Text(badge.name)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(unlocked ? .white : .gray.opacity(0.4))
                .lineLimit(2)
                .minimumScaleFactor(0.7)

            Text("\(badge.days)d")
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundColor(unlocked ? Color(hex: badge.colorHex) : .gray.opacity(0.3))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(unlocked
                      ? Color(hex: badge.colorHex).opacity(0.07)
                      : Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(unlocked ? Color(hex: badge.colorHex).opacity(0.35) : Color.clear, lineWidth: 1)
                )
        )
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Tips / Recommendations
// ─────────────────────────────────────────────────────────────────────────────

struct TipsView: View {
    @State private var featured: Tip = allTips.randomElement()!

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {

                // SOS urge buster card
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("URGE BUSTER — DO THIS NOW", systemImage: "bolt.fill")
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .tracking(1)
                            .foregroundColor(.orange1)
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.4)) {
                                featured = allTips.randomElement()!
                            }
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.orange1)
                                .padding(8)
                                .background(Circle().fill(Color.orange1.opacity(0.15)))
                        }
                    }

                    HStack(alignment: .top, spacing: 14) {
                        Text(featured.emoji)
                            .font(.system(size: 44))
                        VStack(alignment: .leading, spacing: 6) {
                            Text(featured.title)
                                .font(.system(size: 17, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text(featured.body)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.75))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .id(featured.id)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.cardDark)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.orange1.opacity(0.45), lineWidth: 1.5)
                        )
                )

                // All tips list
                VStack(spacing: 12) {
                    ForEach(allTips) { tip in
                        TipRow(tip: tip)
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
    }
}

struct TipRow: View {
    let tip: Tip
    @State private var expanded = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                expanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: expanded ? 10 : 0) {
                HStack(spacing: 14) {
                    Text(tip.emoji).font(.system(size: 26))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(tip.title)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(tip.tag)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(1)
                            .foregroundColor(.cyan.opacity(0.8))
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray.opacity(0.5))
                }

                if expanded {
                    Text(tip.body)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Stats
// ─────────────────────────────────────────────────────────────────────────────

struct StatsView: View {
    @EnvironmentObject var vm: StreakViewModel
    let cols = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)

    var brainInfo: (icon: String, title: String, body: String) {
        switch vm.currentDays {
        case 0...2:   return ("🌱", "Detox Begins",     "Dopamine receptors start resetting. The first 72 h are the hardest.")
        case 3...6:   return ("💧", "Withdrawal Phase", "Cravings peak around day 3–5. This discomfort means your brain is healing.")
        case 7...13:  return ("⚡", "Energy Surge",     "Testosterone rising. You may feel sharper and more energised.")
        case 14...29: return ("🌤", "Fog Lifting",      "Prefrontal cortex activity increasing. Better focus and decisions.")
        case 30...59: return ("🔗", "Deep Rewiring",    "Neural pathways rebuilding. Brain unlearning the addiction at its roots.")
        case 60...89: return ("🧠", "New Baseline",     "Dopamine system approaching healthy. Energy and clarity are your new normal.")
        default:       return ("🚀", "Fully Rewired",   "You've rebuilt your brain's reward system. Operating at full potential.")
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {

                // Brain status
                VStack(alignment: .leading, spacing: 14) {
                    Label("BRAIN STATUS — DAY \(vm.currentDays)", systemImage: "brain")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .tracking(2)
                        .foregroundColor(.cyan)

                    HStack(alignment: .top, spacing: 14) {
                        Text(brainInfo.icon).font(.system(size: 40))
                        VStack(alignment: .leading, spacing: 6) {
                            Text(brainInfo.title)
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text(brainInfo.body)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.72))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.cardDark)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.cyan.opacity(0.35), lineWidth: 1)
                        )
                )

                // Stat grid
                Text("YOUR NUMBERS")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .tracking(5)
                    .foregroundColor(.gray.opacity(0.6))

                LazyVGrid(columns: cols, spacing: 12) {
                    StatTile(label: "Current Streak",  value: "\(vm.currentDays)",               unit: "days",   icon: "flame.fill",             color: .orange1)
                    StatTile(label: "Best Streak",     value: "\(vm.data.longestStreak)",         unit: "days",   icon: "trophy.fill",            color: .gold1)
                    StatTile(label: "Total Resets",    value: "\(vm.data.totalResets)",           unit: "times",  icon: "arrow.counterclockwise", color: .red)
                    StatTile(label: "Badges Earned",   value: "\(vm.unlockedBadges.count)/\(allBadges.count)", unit: "", icon: "star.fill",  color: Color(hex: "9C27B0"))
                    StatTile(label: "Points",          value: "\(vm.data.points)",                unit: "pts",    icon: "bolt.fill",              color: .cyan)
                    StatTile(label: "Months Clean",    value: "\(vm.displayMonths + vm.displayYears * 12)", unit: "mos", icon: "calendar", color: Color(hex: "4CAF50"))
                }

                // Journey milestones
                Text("JOURNEY MAP")
                    .font(.system(size: 11, weight: .black, design: .rounded))
                    .tracking(5)
                    .foregroundColor(.gray.opacity(0.6))

                VStack(spacing: 0) {
                    let milestones: [(Int, String, String)] = [
                        (1,   "🌱", "First sunrise"),
                        (3,   "🔥", "3-day spark"),
                        (7,   "⚡", "One week"),
                        (14,  "🌊", "Two weeks"),
                        (30,  "👑", "30 days"),
                        (60,  "🦁", "60 days"),
                        (90,  "🌟", "90 days"),
                        (180, "🚀", "6 months"),
                        (365, "🏆", "1 year"),
                    ]

                    ForEach(Array(milestones.enumerated()), id: \.offset) { index, step in
                        let done = vm.currentDays >= step.0
                        let isLast = index == milestones.count - 1

                        HStack(spacing: 16) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(done ? Color.orange1.opacity(0.3) : Color.white.opacity(0.05))
                                        .frame(width: 38, height: 38)
                                    Text(done ? step.1 : "🔒")
                                        .font(.system(size: done ? 18 : 14))
                                        .grayscale(done ? 0 : 1)
                                        .opacity(done ? 1 : 0.3)
                                }
                                if !isLast {
                                    Rectangle()
                                        .fill(done ? Color.orange1.opacity(0.4) : Color.white.opacity(0.07))
                                        .frame(width: 2, height: 26)
                                }
                            }
                            HStack {
                                Text(step.2)
                                    .font(.system(size: 14, weight: done ? .bold : .regular, design: .rounded))
                                    .foregroundColor(done ? .white : .gray.opacity(0.4))
                                Spacer()
                                Text("\(step.0)d")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(done ? .orange1 : .gray.opacity(0.3))
                            }
                            .padding(.bottom, isLast ? 0 : 26)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.white.opacity(0.07), lineWidth: 1)
                        )
                )

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
    }
}

struct StatTile: View {
    let label: String
    let value: String
    let unit:  String
    let icon:  String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                }
                Text(label)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Celebration
// ─────────────────────────────────────────────────────────────────────────────

struct CelebrationView: View {
    let badge:     Badge
    let onDismiss: () -> Void

    @State private var scale:   CGFloat = 0.4
    @State private var opacity: Double  = 0
    @State private var glow             = false
    @State private var confetti: [ConfettiItem] = []

    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            // Confetti
            ForEach(confetti) { item in
                Text(item.symbol)
                    .font(.system(size: item.size))
                    .position(item.pos)
                    .opacity(item.alpha)
                    .rotationEffect(.degrees(item.angle))
            }

            // Card
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(hex: badge.colorHex).opacity(glow ? 0.35 : 0.1))
                        .frame(width: 100, height: 100)
                        .blur(radius: glow ? 28 : 12)
                    Text(badge.emoji).font(.system(size: 60))
                }

                VStack(spacing: 8) {
                    Text("BADGE UNLOCKED")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .tracking(5)
                        .foregroundColor(Color(hex: badge.colorHex))
                    Text(badge.name)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text(badge.subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.65))
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill").foregroundColor(.gold1)
                        Text("+\(badge.points) points")
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .foregroundColor(.gold1)
                    }
                }

                Button(action: onDismiss) {
                    Text("CLAIM REWARD")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .tracking(2)
                        .foregroundColor(.black)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: badge.colorHex), .gold1],
                                startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.bgDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(Color(hex: badge.colorHex).opacity(0.7), lineWidth: 2)
                    )
            )
            .scaleEffect(scale)
            .opacity(opacity)
            .padding(28)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale   = 1
                opacity = 1
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glow = true
            }
            buildConfetti()
        }
    }

    private func buildConfetti() {
        let symbols = ["⭐", "🔥", "✨", "🏆", "💪", "🌟", "🎉", badge.emoji]
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        confetti = (0..<30).map { _ in
            ConfettiItem(
                symbol: symbols.randomElement()!,
                pos:    CGPoint(x: .random(in: 0...w), y: .random(in: 0...h)),
                size:   .random(in: 16...38),
                alpha:  .random(in: 0.5...1),
                angle:  .random(in: 0...360)
            )
        }
    }
}

struct ConfettiItem: Identifiable {
    let id     = UUID()
    let symbol: String
    let pos:    CGPoint
    let size:   CGFloat
    let alpha:  Double
    let angle:  Double
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: – Preview
// ─────────────────────────────────────────────────────────────────────────────

#Preview {
    MainAppView()
}
