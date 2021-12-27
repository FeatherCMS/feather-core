//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftCss

public struct StyleTemplate: CssRepresentable {

    public init() {
        
    }

    @RuleBuilder
    public func rules(_ req: Request) -> [Rule] {
        Media {
            Root {
                Variable("test", "1rem")
            }
        }
//        Media {
//            Root {
//                Variable("scale", "1rem")
//
//                Variable("bg-color", "#fff")
//                Variable("text-color", "#333")
//            }
//        }
//        Media(screen: .xs) {
//            Root {
//                Variable("scale", "1rem")
//            }
//        }
//        Media(screen: .s) {
//            Root {
//                Variable("scale", "1rem")
//            }
//        }
//        Media(screen: .normal) {
//            Root {
//                Variable("scale", "1rem")
//            }
//        }
//        Media(screen: .l) {
//            Root {
//                Variable("scale", "1rem")
//            }
//
//        }
//        Media(screen: .xl) {
//            Root {
//                Variable("scale", "1rem")
//            }
//        }
//        Media(screen: .dark) {
//            Root {
//                Variable("bg-color", "#000")
//                Variable("text-color", "#c9c9c9")
//            }
//        }
//
//        Media {
//            All {
//                Margin(.zero)
//                Padding(.zero)
//            }
//            Html {
//                FontSize("scale".variable)
//            }
//            Body {
//                BackgroundColor("bg-color".variable)
//                Color("text-color".variable)
//            }
//            Main {
//                Padding(horizontal: 2.rem, vertical: 4.rem)
//            }
//            Img {
//                Width(320.px)
//            }
//        }
    }
}


