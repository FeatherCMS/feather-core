public extension Svg {
    static var crosshair: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Line(x1: 22, y1: 12, x2: 18, y2: 12),
			Line(x1: 6, y1: 12, x2: 2, y2: 12),
			Line(x1: 12, y1: 6, x2: 12, y2: 2),
			Line(x1: 12, y1: 22, x2: 12, y2: 18),
		])
	}
}
