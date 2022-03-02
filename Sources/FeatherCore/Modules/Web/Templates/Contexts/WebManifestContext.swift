//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 21..
//

/// https://web.dev/add-manifest/
struct WebManifestContext: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
        case startUrl = "start_url"
        case display
        case themeColor = "theme_color"
        case backgroundColor = "background_color"
        case icons
        case shortcuts
    }
    
    enum Display: String, Codable {
        /// Opens the web application without any browser UI and takes up the entirety of the available display area.
        case fullscreen
        /// Opens the web app to look and feel like a standalone app.
        /// The app runs in its own window, separate from the browser, and hides standard browser UI elements like the URL bar.
        case standalone
        /// This mode is similar to standalone, but provides the user a minimal set of UI elements for controlling navigation (such as back and reload).
        case minimalUI = "minimal-ui"
        /// A standard browser experience.
        case browser
    }
    
    struct Icon: Codable {
        let src: String
        let sizes: String
        let type: String
    }
    
    struct Shortcut: Codable {
        enum CodingKeys: String, CodingKey {
            case name
            case shortName = "short_name"
            case description
            case url
            case icons
        }
        
        let name: String
        let shortName: String
        let description: String
        let url: String
        let icons: [Icon]
    }

    let shortName: String
    let name: String
    let startUrl: String
    let themeColor: String
    let backgroundColor: String
    let display: Display
    let icons: [Icon]
    let shortcuts: [Shortcut]
}
