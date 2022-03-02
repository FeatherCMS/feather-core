public extension Svg {
    static var move: Svg {
		.icon([
			Polyline([5, 9, 2, 12, 5, 15]),
			Polyline([9, 5, 12, 2, 15, 5]),
			Polyline([15, 19, 12, 22, 9, 19]),
			Polyline([19, 9, 22, 12, 19, 15]),
			Line(x1: 2, y1: 12, x2: 22, y2: 12),
			Line(x1: 12, y1: 2, x2: 12, y2: 22),
		])
	}
}
