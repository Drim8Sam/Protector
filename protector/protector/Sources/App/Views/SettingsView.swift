import SwiftUI
import AppViewModels

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        Form {
            Toggle("Показывать только высокий уровень", isOn: $vm.settings.showHighSeverityOnly)
                .onChange(of: vm.settings.showHighSeverityOnly) { _ in vm.save() }

            if let url = vm.settings.lastProjectURL {
                Text("Последний проект: \(url.path)")
            }
        }
        .padding()
        .frame(width: 300)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
