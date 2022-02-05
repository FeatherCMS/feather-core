//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 04..
//

extension Icons {
    
    @TagBuilder
    var tags: [Tag] {
        switch self {
        case .columns:
            Path("M12 3h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7m0-18H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7m0-18v18")
        case .underline:
            Path("M6 3v7a6 6 0 0 0 6 6 6 6 0 0 0 6-6V3")
            Line(x1: 4, y1: 21, x2: 20, y2: 21)
        case .grid:
            Rect(x: 3, y: 3, width: 7, height: 7)
            Rect(x: 14, y: 3, width: 7, height: 7)
            Rect(x: 14, y: 14, width: 7, height: 7)
            Rect(x: 3, y: 14, width: 7, height: 7)
        case .triangle:
            Path("M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z")
        case .search:
            Circle(cx: 11, cy: 11, r: 8)
            Line(x1: 21, y1: 21, x2: 16.65, y2: 16.65)
        case .volume2:
            Polygon([11, 5, 6, 9, 2, 9, 2, 15, 6, 15, 11, 19, 11, 5])
            Path("M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07")
        case .arrowUpCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Polyline([16, 12, 12, 8, 8, 12])
            Line(x1: 12, y1: 16, x2: 12, y2: 8)
        case .pauseCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 10, y1: 15, x2: 10, y2: 9)
            Line(x1: 14, y1: 15, x2: 14, y2: 9)
        case .checkSquare:
            Polyline([9, 11, 12, 14, 22, 4])
            Path("M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11")
        case .arrowDown:
            Line(x1: 12, y1: 5, x2: 12, y2: 19)
            Polyline([19, 12, 12, 19, 5, 12])
        case .figma:
            Path("M5 5.5A3.5 3.5 0 0 1 8.5 2H12v7H8.5A3.5 3.5 0 0 1 5 5.5z")
            Path("M12 2h3.5a3.5 3.5 0 1 1 0 7H12V2z")
            Path("M12 12.5a3.5 3.5 0 1 1 7 0 3.5 3.5 0 1 1-7 0z")
            Path("M5 19.5A3.5 3.5 0 0 1 8.5 16H12v3.5a3.5 3.5 0 1 1-7 0z")
            Path("M5 12.5A3.5 3.5 0 0 1 8.5 9H12v7H8.5A3.5 3.5 0 0 1 5 12.5z")
        case .cornerRightUp:
            Polyline([10, 9, 15, 4, 20, 9])
            Path("M4 20h7a4 4 0 0 0 4-4V4")
        case .chevronsRight:
            Polyline([13, 17, 18, 12, 13, 7])
            Polyline([6, 17, 11, 12, 6, 7])
        case .list:
            Line(x1: 8, y1: 6, x2: 21, y2: 6)
            Line(x1: 8, y1: 12, x2: 21, y2: 12)
            Line(x1: 8, y1: 18, x2: 21, y2: 18)
            Line(x1: 3, y1: 6, x2: 3.01, y2: 6)
            Line(x1: 3, y1: 12, x2: 3.01, y2: 12)
            Line(x1: 3, y1: 18, x2: 3.01, y2: 18)
        case .chevronsDown:
            Polyline([7, 13, 12, 18, 17, 13])
            Polyline([7, 6, 12, 11, 17, 6])
        case .wind:
            Path("M9.59 4.59A2 2 0 1 1 11 8H2m10.59 11.41A2 2 0 1 0 14 16H2m15.73-8.27A2.5 2.5 0 1 1 19.5 12H2")
        case .cornerUpRight:
            Polyline([15, 14, 20, 9, 15, 4])
            Path("M4 20v-7a4 4 0 0 1 4-4h12")
        case .target:
            Circle(cx: 12, cy: 12, r: 10)
            Circle(cx: 12, cy: 12, r: 6)
            Circle(cx: 12, cy: 12, r: 2)
        case .scissors:
            Circle(cx: 6, cy: 6, r: 3)
            Circle(cx: 6, cy: 18, r: 3)
            Line(x1: 20, y1: 4, x2: 8.12, y2: 15.88)
            Line(x1: 14.47, y1: 14.48, x2: 20, y2: 20)
            Line(x1: 8.12, y1: 8.12, x2: 12, y2: 12)
        case .minimize2:
            Polyline([4, 14, 10, 14, 10, 20])
            Polyline([20, 10, 14, 10, 14, 4])
            Line(x1: 14, y1: 10, x2: 21, y2: 3)
            Line(x1: 3, y1: 21, x2: 10, y2: 14)
        case .playCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Polygon([10, 8, 16, 12, 10, 16, 10, 8])
        case .crosshair:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 22, y1: 12, x2: 18, y2: 12)
            Line(x1: 6, y1: 12, x2: 2, y2: 12)
            Line(x1: 12, y1: 6, x2: 12, y2: 2)
            Line(x1: 12, y1: 22, x2: 12, y2: 18)
        case .airplay:
            Path("M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1")
            Polygon([12, 15, 17, 21, 7, 21, 12, 15])
        case .xOctagon:
            Polygon([7.86, 2, 16.14, 2, 22, 7.86, 22, 16.14, 16.14, 22, 7.86, 22, 2, 16.14, 2, 7.86, 7.86, 2])
            Line(x1: 15, y1: 9, x2: 9, y2: 15)
            Line(x1: 9, y1: 9, x2: 15, y2: 15)
        case .repeat:
            Polyline([17, 1, 21, 5, 17, 9])
            Path("M3 11V9a4 4 0 0 1 4-4h14")
            Polyline([7, 23, 3, 19, 7, 15])
            Path("M21 13v2a4 4 0 0 1-4 4H3")
        case .edit3:
            Path("M12 20h9")
            Path("M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z")
        case .volume1:
            Polygon([11, 5, 6, 9, 2, 9, 2, 15, 6, 15, 11, 19, 11, 5])
            Path("M15.54 8.46a5 5 0 0 1 0 7.07")
        case .sunrise:
            Path("M17 18a5 5 0 0 0-10 0")
            Line(x1: 12, y1: 2, x2: 12, y2: 9)
            Line(x1: 4.22, y1: 10.22, x2: 5.64, y2: 11.64)
            Line(x1: 1, y1: 18, x2: 3, y2: 18)
            Line(x1: 21, y1: 18, x2: 23, y2: 18)
            Line(x1: 18.36, y1: 11.64, x2: 19.78, y2: 10.22)
            Line(x1: 23, y1: 22, x2: 1, y2: 22)
            Polyline([8, 6, 12, 2, 16, 6])
        case .toggleRight:
            Rect(x: 1, y: 5, width: 22, height: 14)
            Circle(cx: 16, cy: 12, r: 3)
        case .umbrella:
            Path("M23 12a11.05 11.05 0 0 0-22 0zm-5 7a3 3 0 0 1-6 0v-7")
        case .user:
            Path("M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2")
            Circle(cx: 12, cy: 7, r: 4)
        case .fileMinus:
            Path("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z")
            Polyline([14, 2, 14, 8, 20, 8])
            Line(x1: 9, y1: 15, x2: 15, y2: 15)
        case .xCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 15, y1: 9, x2: 9, y2: 15)
            Line(x1: 9, y1: 9, x2: 15, y2: 15)
        case .circle:
            Circle(cx: 12, cy: 12, r: 10)
        case .phoneMissed:
            Line(x1: 23, y1: 1, x2: 17, y2: 7)
            Line(x1: 17, y1: 1, x2: 23, y2: 7)
            Path("M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .edit2:
            Path("M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z")
        case .cornerLeftUp:
            Polyline([14, 9, 9, 4, 4, 9])
            Path("M20 20h-7a4 4 0 0 1-4-4V4")
        case .home:
            Path("M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z")
            Polyline([9, 22, 9, 12, 15, 12, 15, 22])
        case .gitlab:
            Path("M22.65 14.39L12 22.13 1.35 14.39a.84.84 0 0 1-.3-.94l1.22-3.78 2.44-7.51A.42.42 0 0 1 4.82 2a.43.43 0 0 1 .58 0 .42.42 0 0 1 .11.18l2.44 7.49h8.1l2.44-7.51A.42.42 0 0 1 18.6 2a.43.43 0 0 1 .58 0 .42.42 0 0 1 .11.18l2.44 7.51L23 13.45a.84.84 0 0 1-.35.94z")
        case .music:
            Path("M9 18V5l12-2v13")
            Circle(cx: 6, cy: 18, r: 3)
            Circle(cx: 18, cy: 16, r: 3)
        case .smartphone:
            Rect(x: 5, y: 2, width: 14, height: 20)
            Line(x1: 12, y1: 18, x2: 12.01, y2: 18)
        case .moreHorizontal:
            Circle(cx: 12, cy: 12, r: 1)
            Circle(cx: 19, cy: 12, r: 1)
            Circle(cx: 5, cy: 12, r: 1)
        case .sliders:
            Line(x1: 4, y1: 21, x2: 4, y2: 14)
            Line(x1: 4, y1: 10, x2: 4, y2: 3)
            Line(x1: 12, y1: 21, x2: 12, y2: 12)
            Line(x1: 12, y1: 8, x2: 12, y2: 3)
            Line(x1: 20, y1: 21, x2: 20, y2: 16)
            Line(x1: 20, y1: 12, x2: 20, y2: 3)
            Line(x1: 1, y1: 14, x2: 7, y2: 14)
            Line(x1: 9, y1: 8, x2: 15, y2: 8)
            Line(x1: 17, y1: 16, x2: 23, y2: 16)
        case .arrowUpLeft:
            Line(x1: 17, y1: 17, x2: 7, y2: 7)
            Polyline([7, 17, 7, 7, 17, 7])
        case .chevronDown:
            Polyline([6, 9, 12, 15, 18, 9])
        case .hexagon:
            Path("M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z")
        case .github:
            Path("M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22")
        case .crop:
            Path("M6.13 1L6 16a2 2 0 0 0 2 2h15")
            Path("M1 6.13L16 6a2 2 0 0 1 2 2v15")
        case .tag:
            Path("M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z")
            Line(x1: 7, y1: 7, x2: 7.01, y2: 7)
        case .briefcase:
            Rect(x: 2, y: 7, width: 20, height: 14)
            Path("M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16")
        case .rotateCw:
            Polyline([23, 4, 23, 10, 17, 10])
            Path("M20.49 15a9 9 0 1 1-2.12-9.36L23 10")
        case .map:
            Polygon([1, 6, 1, 22, 8, 18, 16, 22, 23, 18, 23, 2, 16, 6, 8, 2, 1, 6])
            Line(x1: 8, y1: 2, x2: 8, y2: 18)
            Line(x1: 16, y1: 6, x2: 16, y2: 22)
        case .inbox:
            Polyline([22, 12, 16, 12, 14, 15, 10, 15, 8, 12, 2, 12])
            Path("M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z")
        case .alignJustify:
            Line(x1: 21, y1: 10, x2: 3, y2: 10)
            Line(x1: 21, y1: 6, x2: 3, y2: 6)
            Line(x1: 21, y1: 14, x2: 3, y2: 14)
            Line(x1: 21, y1: 18, x2: 3, y2: 18)
        case .plusSquare:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 12, y1: 8, x2: 12, y2: 16)
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .power:
            Path("M18.36 6.64a9 9 0 1 1-12.73 0")
            Line(x1: 12, y1: 2, x2: 12, y2: 12)
        case .database:
            Ellipse(cx: 12, cy: 5, rx: 9, ry: 3)
            Path("M21 12c0 1.66-4 3-9 3s-9-1.34-9-3")
            Path("M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5")
        case .cameraOff:
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
            Path("M21 21H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3m3-3h6l2 3h4a2 2 0 0 1 2 2v9.34m-7.72-2.06a4 4 0 1 1-5.56-5.56")
        case .toggleLeft:
            Rect(x: 1, y: 5, width: 22, height: 14)
            Circle(cx: 8, cy: 12, r: 3)
        case .file:
            Path("M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z")
            Polyline([13, 2, 13, 9, 20, 9])
        case .messageCircle:
            Path("M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z")
        case .voicemail:
            Circle(cx: 5.5, cy: 11.5, r: 4.5)
            Circle(cx: 18.5, cy: 11.5, r: 4.5)
            Line(x1: 5.5, y1: 16, x2: 18.5, y2: 16)
        case .terminal:
            Polyline([4, 17, 10, 11, 4, 5])
            Line(x1: 12, y1: 19, x2: 20, y2: 19)
        case .move:
            Polyline([5, 9, 2, 12, 5, 15])
            Polyline([9, 5, 12, 2, 15, 5])
            Polyline([15, 19, 12, 22, 9, 19])
            Polyline([19, 9, 22, 12, 19, 15])
            Line(x1: 2, y1: 12, x2: 22, y2: 12)
            Line(x1: 12, y1: 2, x2: 12, y2: 22)
        case .maximize:
            Path("M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3")
        case .chevronUp:
            Polyline([18, 15, 12, 9, 6, 15])
        case .arrowDownLeft:
            Line(x1: 17, y1: 7, x2: 7, y2: 17)
            Polyline([17, 17, 7, 17, 7, 7])
        case .fileText:
            Path("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z")
            Polyline([14, 2, 14, 8, 20, 8])
            Line(x1: 16, y1: 13, x2: 8, y2: 13)
            Line(x1: 16, y1: 17, x2: 8, y2: 17)
            Polyline([10, 9, 9, 9, 8, 9])
        case .droplet:
            Path("M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z")
        case .zapOff:
            Polyline([12.41, 6.75, 13, 2, 10.57, 4.92])
            Polyline([18.57, 12.91, 21, 10, 15.66, 10])
            Polyline([8, 8, 3, 14, 12, 14, 11, 22, 16, 16])
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .x:
            Line(x1: 18, y1: 6, x2: 6, y2: 18)
            Line(x1: 6, y1: 6, x2: 18, y2: 18)
        case .barChart:
            Line(x1: 12, y1: 20, x2: 12, y2: 10)
            Line(x1: 18, y1: 20, x2: 18, y2: 4)
            Line(x1: 6, y1: 20, x2: 6, y2: 16)
        case .lock:
            Rect(x: 3, y: 11, width: 18, height: 11)
            Path("M7 11V7a5 5 0 0 1 10 0v4")
        case .logIn:
            Path("M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4")
            Polyline([10, 17, 15, 12, 10, 7])
            Line(x1: 15, y1: 12, x2: 3, y2: 12)
        case .shoppingBag:
            Path("M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z")
            Line(x1: 3, y1: 6, x2: 21, y2: 6)
            Path("M16 10a4 4 0 0 1-8 0")
        case .divide:
            Circle(cx: 12, cy: 6, r: 2)
            Line(x1: 5, y1: 12, x2: 19, y2: 12)
            Circle(cx: 12, cy: 18, r: 2)
        case .cloudDrizzle:
            Line(x1: 8, y1: 19, x2: 8, y2: 21)
            Line(x1: 8, y1: 13, x2: 8, y2: 15)
            Line(x1: 16, y1: 19, x2: 16, y2: 21)
            Line(x1: 16, y1: 13, x2: 16, y2: 15)
            Line(x1: 12, y1: 21, x2: 12, y2: 23)
            Line(x1: 12, y1: 15, x2: 12, y2: 17)
            Path("M20 16.58A5 5 0 0 0 18 7h-1.26A8 8 0 1 0 4 15.25")
        case .refreshCw:
            Polyline([23, 4, 23, 10, 17, 10])
            Polyline([1, 20, 1, 14, 7, 14])
            Path("M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15")
        case .chevronRight:
            Polyline([9, 18, 15, 12, 9, 6])
        case .clipboard:
            Path("M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2")
            Rect(x: 8, y: 2, width: 8, height: 4)
        case .package:
            Line(x1: 16.5, y1: 9.4, x2: 7.5, y2: 4.21)
            Path("M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z")
            Polyline([3.27, 6.96, 12, 12.01, 20.73, 6.96])
            Line(x1: 12, y1: 22.08, x2: 12, y2: 12)
        case .instagram:
            Rect(x: 2, y: 2, width: 20, height: 20)
            Path("M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z")
            Line(x1: 17.5, y1: 6.5, x2: 17.51, y2: 6.5)
        case .link:
            Path("M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71")
            Path("M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71")
        case .videoOff:
            Path("M16 16v1a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h2m5.66 0H14a2 2 0 0 1 2 2v3.34l1 1L23 7v10")
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .key:
            Path("M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4")
        case .meh:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 8, y1: 15, x2: 16, y2: 15)
            Line(x1: 9, y1: 9, x2: 9.01, y2: 9)
            Line(x1: 15, y1: 9, x2: 15.01, y2: 9)
        case .cornerDownRight:
            Polyline([15, 10, 20, 15, 15, 20])
            Path("M4 4v7a4 4 0 0 0 4 4h12")
        case .arrowRight:
            Line(x1: 5, y1: 12, x2: 19, y2: 12)
            Polyline([12, 5, 19, 12, 12, 19])
        case .aperture:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 14.31, y1: 8, x2: 20.05, y2: 17.94)
            Line(x1: 9.69, y1: 8, x2: 21.17, y2: 8)
            Line(x1: 7.38, y1: 12, x2: 13.12, y2: 2.06)
            Line(x1: 9.69, y1: 16, x2: 3.95, y2: 6.06)
            Line(x1: 14.31, y1: 16, x2: 2.83, y2: 16)
            Line(x1: 16.62, y1: 12, x2: 10.88, y2: 21.94)
        case .stopCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Rect(x: 9, y: 9, width: 6, height: 6)
        case .logOut:
            Path("M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4")
            Polyline([16, 17, 21, 12, 16, 7])
            Line(x1: 21, y1: 12, x2: 9, y2: 12)
        case .arrowLeftCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Polyline([12, 8, 8, 12, 12, 16])
            Line(x1: 16, y1: 12, x2: 8, y2: 12)
        case .barChart2:
            Line(x1: 18, y1: 20, x2: 18, y2: 10)
            Line(x1: 12, y1: 20, x2: 12, y2: 4)
            Line(x1: 6, y1: 20, x2: 6, y2: 14)
        case .gitPullRequest:
            Circle(cx: 18, cy: 18, r: 3)
            Circle(cx: 6, cy: 6, r: 3)
            Path("M13 6h3a2 2 0 0 1 2 2v7")
            Line(x1: 6, y1: 9, x2: 6, y2: 21)
        case .minimize:
            Path("M8 3v3a2 2 0 0 1-2 2H3m18 0h-3a2 2 0 0 1-2-2V3m0 18v-3a2 2 0 0 1 2-2h3M3 16h3a2 2 0 0 1 2 2v3")
        case .minusSquare:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .settings:
            Circle(cx: 12, cy: 12, r: 3)
            Path("M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z")
        case .cloudSnow:
            Path("M20 17.58A5 5 0 0 0 18 8h-1.26A8 8 0 1 0 4 16.25")
            Line(x1: 8, y1: 16, x2: 8.01, y2: 16)
            Line(x1: 8, y1: 20, x2: 8.01, y2: 20)
            Line(x1: 12, y1: 18, x2: 12.01, y2: 18)
            Line(x1: 12, y1: 22, x2: 12.01, y2: 22)
            Line(x1: 16, y1: 16, x2: 16.01, y2: 16)
            Line(x1: 16, y1: 20, x2: 16.01, y2: 20)
        case .thumbsDown:
            Path("M10 15v4a3 3 0 0 0 3 3l4-9V2H5.72a2 2 0 0 0-2 1.7l-1.38 9a2 2 0 0 0 2 2.3zm7-13h2.67A2.31 2.31 0 0 1 22 4v7a2.31 2.31 0 0 1-2.33 2H17")
        case .type:
            Polyline([4, 7, 4, 4, 20, 4, 20, 7])
            Line(x1: 9, y1: 20, x2: 15, y2: 20)
            Line(x1: 12, y1: 4, x2: 12, y2: 20)
        case .archive:
            Polyline([21, 8, 21, 21, 3, 21, 3, 8])
            Rect(x: 1, y: 3, width: 22, height: 5)
            Line(x1: 10, y1: 12, x2: 14, y2: 12)
        case .phoneOutgoing:
            Polyline([23, 7, 23, 1, 17, 1])
            Line(x1: 16, y1: 8, x2: 23, y2: 1)
            Path("M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .pocket:
            Path("M4 3h16a2 2 0 0 1 2 2v6a10 10 0 0 1-10 10A10 10 0 0 1 2 11V5a2 2 0 0 1 2-2z")
            Polyline([8, 10, 12, 14, 16, 10])
        case .mail:
            Path("M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z")
            Polyline([22,6, 12,13, 2,6])
        case .shield:
            Path("M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z")
        case .download:
            Path("M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4")
            Polyline([7, 10, 12, 15, 17, 10])
            Line(x1: 12, y1: 15, x2: 12, y2: 3)
        case .phoneForwarded:
            Polyline([19, 1, 23, 5, 19, 9])
            Line(x1: 15, y1: 5, x2: 23, y2: 5)
            Path("M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .cornerRightDown:
            Polyline([10, 15, 15, 20, 20, 15])
            Path("M4 4h7a4 4 0 0 1 4 4v12")
        case .bookOpen:
            Path("M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z")
            Path("M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z")
        case .divideSquare:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
            Line(x1: 12, y1: 16, x2: 12, y2: 16)
            Line(x1: 12, y1: 8, x2: 12, y2: 8)
        case .server:
            Rect(x: 2, y: 2, width: 20, height: 8)
            Rect(x: 2, y: 14, width: 20, height: 8)
            Line(x1: 6, y1: 6, x2: 6.01, y2: 6)
            Line(x1: 6, y1: 18, x2: 6.01, y2: 18)
        case .tv:
            Rect(x: 2, y: 7, width: 20, height: 15)
            Polyline([17, 2, 12, 7, 7, 2])
        case .skipForward:
            Polygon([5, 4, 15, 12, 5, 20, 5, 4])
            Line(x1: 19, y1: 5, x2: 19, y2: 19)
        case .volume:
            Polygon([11, 5, 6, 9, 2, 9, 2, 15, 6, 15, 11, 19, 11, 5])
        case .userPlus:
            Path("M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2")
            Circle(cx: 8.5, cy: 7, r: 4)
            Line(x1: 20, y1: 8, x2: 20, y2: 14)
            Line(x1: 23, y1: 11, x2: 17, y2: 11)
        case .batteryCharging:
            Path("M5 18H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3.19M15 6h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-3.19")
            Line(x1: 23, y1: 13, x2: 23, y2: 11)
            Polyline([11, 6, 7, 12, 13, 12, 9, 18])
        case .layers:
            Polygon([12, 2, 2, 7, 12, 12, 22, 7, 12, 2])
            Polyline([2, 17, 12, 22, 22, 17])
            Polyline([2, 12, 12, 17, 22, 12])
        case .slash:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 4.93, y1: 4.93, x2: 19.07, y2: 19.07)
        case .radio:
            Circle(cx: 12, cy: 12, r: 2)
            Path("M16.24 7.76a6 6 0 0 1 0 8.49m-8.48-.01a6 6 0 0 1 0-8.49m11.31-2.82a10 10 0 0 1 0 14.14m-14.14 0a10 10 0 0 1 0-14.14")
        case .book:
            Path("M4 19.5A2.5 2.5 0 0 1 6.5 17H20")
            Path("M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z")
        case .userMinus:
            Path("M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2")
            Circle(cx: 8.5, cy: 7, r: 4)
            Line(x1: 23, y1: 11, x2: 17, y2: 11)
        case .bell:
            Path("M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9")
            Path("M13.73 21a2 2 0 0 1-3.46 0")
        case .gitBranch:
            Line(x1: 6, y1: 3, x2: 6, y2: 15)
            Circle(cx: 18, cy: 6, r: 3)
            Circle(cx: 6, cy: 18, r: 3)
            Path("M18 9a9 9 0 0 1-9 9")
        case .coffee:
            Path("M18 8h1a4 4 0 0 1 0 8h-1")
            Path("M2 8h16v9a4 4 0 0 1-4 4H6a4 4 0 0 1-4-4V8z")
            Line(x1: 6, y1: 1, x2: 6, y2: 4)
            Line(x1: 10, y1: 1, x2: 10, y2: 4)
            Line(x1: 14, y1: 1, x2: 14, y2: 4)
        case .code:
            Polyline([16, 18, 22, 12, 16, 6])
            Polyline([8, 6, 2, 12, 8, 18])
        case .thermometer:
            Path("M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z")
        case .cast:
            Path("M2 16.1A5 5 0 0 1 5.9 20M2 12.05A9 9 0 0 1 9.95 20M2 8V6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-6")
            Line(x1: 2, y1: 20, x2: 2.01, y2: 20)
        case .flag:
            Path("M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z")
            Line(x1: 4, y1: 22, x2: 4, y2: 15)
        case .eyeOff:
            Path("M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24")
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .battery:
            Rect(x: 1, y: 6, width: 18, height: 12)
            Line(x1: 23, y1: 13, x2: 23, y2: 11)
        case .disc:
            Circle(cx: 12, cy: 12, r: 10)
            Circle(cx: 12, cy: 12, r: 3)
        case .frown:
            Circle(cx: 12, cy: 12, r: 10)
            Path("M16 16s-1.5-2-4-2-4 2-4 2")
            Line(x1: 9, y1: 9, x2: 9.01, y2: 9)
            Line(x1: 15, y1: 9, x2: 15.01, y2: 9)
        case .tool:
            Path("M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z")
        case .cpu:
            Rect(x: 4, y: 4, width: 16, height: 16)
            Rect(x: 9, y: 9, width: 6, height: 6)
            Line(x1: 9, y1: 1, x2: 9, y2: 4)
            Line(x1: 15, y1: 1, x2: 15, y2: 4)
            Line(x1: 9, y1: 20, x2: 9, y2: 23)
            Line(x1: 15, y1: 20, x2: 15, y2: 23)
            Line(x1: 20, y1: 9, x2: 23, y2: 9)
            Line(x1: 20, y1: 14, x2: 23, y2: 14)
            Line(x1: 1, y1: 9, x2: 4, y2: 9)
            Line(x1: 1, y1: 14, x2: 4, y2: 14)
        case .bold:
            Path("M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z")
            Path("M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z")
        case .hash:
            Line(x1: 4, y1: 9, x2: 20, y2: 9)
            Line(x1: 4, y1: 15, x2: 20, y2: 15)
            Line(x1: 10, y1: 3, x2: 8, y2: 21)
            Line(x1: 16, y1: 3, x2: 14, y2: 21)
        case .share2:
            Circle(cx: 18, cy: 5, r: 3)
            Circle(cx: 6, cy: 12, r: 3)
            Circle(cx: 18, cy: 19, r: 3)
            Line(x1: 8.59, y1: 13.51, x2: 15.42, y2: 17.49)
            Line(x1: 15.41, y1: 6.51, x2: 8.59, y2: 10.49)
        case .plus:
            Line(x1: 12, y1: 5, x2: 12, y2: 19)
            Line(x1: 5, y1: 12, x2: 19, y2: 12)
        case .check:
            Polyline([20, 6, 9, 17, 4, 12])
        case .rotateCcw:
            Polyline([1, 4, 1, 10, 7, 10])
            Path("M3.51 15a9 9 0 1 0 2.13-9.36L1 10")
        case .hardDrive:
            Line(x1: 22, y1: 12, x2: 2, y2: 12)
            Path("M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z")
            Line(x1: 6, y1: 16, x2: 6.01, y2: 16)
            Line(x1: 10, y1: 16, x2: 10.01, y2: 16)
        case .bluetooth:
            Polyline([6.5, 6.5, 17.5, 17.5, 12, 23, 12, 1, 17.5, 6.5, 6.5, 17.5])
        case .pieChart:
            Path("M21.21 15.89A10 10 0 1 1 8 2.83")
            Path("M22 12A10 10 0 0 0 12 2v10z")
        case .headphones:
            Path("M3 18v-6a9 9 0 0 1 18 0v6")
            Path("M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z")
        case .rss:
            Path("M4 11a9 9 0 0 1 9 9")
            Path("M4 4a16 16 0 0 1 16 16")
            Circle(cx: 5, cy: 19, r: 1)
        case .wifi:
            Path("M5 12.55a11 11 0 0 1 14.08 0")
            Path("M1.42 9a16 16 0 0 1 21.16 0")
            Path("M8.53 16.11a6 6 0 0 1 6.95 0")
            Line(x1: 12, y1: 20, x2: 12.01, y2: 20)
        case .cornerUpLeft:
            Polyline([9, 14, 4, 9, 9, 4])
            Path("M20 20v-7a4 4 0 0 0-4-4H4")
        case .watch:
            Circle(cx: 12, cy: 12, r: 7)
            Polyline([12, 9, 12, 12, 13.5, 13.5])
            Path("M16.51 17.35l-.35 3.83a2 2 0 0 1-2 1.82H9.83a2 2 0 0 1-2-1.82l-.35-3.83m.01-10.7l.35-3.83A2 2 0 0 1 9.83 1h4.35a2 2 0 0 1 2 1.82l.35 3.83")
        case .info:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 12, y1: 16, x2: 12, y2: 12)
            Line(x1: 12, y1: 8, x2: 12.01, y2: 8)
        case .userX:
            Path("M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2")
            Circle(cx: 8.5, cy: 7, r: 4)
            Line(x1: 18, y1: 8, x2: 23, y2: 13)
            Line(x1: 23, y1: 8, x2: 18, y2: 13)
        case .loader:
            Line(x1: 12, y1: 2, x2: 12, y2: 6)
            Line(x1: 12, y1: 18, x2: 12, y2: 22)
            Line(x1: 4.93, y1: 4.93, x2: 7.76, y2: 7.76)
            Line(x1: 16.24, y1: 16.24, x2: 19.07, y2: 19.07)
            Line(x1: 2, y1: 12, x2: 6, y2: 12)
            Line(x1: 18, y1: 12, x2: 22, y2: 12)
            Line(x1: 4.93, y1: 19.07, x2: 7.76, y2: 16.24)
            Line(x1: 16.24, y1: 7.76, x2: 19.07, y2: 4.93)
        case .refreshCcw:
            Polyline([1, 4, 1, 10, 7, 10])
            Polyline([23, 20, 23, 14, 17, 14])
            Path("M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15")
        case .folderPlus:
            Path("M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z")
            Line(x1: 12, y1: 11, x2: 12, y2: 17)
            Line(x1: 9, y1: 14, x2: 15, y2: 14)
        case .gitMerge:
            Circle(cx: 18, cy: 18, r: 3)
            Circle(cx: 6, cy: 6, r: 3)
            Path("M6 21V9a9 9 0 0 0 9 9")
        case .mic:
            Path("M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z")
            Path("M19 10v2a7 7 0 0 1-14 0v-2")
            Line(x1: 12, y1: 19, x2: 12, y2: 23)
            Line(x1: 8, y1: 23, x2: 16, y2: 23)
        case .copy:
            Rect(x: 9, y: 9, width: 13, height: 13)
            Path("M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1")
        case .zoomIn:
            Circle(cx: 11, cy: 11, r: 8)
            Line(x1: 21, y1: 21, x2: 16.65, y2: 16.65)
            Line(x1: 11, y1: 8, x2: 11, y2: 14)
            Line(x1: 8, y1: 11, x2: 14, y2: 11)
        case .arrowRightCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Polyline([12, 16, 16, 12, 12, 8])
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .alignRight:
            Line(x1: 21, y1: 10, x2: 7, y2: 10)
            Line(x1: 21, y1: 6, x2: 3, y2: 6)
            Line(x1: 21, y1: 14, x2: 3, y2: 14)
            Line(x1: 21, y1: 18, x2: 7, y2: 18)
        case .image:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Circle(cx: 8.5, cy: 8.5, r: 1.5)
            Polyline([21, 15, 16, 10, 5, 21])
        case .maximize2:
            Polyline([15, 3, 21, 3, 21, 9])
            Polyline([9, 21, 3, 21, 3, 15])
            Line(x1: 21, y1: 3, x2: 14, y2: 10)
            Line(x1: 3, y1: 21, x2: 10, y2: 14)
        case .checkCircle:
            Path("M22 11.08V12a10 10 0 1 1-5.93-9.14")
            Polyline([22, 4, 12, 14.01, 9, 11.01])
        case .sunset:
            Path("M17 18a5 5 0 0 0-10 0")
            Line(x1: 12, y1: 9, x2: 12, y2: 2)
            Line(x1: 4.22, y1: 10.22, x2: 5.64, y2: 11.64)
            Line(x1: 1, y1: 18, x2: 3, y2: 18)
            Line(x1: 21, y1: 18, x2: 23, y2: 18)
            Line(x1: 18.36, y1: 11.64, x2: 19.78, y2: 10.22)
            Line(x1: 23, y1: 22, x2: 1, y2: 22)
            Polyline([16, 5, 12, 9, 8, 5])
        case .save:
            Path("M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z")
            Polyline([17, 21, 17, 13, 7, 13, 7, 21])
            Polyline([7, 3, 7, 8, 15, 8])
        case .smile:
            Circle(cx: 12, cy: 12, r: 10)
            Path("M8 14s1.5 2 4 2 4-2 4-2")
            Line(x1: 9, y1: 9, x2: 9.01, y2: 9)
            Line(x1: 15, y1: 9, x2: 15.01, y2: 9)
        case .navigation:
            Polygon([3, 11, 22, 2, 13, 21, 11, 13, 3, 11])
        case .cloudLightning:
            Path("M19 16.9A5 5 0 0 0 18 7h-1.26a8 8 0 1 0-11.62 9")
            Polyline([13, 11, 9, 17, 15, 17, 11, 23])
        case .paperclip:
            Path("M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48")
        case .fastForward:
            Polygon([13, 19, 22, 12, 13, 5, 13, 19])
            Polygon([2, 19, 11, 12, 2, 5, 2, 19])
        case .xSquare:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 9, y1: 9, x2: 15, y2: 15)
            Line(x1: 15, y1: 9, x2: 9, y2: 15)
        case .award:
            Circle(cx: 12, cy: 8, r: 7)
            Polyline([8.21, 13.89, 7, 23, 12, 20, 17, 23, 15.79, 13.88])
        case .zoomOut:
            Circle(cx: 11, cy: 11, r: 8)
            Line(x1: 21, y1: 21, x2: 16.65, y2: 16.65)
            Line(x1: 8, y1: 11, x2: 14, y2: 11)
        case .box:
            Path("M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z")
            Polyline([3.27, 6.96, 12, 12.01, 20.73, 6.96])
            Line(x1: 12, y1: 22.08, x2: 12, y2: 12)
        case .thumbsUp:
            Path("M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3")
        case .percent:
            Line(x1: 19, y1: 5, x2: 5, y2: 19)
            Circle(cx: 6.5, cy: 6.5, r: 2.5)
            Circle(cx: 17.5, cy: 17.5, r: 2.5)
        case .sidebar:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 9, y1: 3, x2: 9, y2: 21)
        case .square:
            Rect(x: 3, y: 3, width: 18, height: 18)
        case .play:
            Polygon([5, 3, 19, 12, 5, 21, 5, 3])
        case .gitCommit:
            Circle(cx: 12, cy: 12, r: 4)
            Line(x1: 1.05, y1: 12, x2: 7, y2: 12)
            Line(x1: 17.01, y1: 12, x2: 22.96, y2: 12)
        case .send:
            Line(x1: 22, y1: 2, x2: 11, y2: 13)
            Polygon([22, 2, 15, 22, 11, 13, 2, 9, 22, 2])
        case .phoneCall:
            Path("M15.05 5A5 5 0 0 1 19 8.95M15.05 1A9 9 0 0 1 23 8.94m-1 7.98v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .speaker:
            Rect(x: 4, y: 2, width: 16, height: 20)
            Circle(cx: 12, cy: 14, r: 4)
            Line(x1: 12, y1: 6, x2: 12.01, y2: 6)
        case .facebook:
            Path("M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z")
        case .codesandbox:
            Path("M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z")
            Polyline([7.5, 4.21, 12, 6.81, 16.5, 4.21])
            Polyline([7.5, 19.79, 7.5, 14.6, 3, 12])
            Polyline([21, 12, 16.5, 14.6, 16.5, 19.79])
            Polyline([3.27, 6.96, 12, 12.01, 20.73, 6.96])
            Line(x1: 12, y1: 22.08, x2: 12, y2: 12)
        case .camera:
            Path("M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z")
            Circle(cx: 12, cy: 13, r: 4)
        case .link2:
            Path("M15 7h3a5 5 0 0 1 5 5 5 5 0 0 1-5 5h-3m-6 0H6a5 5 0 0 1-5-5 5 5 0 0 1 5-5h3")
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .printer:
            Polyline([6, 9, 6, 2, 18, 2, 18, 9])
            Path("M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2")
            Rect(x: 6, y: 14, width: 12, height: 8)
        case .folderMinus:
            Path("M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z")
            Line(x1: 9, y1: 14, x2: 15, y2: 14)
        case .arrowUpRight:
            Line(x1: 7, y1: 17, x2: 17, y2: 7)
            Polyline([7, 7, 17, 7, 17, 17])
        case .truck:
            Rect(x: 1, y: 3, width: 15, height: 13)
            Polygon([16, 8, 20, 8, 23, 11, 23, 16, 16, 16, 16, 8])
            Circle(cx: 5.5, cy: 18.5, r: 2.5)
            Circle(cx: 18.5, cy: 18.5, r: 2.5)
        case .lifeBuoy:
            Circle(cx: 12, cy: 12, r: 10)
            Circle(cx: 12, cy: 12, r: 4)
            Line(x1: 4.93, y1: 4.93, x2: 9.17, y2: 9.17)
            Line(x1: 14.83, y1: 14.83, x2: 19.07, y2: 19.07)
            Line(x1: 14.83, y1: 9.17, x2: 19.07, y2: 4.93)
            Line(x1: 14.83, y1: 9.17, x2: 18.36, y2: 5.64)
            Line(x1: 4.93, y1: 19.07, x2: 9.17, y2: 14.83)
        case .penTool:
            Path("M12 19l7-7 3 3-7 7-3-3z")
            Path("M18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5z")
            Path("M2 2l7.586 7.586")
            Circle(cx: 11, cy: 11, r: 2)
        case .atSign:
            Circle(cx: 12, cy: 12, r: 4)
            Path("M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-3.92 7.94")
        case .feather:
            Path("M20.24 12.24a6 6 0 0 0-8.49-8.49L5 10.5V19h8.5z")
            Line(x1: 16, y1: 8, x2: 2, y2: 22)
            Line(x1: 17.5, y1: 15, x2: 9, y2: 15)
        case .trash:
            Polyline([3, 6, 5, 6, 21, 6])
            Path("M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2")
        case .wifiOff:
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
            Path("M16.72 11.06A10.94 10.94 0 0 1 19 12.55")
            Path("M5 12.55a10.94 10.94 0 0 1 5.17-2.39")
            Path("M10.71 5.05A16 16 0 0 1 22.58 9")
            Path("M1.42 9a15.91 15.91 0 0 1 4.7-2.88")
            Path("M8.53 16.11a6 6 0 0 1 6.95 0")
            Line(x1: 12, y1: 20, x2: 12.01, y2: 20)
        case .cornerLeftDown:
            Polyline([14, 15, 9, 20, 4, 15])
            Path("M20 4h-7a4 4 0 0 0-4 4v12")
        case .dollarSign:
            Line(x1: 12, y1: 1, x2: 12, y2: 23)
            Path("M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6")
        case .star:
            Polygon([12, 2, 15.09, 8.26, 22, 9.27, 17, 14.14, 18.18, 21.02, 12, 17.77, 5.82, 21.02, 7, 14.14, 2, 9.27, 8.91, 8.26, 12, 2])
        case .cloudOff:
            Path("M22.61 16.95A5 5 0 0 0 18 10h-1.26a8 8 0 0 0-7.05-6M5 5a8 8 0 0 0 4 15h9a5 5 0 0 0 1.7-.3")
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .sun:
            Circle(cx: 12, cy: 12, r: 5)
            Line(x1: 12, y1: 1, x2: 12, y2: 3)
            Line(x1: 12, y1: 21, x2: 12, y2: 23)
            Line(x1: 4.22, y1: 4.22, x2: 5.64, y2: 5.64)
            Line(x1: 18.36, y1: 18.36, x2: 19.78, y2: 19.78)
            Line(x1: 1, y1: 12, x2: 3, y2: 12)
            Line(x1: 21, y1: 12, x2: 23, y2: 12)
            Line(x1: 4.22, y1: 19.78, x2: 5.64, y2: 18.36)
            Line(x1: 18.36, y1: 5.64, x2: 19.78, y2: 4.22)
        case .messageSquare:
            Path("M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z")
        case .edit:
            Path("M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7")
            Path("M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z")
        case .anchor:
            Circle(cx: 12, cy: 5, r: 3)
            Line(x1: 12, y1: 22, x2: 12, y2: 8)
            Path("M5 12H2a10 10 0 0 0 20 0h-3")
        case .alertCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 12, y1: 8, x2: 12, y2: 12)
            Line(x1: 12, y1: 16, x2: 12.01, y2: 16)
        case .chevronsUp:
            Polyline([17, 11, 12, 6, 7, 11])
            Polyline([17, 18, 12, 13, 7, 18])
        case .uploadCloud:
            Polyline([16, 16, 12, 12, 8, 16])
            Line(x1: 12, y1: 12, x2: 12, y2: 21)
            Path("M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3")
            Polyline([16, 16, 12, 12, 8, 16])
        case .twitch:
            Path("M21 2H3v16h5v4l4-4h5l4-4V2zm-10 9V7m5 4V7")
        case .youtube:
            Path("M22.54 6.42a2.78 2.78 0 0 0-1.94-2C18.88 4 12 4 12 4s-6.88 0-8.6.46a2.78 2.78 0 0 0-1.94 2A29 29 0 0 0 1 11.75a29 29 0 0 0 .46 5.33A2.78 2.78 0 0 0 3.4 19c1.72.46 8.6.46 8.6.46s6.88 0 8.6-.46a2.78 2.78 0 0 0 1.94-2 29 29 0 0 0 .46-5.25 29 29 0 0 0-.46-5.33z")
            Polygon([9.75, 15.02, 15.5, 11.75, 9.75, 8.48, 9.75, 15.02])
        case .unlock:
            Rect(x: 3, y: 11, width: 18, height: 11)
            Path("M7 11V7a5 5 0 0 1 9.9-1")
        case .compass:
            Circle(cx: 12, cy: 12, r: 10)
            Polygon([16.24, 7.76, 14.12, 14.12, 7.76, 16.24, 9.88, 9.88, 16.24, 7.76])
        case .plusCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 12, y1: 8, x2: 12, y2: 16)
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .creditCard:
            Rect(x: 1, y: 4, width: 22, height: 16)
            Line(x1: 1, y1: 10, x2: 23, y2: 10)
        case .cloudRain:
            Line(x1: 16, y1: 13, x2: 16, y2: 21)
            Line(x1: 8, y1: 13, x2: 8, y2: 21)
            Line(x1: 12, y1: 15, x2: 12, y2: 23)
            Path("M20 16.58A5 5 0 0 0 18 7h-1.26A8 8 0 1 0 4 15.25")
        case .trash2:
            Polyline([3, 6, 5, 6, 21, 6])
            Path("M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2")
            Line(x1: 10, y1: 11, x2: 10, y2: 17)
            Line(x1: 14, y1: 11, x2: 14, y2: 17)
        case .skipBack:
            Polygon([19, 20, 9, 12, 19, 4, 19, 20])
            Line(x1: 5, y1: 19, x2: 5, y2: 5)
        case .filePlus:
            Path("M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z")
            Polyline([14, 2, 14, 8, 20, 8])
            Line(x1: 12, y1: 18, x2: 12, y2: 12)
            Line(x1: 9, y1: 15, x2: 15, y2: 15)
        case .delete:
            Path("M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z")
            Line(x1: 18, y1: 9, x2: 12, y2: 15)
            Line(x1: 12, y1: 9, x2: 18, y2: 15)
        case .command:
            Path("M18 3a3 3 0 0 0-3 3v12a3 3 0 0 0 3 3 3 3 0 0 0 3-3 3 3 0 0 0-3-3H6a3 3 0 0 0-3 3 3 3 0 0 0 3 3 3 3 0 0 0 3-3V6a3 3 0 0 0-3-3 3 3 0 0 0-3 3 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 3 3 0 0 0-3-3z")
        case .clock:
            Circle(cx: 12, cy: 12, r: 10)
            Polyline([12, 6, 12, 12, 16, 14])
        case .octagon:
            Polygon([7.86, 2, 16.14, 2, 22, 7.86, 22, 16.14, 16.14, 22, 7.86, 22, 2, 16.14, 2, 7.86, 7.86, 2])
        case .phone:
            Path("M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .eye:
            Path("M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z")
            Circle(cx: 12, cy: 12, r: 3)
        case .phoneOff:
            Path("M10.68 13.31a16 16 0 0 0 3.41 2.6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7 2 2 0 0 1 1.72 2v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.42 19.42 0 0 1-3.33-2.67m-2.67-3.34a19.79 19.79 0 0 1-3.07-8.63A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91")
            Line(x1: 23, y1: 1, x2: 1, y2: 23)
        case .codepen:
            Polygon([12, 2, 22, 8.5, 22, 15.5, 12, 22, 2, 15.5, 2, 8.5, 12, 2])
            Line(x1: 12, y1: 22, x2: 12, y2: 15.5)
            Polyline([22, 8.5, 12, 15.5, 2, 8.5])
            Polyline([2, 15.5, 12, 8.5, 22, 15.5])
            Line(x1: 12, y1: 2, x2: 12, y2: 8.5)
        case .dribbble:
            Circle(cx: 12, cy: 12, r: 10)
            Path("M8.56 2.75c4.37 6.03 6.02 9.42 8.03 17.72m2.54-15.38c-3.72 4.35-8.94 5.66-16.88 5.85m19.5 1.9c-3.5-.93-6.63-.82-8.94 0-2.58.92-5.01 2.86-7.44 6.32")
        case .gift:
            Polyline([20, 12, 20, 22, 4, 22, 4, 12])
            Rect(x: 2, y: 7, width: 20, height: 5)
            Line(x1: 12, y1: 22, x2: 12, y2: 7)
            Path("M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z")
            Path("M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z")
        case .externalLink:
            Path("M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6")
            Polyline([15, 3, 21, 3, 21, 9])
            Line(x1: 10, y1: 14, x2: 21, y2: 3)
        case .zap:
            Polygon([13, 2, 3, 14, 12, 14, 11, 22, 21, 10, 12, 10, 13, 2])
        case .trello:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Rect(x: 7, y: 7, width: 3, height: 9)
            Rect(x: 14, y: 7, width: 3, height: 5)
        case .moreVertical:
            Circle(cx: 12, cy: 12, r: 1)
            Circle(cx: 12, cy: 5, r: 1)
            Circle(cx: 12, cy: 19, r: 1)
        case .micOff:
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
            Path("M9 9v3a3 3 0 0 0 5.12 2.12M15 9.34V4a3 3 0 0 0-5.94-.6")
            Path("M17 16.95A7 7 0 0 1 5 12v-2m14 0v2a7 7 0 0 1-.11 1.23")
            Line(x1: 12, y1: 19, x2: 12, y2: 23)
            Line(x1: 8, y1: 23, x2: 16, y2: 23)
        case .share:
            Path("M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8")
            Polyline([16, 6, 12, 2, 8, 6])
            Line(x1: 12, y1: 2, x2: 12, y2: 15)
        case .arrowUp:
            Line(x1: 12, y1: 19, x2: 12, y2: 5)
            Polyline([5, 12, 12, 5, 19, 12])
        case .bellOff:
            Path("M13.73 21a2 2 0 0 1-3.46 0")
            Path("M18.63 13A17.89 17.89 0 0 1 18 8")
            Path("M6.26 6.26A5.86 5.86 0 0 0 6 8c0 7-3 9-3 9h14")
            Path("M18 8a6 6 0 0 0-9.33-5")
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .linkedin:
            Path("M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z")
            Rect(x: 2, y: 9, width: 4, height: 12)
            Circle(cx: 4, cy: 4, r: 2)
        case .video:
            Polygon([23, 7, 16, 12, 23, 17, 23, 7])
            Rect(x: 1, y: 5, width: 15, height: 14)
        case .divideCircle:
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
            Line(x1: 12, y1: 16, x2: 12, y2: 16)
            Line(x1: 12, y1: 8, x2: 12, y2: 8)
            Circle(cx: 12, cy: 12, r: 10)
        case .activity:
            Polyline([22, 12, 18, 12, 15, 21, 9, 3, 6, 12, 2, 12])
        case .twitter:
            Path("M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z")
        case .mapPin:
            Path("M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z")
            Circle(cx: 12, cy: 10, r: 3)
        case .filter:
            Polygon([22, 3, 2, 3, 10, 12.46, 10, 19, 14, 21, 14, 12.46, 22, 3])
        case .phoneIncoming:
            Polyline([16, 2, 16, 8, 22, 8])
            Line(x1: 23, y1: 1, x2: 16, y2: 8)
            Path("M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z")
        case .italic:
            Line(x1: 19, y1: 4, x2: 10, y2: 4)
            Line(x1: 14, y1: 20, x2: 5, y2: 20)
            Line(x1: 15, y1: 4, x2: 9, y2: 20)
        case .chevronsLeft:
            Polyline([11, 17, 6, 12, 11, 7])
            Polyline([18, 17, 13, 12, 18, 7])
        case .calendar:
            Rect(x: 3, y: 4, width: 18, height: 18)
            Line(x1: 16, y1: 2, x2: 16, y2: 6)
            Line(x1: 8, y1: 2, x2: 8, y2: 6)
            Line(x1: 3, y1: 10, x2: 21, y2: 10)
        case .globe:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 2, y1: 12, x2: 22, y2: 12)
            Path("M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z")
        case .arrowLeft:
            Line(x1: 19, y1: 12, x2: 5, y2: 12)
            Polyline([12, 19, 5, 12, 12, 5])
        case .alignCenter:
            Line(x1: 18, y1: 10, x2: 6, y2: 10)
            Line(x1: 21, y1: 6, x2: 3, y2: 6)
            Line(x1: 21, y1: 14, x2: 3, y2: 14)
            Line(x1: 18, y1: 18, x2: 6, y2: 18)
        case .minusCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Line(x1: 8, y1: 12, x2: 16, y2: 12)
        case .arrowDownRight:
            Line(x1: 7, y1: 7, x2: 17, y2: 17)
            Polyline([17, 7, 17, 17, 7, 17])
        case .framer:
            Path("M5 16V9h14V2H5l14 14h-7m-7 0l7 7v-7m-7 0h7")
        case .volumeX:
            Polygon([11, 5, 6, 9, 2, 9, 2, 15, 6, 15, 11, 19, 11, 5])
            Line(x1: 23, y1: 9, x2: 17, y2: 15)
            Line(x1: 17, y1: 9, x2: 23, y2: 15)
        case .slack:
            Path("M14.5 10c-.83 0-1.5-.67-1.5-1.5v-5c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5v5c0 .83-.67 1.5-1.5 1.5z")
            Path("M20.5 10H19V8.5c0-.83.67-1.5 1.5-1.5s1.5.67 1.5 1.5-.67 1.5-1.5 1.5z")
            Path("M9.5 14c.83 0 1.5.67 1.5 1.5v5c0 .83-.67 1.5-1.5 1.5S8 21.33 8 20.5v-5c0-.83.67-1.5 1.5-1.5z")
            Path("M3.5 14H5v1.5c0 .83-.67 1.5-1.5 1.5S2 16.33 2 15.5 2.67 14 3.5 14z")
            Path("M14 14.5c0-.83.67-1.5 1.5-1.5h5c.83 0 1.5.67 1.5 1.5s-.67 1.5-1.5 1.5h-5c-.83 0-1.5-.67-1.5-1.5z")
            Path("M15.5 19H14v1.5c0 .83.67 1.5 1.5 1.5s1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z")
            Path("M10 9.5C10 8.67 9.33 8 8.5 8h-5C2.67 8 2 8.67 2 9.5S2.67 11 3.5 11h5c.83 0 1.5-.67 1.5-1.5z")
            Path("M8.5 5H10V3.5C10 2.67 9.33 2 8.5 2S7 2.67 7 3.5 7.67 5 8.5 5z")
        case .cloud:
            Path("M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z")
        case .downloadCloud:
            Polyline([8, 17, 12, 21, 16, 17])
            Line(x1: 12, y1: 12, x2: 12, y2: 21)
            Path("M20.88 18.09A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.29")
        case .shuffle:
            Polyline([16, 3, 21, 3, 21, 8])
            Line(x1: 4, y1: 20, x2: 21, y2: 3)
            Polyline([21, 16, 21, 21, 16, 21])
            Line(x1: 15, y1: 15, x2: 21, y2: 21)
            Line(x1: 4, y1: 4, x2: 9, y2: 9)
        case .rewind:
            Polygon([11, 19, 2, 12, 11, 5, 11, 19])
            Polygon([22, 19, 13, 12, 22, 5, 22, 19])
        case .upload:
            Path("M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4")
            Polyline([17, 8, 12, 3, 7, 8])
            Line(x1: 12, y1: 3, x2: 12, y2: 15)
        case .trendingDown:
            Polyline([23, 18, 13.5, 8.5, 8.5, 13.5, 1, 6])
            Polyline([17, 18, 23, 18, 23, 12])
        case .pause:
            Rect(x: 6, y: 4, width: 4, height: 16)
            Rect(x: 14, y: 4, width: 4, height: 16)
        case .arrowDownCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Polyline([8, 12, 12, 16, 16, 12])
            Line(x1: 12, y1: 8, x2: 12, y2: 16)
        case .bookmark:
            Path("M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z")
        case .alertTriangle:
            Path("M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z")
            Line(x1: 12, y1: 9, x2: 12, y2: 13)
            Line(x1: 12, y1: 17, x2: 12.01, y2: 17)
        case .userCheck:
            Path("M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2")
            Circle(cx: 8.5, cy: 7, r: 4)
            Polyline([17, 11, 19, 13, 23, 9])
        case .tablet:
            Rect(x: 4, y: 2, width: 16, height: 20)
            Line(x1: 12, y1: 18, x2: 12.01, y2: 18)
        case .alertOctagon:
            Polygon([7.86, 2, 16.14, 2, 22, 7.86, 22, 16.14, 16.14, 22, 7.86, 22, 2, 16.14, 2, 7.86, 7.86, 2])
            Line(x1: 12, y1: 8, x2: 12, y2: 12)
            Line(x1: 12, y1: 16, x2: 12.01, y2: 16)
        case .menu:
            Line(x1: 3, y1: 12, x2: 21, y2: 12)
            Line(x1: 3, y1: 6, x2: 21, y2: 6)
            Line(x1: 3, y1: 18, x2: 21, y2: 18)
        case .chrome:
            Circle(cx: 12, cy: 12, r: 10)
            Circle(cx: 12, cy: 12, r: 4)
            Line(x1: 21.17, y1: 8, x2: 12, y2: 8)
            Line(x1: 3.95, y1: 6.06, x2: 8.54, y2: 14)
            Line(x1: 10.88, y1: 21.94, x2: 15.46, y2: 14)
        case .shoppingCart:
            Circle(cx: 9, cy: 21, r: 1)
            Circle(cx: 20, cy: 21, r: 1)
            Path("M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6")
        case .folder:
            Path("M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z")
        case .users:
            Path("M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2")
            Circle(cx: 9, cy: 7, r: 4)
            Path("M23 21v-2a4 4 0 0 0-3-3.87")
            Path("M16 3.13a4 4 0 0 1 0 7.75")
        case .cornerDownLeft:
            Polyline([9, 10, 4, 15, 9, 20])
            Path("M20 4v7a4 4 0 0 1-4 4H4")
        case .monitor:
            Rect(x: 2, y: 3, width: 20, height: 14)
            Line(x1: 8, y1: 21, x2: 16, y2: 21)
            Line(x1: 12, y1: 17, x2: 12, y2: 21)
        case .minus:
            Line(x1: 5, y1: 12, x2: 19, y2: 12)
        case .helpCircle:
            Circle(cx: 12, cy: 12, r: 10)
            Path("M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3")
            Line(x1: 12, y1: 17, x2: 12.01, y2: 17)
        case .navigation2:
            Polygon([12, 2, 19, 21, 12, 17, 5, 21, 12, 2])
        case .chevronLeft:
            Polyline([15, 18, 9, 12, 15, 6])
        case .film:
            Rect(x: 2, y: 2, width: 20, height: 20)
            Line(x1: 7, y1: 2, x2: 7, y2: 22)
            Line(x1: 17, y1: 2, x2: 17, y2: 22)
            Line(x1: 2, y1: 12, x2: 22, y2: 12)
            Line(x1: 2, y1: 7, x2: 7, y2: 7)
            Line(x1: 2, y1: 17, x2: 7, y2: 17)
            Line(x1: 17, y1: 17, x2: 22, y2: 17)
            Line(x1: 17, y1: 7, x2: 22, y2: 7)
        case .moon:
            Path("M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z")
        case .shieldOff:
            Path("M19.69 14a6.9 6.9 0 0 0 .31-2V5l-8-3-3.16 1.18")
            Path("M4.73 4.73L4 5v7c0 6 8 10 8 10a20.29 20.29 0 0 0 5.62-4.38")
            Line(x1: 1, y1: 1, x2: 23, y2: 23)
        case .layout:
            Rect(x: 3, y: 3, width: 18, height: 18)
            Line(x1: 3, y1: 9, x2: 21, y2: 9)
            Line(x1: 9, y1: 21, x2: 9, y2: 9)
        case .mousePointer:
            Path("M3 3l7.07 16.97 2.51-7.39 7.39-2.51L3 3z")
            Path("M13 13l6 6")
        case .alignLeft:
            Line(x1: 17, y1: 10, x2: 3, y2: 10)
            Line(x1: 21, y1: 6, x2: 3, y2: 6)
            Line(x1: 21, y1: 14, x2: 3, y2: 14)
            Line(x1: 17, y1: 18, x2: 3, y2: 18)
        case .heart:
            Path("M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z")
        case .trendingUp:
            Polyline([23, 6, 13.5, 15.5, 8.5, 10.5, 1, 18])
            Polyline([17, 6, 23, 6, 23, 12])
        }
    }
}
