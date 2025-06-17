import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // Поисковая строка
            TextField("Поиск...", text: $viewModel.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Кнопка выбора директории
            Button("Выбрать директорию проекта") {
                viewModel.chooseDirectory()
            }
            .padding(.horizontal)

            HStack(spacing: 20) {
                // Загрузка последнего отчёта
                Button("Загрузить последний отчёт") {
                    viewModel.loadLastReport()
                }
                // Запуск анализа
                Button("Запустить анализ") {
                    viewModel.runAnalysis()
                }
            }
            .padding(.horizontal)

            // При желании – превью списка найденных файлов
            List(viewModel.filteredFileSummaries) { file in
                Text(file.path)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

