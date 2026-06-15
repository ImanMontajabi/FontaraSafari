import SafariServices
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "FontaraSafari", category: "Extension")

/// Handles messages sent from the JavaScript layer via browser.runtime.sendNativeMessage().
/// For Fontara, the extension handles all logic in JavaScript; this handler is kept minimal
/// as a required stub for the App Store target.
class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        guard
            let item = context.inputItems.first as? NSExtensionItem,
            let userInfo = item.userInfo as? [String: Any],
            let message = userInfo[SFExtensionMessageKey]
        else {
            context.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        logger.log("Received message from extension JS layer: \(String(describing: message), privacy: .public)")

        // Echo back a minimal acknowledgment. The extension's full logic runs
        // in JavaScript; native messaging is only used if you add Swift-side
        // features (e.g., reading macOS system fonts via CTFontManager).
        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: ["status": "ok"]]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
