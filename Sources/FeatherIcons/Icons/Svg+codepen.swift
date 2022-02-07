public extension Svg {
    static var codepen: Svg {
		.icon([
			Polygon([12, 2, 22, 8.5, 22, 15.5, 12, 22, 2, 15.5, 2, 8.5, 12, 2]),
			Line(x1: 12, y1: 22, x2: 12, y2: 15.5),
			Polyline([22, 8.5, 12, 15.5, 2, 8.5]),
			Polyline([2, 15.5, 12, 8.5, 22, 15.5]),
			Line(x1: 12, y1: 2, x2: 12, y2: 8.5),
		])
	}
}
