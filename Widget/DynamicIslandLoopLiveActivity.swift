import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicIslandLoopLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIslandLoopAttributes.self) { context in
            // Vista sulla Lock Screen / notifiche banner
            LockScreenView(startedAt: context.state.startedAt)
                .activityBackgroundTint(Color.black)
                .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Stato espanso (quando l'utente tiene premuto sulla Dynamic Island)
                DynamicIslandExpandedRegion(.center) {
                    Waveform(startedAt: context.state.startedAt, barCount: 13, maxBarHeight: 28)
                        .padding(.horizontal, 8)
                }
            } compactLeading: {
                // Versione ridotta nello stato compatto (poco spazio disponibile)
                Waveform(startedAt: context.state.startedAt, barCount: 5, maxBarHeight: 14)
            } compactTrailing: {
                EmptyView()
            } minimal: {
                // Stato "minimal" (quando ci sono più Live Activity insieme)
                Waveform(startedAt: context.state.startedAt, barCount: 3, maxBarHeight: 12)
            }
        }
    }
}

/// L'equalizzatore animato, stile barre audio in chiamata: verde a sinistra
/// che sfuma verso giallo/arancio a destra, fino a diventare puntini.
/// Usa TimelineView(.animation) per farsi ridisegnare in continuazione dal
/// sistema, calcolando la fase dalla data di inizio + il tempo corrente:
/// nessun aggiornamento manuale necessario, gira anche ad app chiusa.
private struct Waveform: View {
    let startedAt: Date
    let barCount: Int
    let maxBarHeight: CGFloat

    // Altezza "a riposo" di ogni barra, decrescente verso destra (come nella foto)
    private var restHeights: [CGFloat] {
        (0..<barCount).map { i in
            let t = CGFloat(i) / CGFloat(max(barCount - 1, 1))
            return max(0.15, 1.0 - pow(t, 1.3))
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startedAt)

            HStack(alignment: .center, spacing: max(2, maxBarHeight * 0.08)) {
                ForEach(0..<barCount, id: \.self) { i in
                    let rest = restHeights[i]
                    // Ogni barra oscilla con una fase leggermente diversa,
                    // per dare l'effetto "audio reale" invece che sincronizzato.
                    let phase = elapsed * 4.5 + Double(i) * 0.9
                    let wobble = 0.5 + 0.5 * sin(phase)
                    let height = maxBarHeight * rest * (0.35 + 0.65 * wobble)
                    let isDot = rest < 0.22
                    let barWidth = max(2.5, maxBarHeight * 0.11)

                    Capsule()
                        .fill(barColor(for: i))
                        .frame(width: barWidth,
                               height: isDot ? barWidth : max(barWidth, height))
                }
            }
        }
    }

    /// Verde acceso (indice 0) che sfuma verso giallo/arancio (ultimo indice).
    private func barColor(for index: Int) -> Color {
        let t = Double(index) / Double(max(barCount - 1, 1))
        return Color(hue: 0.33 - 0.20 * t, saturation: 0.9, brightness: 1.0)
    }
}

private struct LockScreenView: View {
    let startedAt: Date

    var body: some View {
        HStack {
            Waveform(startedAt: startedAt, barCount: 13, maxBarHeight: 30)
            Spacer()
        }
        .padding()
    }
}
