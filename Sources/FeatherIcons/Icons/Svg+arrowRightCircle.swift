public extension Svg {
    static var arrowRightCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polyline([12, 16, 16, 12, 12, 8]),
			Line(x1: 8, y1: 12, x2: 16, y2: 12),
		])
	}
}
