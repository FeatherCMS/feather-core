public extension Svg {
    static var arrowUpCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polyline([16, 12, 12, 8, 8, 12]),
			Line(x1: 12, y1: 16, x2: 12, y2: 8),
		])
	}
}
