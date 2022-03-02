public extension Svg {
    static var playCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polygon([10, 8, 16, 12, 10, 16, 10, 8]),
		])
	}
}
