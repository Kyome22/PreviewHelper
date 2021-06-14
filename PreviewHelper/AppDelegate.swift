//
//  AppDelegate.swift
//  PreviewHelper
//
//  Created by Takuto Nakamura on 2020/10/26.
//

import Cocoa
import FinderSync

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            if FIFinderSyncController.isExtensionEnabled {
                alert.alertStyle = .informational
                alert.informativeText = "AlreadyInformative".localized
                alert.addButton(withTitle: "OK")
            } else {
                alert.alertStyle = .warning
                alert.informativeText = "ExtensionInformative".localized
                alert.messageText = "ExtensionMessage".localized
                alert.addButton(withTitle: "openSystemPreferences".localized)
                alert.addButton(withTitle: "cancel".localized)
            }
            if alert.runModal() == .alertFirstButtonReturn {
                FIFinderSyncController.showExtensionManagementInterface()
                NSApplication.shared.terminate(nil)
            }
        }
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
