//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml

struct ApplePwaMetaContext {
    let title: String
}

struct ApplePwaMetaTemplate: TemplateRepresentable {
    let context: ApplePwaMetaContext
    
    init(_ context: ApplePwaMetaContext) {
        self.context = context
    }
    
    func render(_ req: Request) -> Tag {
        Meta()
            .name(.appleMobileWebAppTitle)
            .content(context.title)
        Meta()
            .name(.appleMobileWebAppCapable)
            .content("yes")
        Meta()
            .name(.appleMobileWebAppStatusBarStyle)
            .content("default")
        
        icon()
        for i in [57, 72, 76, 114, 120, 144, 152, 180] {
            icon(i)
        }
        splash(320, 568, 2, .landscape)
        splash(320, 568, 2, .portrait)
        splash(414, 896, 3, .landscape)
        splash(414, 896, 2, .landscape)
        splash(375, 812, 3, .portrait)
        splash(414, 896, 2, .portrait)
        splash(375, 812, 3, .landscape)
        splash(414, 736, 3, .portrait)
        splash(414, 736, 3, .landscape)
        splash(375, 667, 2, .landscape)
        splash(375, 667, 2, .portrait)
        splash(1024, 1366, 2, .landscape)
        splash(1024, 1366, 2, .portrait)
        splash(834, 1194, 2, .landscape)
        splash(834, 1194, 2, .portrait)
        splash(834, 1112, 2, .landscape)
        splash(414, 896, 3, .portrait)
        splash(834, 1112, 2, .portrait)
        splash(768, 1024, 2, .portrait)
        splash(768, 1024, 2, .landscape)
    }
}

private extension ApplePwaMetaTemplate {

    func calc(_ width: Int,
                      _ height: Int,
                      _ ratio: Int,
                      _ orientation: MediaQuery.Orientation) -> String {
        let w = String(width * ratio)
        let h = String(height * ratio)
        switch orientation {
        case .portrait:
            return w + "x" + h
        case .landscape:
            return h + "x" + w
        }
    }
    
    func splashTag(_ mode: MediaQuery.ColorScheme,
                           _ width: Int,
                           _ height: Int,
                           _ ratio: Int,
                           _ orientation: MediaQuery.Orientation) -> Tag {
        Link(rel: .appleTouchStartupImage)
            .media([
                .prefersColorScheme(mode),
                .deviceWidth(px: width),
                .deviceHeight(px: height),
                .webkitDevicePixelRatio(ratio),
                .orientation(orientation),
            ])
            .href("/img/web/apple/splash/\(calc(width, height, ratio, orientation))\(mode == .light ? "" : "_dark").png")
    }

    @TagBuilder
    func splash(_ width: Int,
                        _ height: Int,
                        _ ratio: Int,
                        _ orientation: MediaQuery.Orientation) -> Tag {
        splashTag(.light, width, height, ratio, orientation)
        splashTag(.dark, width, height, ratio, orientation)
    }

    func icon(_ size: Int? = nil) -> Tag {
        let link = Link(rel: .appleTouchIcon)
        if let size = size {
            return link
                .sizes("\(size)x\(size)")
                .href("/img/web/apple/icons/\(size).png")
        }
        return link
            .href("/img/web/apple/192.png")
    }
}
