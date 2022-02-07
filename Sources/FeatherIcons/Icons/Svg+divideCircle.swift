public extension Svg {
    static var divideCircle: Svg {
		.icon([
			Line(x1: 8, y1: 12, x2: 16, y2: 12),
			Line(x1: 12, y1: 16, x2: 12, y2: 16),
			Line(x1: 12, y1: 8, x2: 12, y2: 8),
			Circle(cx: 12, cy: 12, r: 10),
		])
	}
}
