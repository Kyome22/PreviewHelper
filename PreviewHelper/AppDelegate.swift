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
            if FIFinderSyncController.isExtensionEnabled {
                NSApplication.shared.terminate(self)
            } else {
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.informativeText = "ExtensionInformative".localized
                alert.messageText = "ExtensionMessage".localized
                alert.addButton(withTitle: "openSystemPreferences".localized)
                alert.addButton(withTitle: "cancel".localized)
                if alert.runModal() == .alertFirstButtonReturn {
                    FIFinderSyncController.showExtensionManagementInterface()
                    NSApplication.shared.terminate(self)
                }
            }
        }
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
