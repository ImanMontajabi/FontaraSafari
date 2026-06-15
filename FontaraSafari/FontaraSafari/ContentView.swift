import SwiftUI
import SafariServices

// MARK: - Extension bundle identifier
// Replace this constant with your actual extension target's bundle ID.
// Format: <your-app-bundle-id>.extension
private let extensionBundleIdentifier = "com.imanmontajabi.FontaraSafari.extension"

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var viewModel = ExtensionViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection
            Divider()
            statusSection
            Divider()
            instructionsSection
            Divider()
            footerSection
        }
        .frame(width: 420)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { viewModel.checkExtensionState() }
    }

    // MARK: – Header

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 48, height: 48)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text("فونت‌آرا")
                    .font(.title2.bold())
                Text("تغییر‌دهنده فونت فارسی برای Safari")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: – Status

    private var statusSection: some View {
        HStack {
            Label {
                Text("وضعیت افزونه")
                    .font(.body)
            } icon: {
                Image(systemName: viewModel.isEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(viewModel.isEnabled ? Color.green : Color.orange)
            }

            Spacer()

            if viewModel.isEnabled {
                Text("فعال")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.green)
            } else {
                Text("غیرفعال")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: – Instructions

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.isEnabled {
                instructionRow(
                    step: "۱",
                    text: "روی دکمه زیر کلیک کنید تا ترجیحات Safari باز شود."
                )
                instructionRow(
                    step: "۲",
                    text: "در بخش Extensions، تیک کنار FontAra را بزنید."
                )
                instructionRow(
                    step: "۳",
                    text: "مجوز دسترسی به وب‌سایت‌های مورد نظر را تأیید کنید."
                )
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.blue)
                    Text("افزونه در Safari فعال است. آیکون 𝖥 را در نوار آدرس Safari پیدا کنید تا تنظیمات را باز کنید.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private func instructionRow(step: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(step)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(Color.accentColor)
                .clipShape(Circle())
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: – Footer

    private var footerSection: some View {
        HStack {
            Button(action: viewModel.openSafariExtensionPreferences) {
                Label(
                    viewModel.isEnabled ? "باز کردن ترجیحات Safari" : "فعال کردن در Safari",
                    systemImage: "safari"
                )
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)

            Spacer()

            Button("بستن") {
                NSApp.terminate(nil)
            }
            .controlSize(.large)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// MARK: - ViewModel

@MainActor
final class ExtensionViewModel: ObservableObject {
    @Published private(set) var isEnabled = false
    @Published private(set) var errorMessage: String? = nil

    func checkExtensionState() {
        SFSafariExtensionManager.getStateOfSafariExtension(
            withIdentifier: extensionBundleIdentifier
        ) { [weak self] state, error in
            DispatchQueue.main.async {
                if let error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                self?.isEnabled = state?.isEnabled ?? false
            }
        }
    }

    func openSafariExtensionPreferences() {
        SFSafariApplication.showPreferencesForExtension(
            withIdentifier: extensionBundleIdentifier
        ) { [weak self] error in
            DispatchQueue.main.async {
                if error != nil {
                    // Preferences couldn't open – re-check extension state
                    self?.checkExtensionState()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
