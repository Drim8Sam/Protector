import SwiftUI
import AppKit
import UniformTypeIdentifiers     // DetailViewModel

struct DetailView: View {
    @StateObject private var vm = DetailViewModel()
    let fileInfos: [FileInfo]  // передается из MainView

    var body: some View {
        VStack {
            // Таблица уязвимостей
            Table(vm.vulnerabilities) {
                TableColumn("Файл", value: \.file)
                TableColumn("Тип проблемы", value: \.type)
                TableColumn("Строка") { v in Text(String(v.line)) }
            }
            .onAppear {
                Task { await vm.analyze(fileInfos) }
            }

            HStack {
                Button("Сохранить отчёт JSON") {
                    let url = savePanelURL(suffix: "json")
                    vm.saveJSON(to: url)
                }
                Button("Сохранить CSV") {
                    let url = savePanelURL(suffix: "csv")
                    vm.saveCSV(to: url)
                }
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 600)
    }

    private func savePanelURL(suffix: String) -> URL {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType.json, UTType.commaSeparatedText]
        panel.nameFieldStringValue = "report.\(suffix)"
        let _ = panel.runModal()
        return panel.url!
    }
}
