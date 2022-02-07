public extension Svg {
    static var plusSquare: Svg {
		.icon([
			Rect(x: 3, y: 3, width: 18, height: 18),
			Line(x1: 12, y1: 8, x2: 12, y2: 16),
			Line(x1: 8, y1: 12, x2: 16, y2: 12),
		])
	}
}
