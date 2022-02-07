public extension Svg {
    static var arrowLeftCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polyline([12, 8, 8, 12, 12, 16]),
			Line(x1: 16, y1: 12, x2: 8, y2: 12),
		])
	}
}
