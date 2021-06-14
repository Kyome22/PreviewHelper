//
//  FinderSync.swift
//  Canvas
//
//  Created by Takuto Nakamura on 2020/10/27.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    override init() {
        super.init()

        FIFinderSyncController.default()
            .directoryURLs = [URL(fileURLWithPath: "/")]
    }

    // MARK: - Menu and toolbar item support
    override func menu(for menu: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "")
        let item = NSMenuItem(title: "openNewCanvas".localized,
                              action: #selector(FinderSync.newCanvas(_:)),
                              keyEquivalent: "")
        if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.kyome.PreviewHelper") {
            item.image = NSWorkspace.shared.icon(forFile: url.path)
        }
        menu.addItem(item)
        return menu
    }

    @IBAction func newCanvas(_ sender: AnyObject?) {
        guard let target = FIFinderSyncController.default().targetedURL(),
              let attributesView = self.createAttributesView()
        else { return }
        NSApp.activate(ignoringOtherApps: true)
        DispatchQueue.main.async {
            let panel = NSSavePanel()
            panel.directoryURL = target
            panel.canCreateDirectories = true
            panel.allowedFileTypes = ["png"]
            panel.showsTagField = false
            panel.title = "newCanvas".localized
            panel.message = "createCanvas".localized
            panel.level = .popUpMenu
            panel.prompt = "saveOpen".localized
            panel.accessoryView = attributesView
            panel.begin { (response) in
                if response == .OK, let url = panel.url {
                    let size = attributesView.size
                    let fillColor = attributesView.fillColor
                    guard let data = self.createCanvas(size, fillColor) else { return }
                    do {
                        try data.write(to: url)
                        NSWorkspace.shared.openFile(url.path, withApplication: "Preview")
                    } catch {
                        Swift.print(error.localizedDescription)
                    }
                }
            }
        }
    }

    private func createAttributesView() -> AttributesView? {
        var topLevelArray: NSArray? = nil
        guard let nib = NSNib(nibNamed: "AttributesView", bundle: Bundle.main),
              nib.instantiate(withOwner: nil, topLevelObjects: &topLevelArray),
              let results = topLevelArray as? [Any],
              let item = results.last(where: { $0 is AttributesView }),
              let attributesView = item as? AttributesView
        else { return nil }
        return attributesView
    }

    private func createCanvas(_ size: NSSize, _ fillColor: NSColor) -> Data? {
        let image = NSImage(size: size)
        image.lockFocus()
        fillColor.drawSwatch(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        guard let rep = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: rep),
              let data = bitmap.representation(using: .png, properties: [:])
        else { return nil }
        return data
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
