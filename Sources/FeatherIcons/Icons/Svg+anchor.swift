public extension Svg {
    static var anchor: Svg {
		.icon([
			Circle(cx: 12, cy: 5, r: 3),
			Line(x1: 12, y1: 22, x2: 12, y2: 8),
			Path("M5 12H2a10 10 0 0 0 20 0h-3"),
		])
	}
}
