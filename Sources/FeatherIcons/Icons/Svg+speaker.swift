public extension Svg {
    static var speaker: Svg {
		.icon([
			Rect(x: 4, y: 2, width: 16, height: 20, rx: 2, ry: 2),
			Circle(cx: 12, cy: 14, r: 4),
			Line(x1: 12, y1: 6, x2: 12.01, y2: 6),
		])
	}
}
