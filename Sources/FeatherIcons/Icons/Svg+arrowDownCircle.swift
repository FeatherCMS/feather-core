public extension Svg {
    static var arrowDownCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polyline([8, 12, 12, 16, 16, 12]),
			Line(x1: 12, y1: 8, x2: 12, y2: 16),
		])
	}
}
