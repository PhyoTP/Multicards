import SwiftUI
import Translation

struct TranslateView: View {
    @State private var languages: [Locale.Language]?
    @State private var sourceLanguage: Locale.Language?
    @State private var targetLanguage: Locale.Language?
    var columns: [Column]
    @Binding var targetColumn: Column
    @State private var sourceColumn = Column(name: "", values: [])
    @Environment(\.dismiss) var dismiss
    @State private var configuration: TranslationSession.Configuration?
    @State private var isConverting = false
    @State private var doneCount = 0.0
    var body: some View {
        ZStack{
            
            Form {
                if let langs = languages {
                    Picker("Translate from", selection: $sourceLanguage) {
                        Text("Auto-detect").tag(Locale.Language?.none)
                        ForEach(langs, id: \.self) { language in
                            Text(language.localizedName).tag(language as Locale.Language?)
                        }
                    }
                    Picker("Translate to", selection: $targetLanguage) {
                        Text("Auto-detect").tag(Locale.Language?.none)
                        ForEach(langs, id: \.self) { language in
                            Text(language.localizedName).tag(language as Locale.Language?)
                        }
                    }
                }
                Picker("Source side:", selection: $sourceColumn){
                    ForEach(columns){column in
                        Text(column.name).tag(column)
                    }
                }
                Button("Translate") {
                    
                    configuration = TranslationSession.Configuration(source: sourceLanguage, target: targetLanguage)
                }
                .disabled(isConverting)
            }
            .onAppear {
                print(targetColumn)
                sourceColumn = columns[0]
                Task {
                    let avail = LanguageAvailability()
                    languages = await avail.supportedLanguages
                }
            }
            .translationTask(configuration){session in
                Task { @MainActor in
                    do {
                        isConverting = true
                        for index in sourceColumn.values.indices{
                            let response = try await session.translate(sourceColumn.values[index])
                            targetColumn.values[index] = response.targetText
                            doneCount += 1
                        }
                        print("works")
                    } catch {
                        print("Couldn't translate:", error)
                    }
                    isConverting = false
                    dismiss()
                }
            }
            .unifiedBackground()
            if isConverting{
                ProgressView(value: doneCount, total: Double(targetColumn.values.count))
            }
        }
    }
}


extension Locale.Language {
    var localizedName: String {
        let locale = Locale.current
        let languageCode = self.languageCode?.identifier ?? ""
        return locale.localizedString(forLanguageCode: languageCode) ?? languageCode
    }
}

