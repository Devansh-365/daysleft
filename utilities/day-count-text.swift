import Foundation

/// User-facing wording for day counts, with correct singular/plural forms.
enum DayCountText {
    /// "1 day", "2 days", "0 days".
    static func days(_ count: Int) -> String {
        count == 1 ? "1 day" : "\(count) days"
    }

    /// "1 day left in the year", "53 days left in the month".
    static func left(_ count: Int, in period: Period) -> String {
        "\(days(count)) left in the \(period.rawValue)"
    }

    enum Period: String {
        case year, quarter, month, week
    }
}

/// How the days-left number appears in the menu bar. VoiceOver always reads the full sentence.
enum MenuBarFormat: String, CaseIterable, Identifiable {
    /// "53d" (default)
    case compact
    /// "53 days"
    case words
    /// "53"
    case number

    static let `default`: MenuBarFormat = .compact

    var id: String { rawValue }

    func text(for count: Int) -> String {
        switch self {
        case .compact: return "\(count)d"
        case .words: return DayCountText.days(count)
        case .number: return "\(count)"
        }
    }
}
