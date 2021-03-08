//
//  AppDelegate.swift
//  DockTerm
//
//  Created by Carson Katri on 3/8/21.
//

import Cocoa
import SwiftUI
import Combine

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    @ObservedObject var terminal = Terminal()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.borderless],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("DockTerm")
        window.makeKeyAndOrderFront(nil)
        window.level = NSWindow.Level.floating
        
        let dockTile = DockTile().environmentObject(terminal)
        NSApp.dockTile.contentView = NSHostingView(rootView: dockTile)
        NSApp.dockTile.display()
        
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
            if event.specialKey != nil {
                switch event.keyCode {
                case 51: _ = self?.terminal.input.popLast()
                case 36: self?.terminal.execute()
                default: print(event.keyCode)
                }
            } else if let characters = event.characters {
                self?.terminal.input += characters
            }
            return event
        }
        
//        NSEvent.addGlobalMonitorForEvents(
//            matching: [NSEvent.EventTypeMask.keyDown, NSEvent.EventTypeMask.keyUp, NSEvent.EventTypeMask.flagsChanged],
//            handler: { (event: NSEvent) in
//                switch event.type {
//                case .keyDown:
//                  print(String(format: "keyDown %d", event.keyCode))
//                case .keyUp:
//                  print(String(format: "keyUp %d", event.keyCode))
//                case .flagsChanged:
//                  print(String(format: "flagsChanged %d", event.keyCode))
//                default:
//                  break
//                }
//            }
//        )
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        terminal.isFocused = false
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        terminal.isFocused = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

final class Terminal: ObservableObject {
    @Published var isFocused = true {
        didSet {
            NSApp.dockTile.display()
        }
    }
    
    @Published var input = "" {
        didSet {
            output = nil
            NSApp.dockTile.display()
        }
    }
    @Published var output: String? {
        didSet {
            NSApp.dockTile.display()
        }
    }
    
    @Published var shouldFlash = true
    @Published var isShown = false
    var flashTimer: AnyCancellable?
    
    init() {
        flashTimer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard self?.shouldFlash == true && self?.isFocused == true else { return }
                self?.isShown.toggle()
                NSApp.dockTile.display()
            }
    }
    
    func execute() {
        let p = Process()
        p.currentDirectoryPath = FileManager.default.currentDirectoryPath
        p.launchPath = ProcessInfo.processInfo.environment["SHELL"]
        p.arguments = ["-c", input, ""]
        input = ""
        let out = Pipe()
        p.standardOutput = out
        p.standardError = out
        p.launch()
        p.waitUntilExit()
        output = String(data: out.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? "Error"
    }
}
