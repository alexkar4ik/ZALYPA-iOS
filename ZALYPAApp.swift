import SwiftUI

@main
struct ZALYPAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @State private var glow = true
    @State private var particles = true
    @State private var sound = false
    @State private var intensity = 72.0
    @State private var selectedTab = 0
    @State private var pulse = false

    private let red = Color(red: 1.0, green: 0.08, blue: 0.12)

    var body: some View {
        ZStack {
            Color(red: 0.025, green: 0.025, blue: 0.035).ignoresSafeArea()

            if particles {
                GeometryReader { proxy in
                    ForEach(0..<22, id: \.self) { i in
                        Circle()
                            .fill(red.opacity(i.isMultiple(of: 3) ? 0.35 : 0.12))
                            .frame(width: i.isMultiple(of: 4) ? 4 : 2)
                            .position(
                                x: CGFloat((i * 47 + 19) % max(Int(proxy.size.width), 1)),
                                y: CGFloat((i * 83 + 31) % max(Int(proxy.size.height), 1))
                            )
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    hero
                    tabBar

                    if selectedTab == 0 {
                        controls
                    } else if selectedTab == 1 {
                        infoPanel
                    } else {
                        aboutPanel
                    }

                    Text("FAN-MADE UI • НЕ МОДИФИЦИРУЕТ ИГРУ")
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .tracking(1.8)
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(.top, 4)
                        .padding(.bottom, 22)
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
            }
        }
        .tint(red)
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(red.opacity(0.16))
                        .frame(width: 36, height: 36)
                    Image(systemName: "scope")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(red)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("ZALYPA")
                        .font(.system(size: 17, weight: .black, design: .rounded))
                        .tracking(2.2)
                    Text("TACTICAL INTERFACE")
                        .font(.system(size: 8, weight: .medium, design: .monospaced))
                        .tracking(1.3)
                        .foregroundStyle(.white.opacity(0.42))
                }
            }
            Spacer()
            HStack(spacing: 5) {
                Circle().fill(Color.green).frame(width: 6, height: 6)
                Text("READY")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(1)
            }
            .foregroundStyle(.white.opacity(0.8))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.white.opacity(0.05), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1))
        }
    }

    private var hero: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.20, green: 0.025, blue: 0.045),
                                 Color(red: 0.075, green: 0.025, blue: 0.04),
                                 Color(red: 0.045, green: 0.045, blue: 0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            GeometryReader { geo in
                Path { path in
                    for x in stride(from: 0.0, through: geo.size.width + 80, by: 22) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x - 100, y: geo.size.height))
                    }
                }
                .stroke(.white.opacity(0.035), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Circle()
                .fill(red.opacity(glow ? (pulse ? 0.18 : 0.08) : 0.02))
                .frame(width: 180, height: 180)
                .blur(radius: 28)
                .offset(x: 210, y: -20)

            VStack(alignment: .leading, spacing: 12) {
                Text("PRIVATE BUILD  /  IOS")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(2)
                    .foregroundStyle(red)
                Text("OWN YOUR\nSTYLE.")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .tracking(-1.2)
                    .lineSpacing(-3)
                    .foregroundStyle(.white)
                Text("ТВОЁ МЕНЮ. ТВОИ ПРАВИЛА.")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.5))
                HStack(spacing: 7) {
                    Image(systemName: "iphone")
                    Text("DESIGNED FOR IPHONE")
                }
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.75))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(.black.opacity(0.25), in: Capsule())
            }
            .padding(22)
        }
        .frame(height: 230)
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(red.opacity(0.32), lineWidth: 1))
        .shadow(color: red.opacity(glow ? 0.12 : 0), radius: 22)
    }

    private var tabBar: some View {
        HStack(spacing: 7) {
            tabButton("SLIDERS", icon: "slider.horizontal.3", index: 0)
            tabButton("STATUS", icon: "waveform.path", index: 1)
            tabButton("ABOUT", icon: "info.circle", index: 2)
        }
        .padding(5)
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.07), lineWidth: 1))
    }

    private func tabButton(_ title: String, icon: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 9, weight: .bold, design: .monospaced))
            .tracking(0.6)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(selectedTab == index ? .white : .white.opacity(0.42))
            .background {
                if selectedTab == index {
                    RoundedRectangle(cornerRadius: 11).fill(red.opacity(0.85))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var controls: some View {
        VStack(spacing: 12) {
            sectionHeading("VISUAL MODULES", detail: "03 MODULES")
            toggleCard(
                title: "RED GLOW",
                subtitle: "Неоновое свечение интерфейса",
                icon: "sparkles",
                isOn: $glow
            )
            toggleCard(
                title: "PARTICLE FIELD",
                subtitle: "Декоративные фоновые точки",
                icon: "circle.hexagongrid",
                isOn: $particles
            )
            toggleCard(
                title: "UI SOUND",
                subtitle: "Звуковые эффекты пока отключены",
                icon: "speaker.wave.2",
                isOn: $sound
            )

            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Label("EFFECT INTENSITY", systemImage: "dial.low")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(0.5)
                    Spacer()
                    Text("\(Int(intensity))%")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .foregroundStyle(red)
                }
                Slider(value: $intensity, in: 0...100, step: 1)
                HStack {
                    Text("SUBTLE")
                    Spacer()
                    Text("MAXIMUM")
                }
                .font(.system(size: 8, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.32))
            }
            .padding(17)
            .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 17))
            .overlay(RoundedRectangle(cornerRadius: 17).stroke(.white.opacity(0.08), lineWidth: 1))
        }
    }

    private var infoPanel: some View {
        VStack(spacing: 12) {
            sectionHeading("SYSTEM STATUS", detail: "LIVE PREVIEW")
            statusRow("Interface", value: "ONLINE", color: .green)
            statusRow("Game connection", value: "NOT CONNECTED", color: .orange)
            statusRow("Visual engine", value: glow ? "GLOW ACTIVE" : "GLOW OFF", color: red)
            statusRow("Background FX", value: particles ? "ACTIVE" : "DISABLED", color: red)
            Text("Это демонстрационный экран состояния. Приложение не подключается к Standoff 2.")
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.48))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private var aboutPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("ABOUT ZALYPA", detail: "BUILD 1.0")
            Text("Тёмный мобильный UI-прототип с красной подсветкой и тактической эстетикой.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
            Text("Все переключатели изменяют только визуальное оформление этого приложения. Здесь нет читов, автоматического прицеливания, вмешательства в память игры или обхода защиты.")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.48))
            Button {
                selectedTab = 0
            } label: {
                Label("OPEN CONTROLS", systemImage: "arrow.left")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .tracking(1)
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(red, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .padding(17)
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(.white.opacity(0.08), lineWidth: 1))
    }

    private func sectionHeading(_ title: String, detail: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .tracking(1.3)
            Spacer()
            Text(detail)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(red.opacity(0.85))
        }
        .padding(.bottom, 2)
    }

    private func toggleCard(title: String, subtitle: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 13) {
            RoundedRectangle(cornerRadius: 12)
                .fill(red.opacity(isOn.wrappedValue ? 0.16 : 0.06))
                .frame(width: 43, height: 43)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(isOn.wrappedValue ? red : .white.opacity(0.35))
                }
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .tracking(0.8)
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.42))
            }
            Spacer(minLength: 4)
            Toggle(title, isOn: isOn)
                .labelsHidden()
                .scaleEffect(0.82, anchor: .trailing)
        }
        .padding(13)
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isOn.wrappedValue ? red.opacity(0.22) : .white.opacity(0.07), lineWidth: 1))
    }

    private func statusRow(_ title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.58))
            Spacer()
            Text(value)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
        }
        .padding(15)
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 13))
    }
}
