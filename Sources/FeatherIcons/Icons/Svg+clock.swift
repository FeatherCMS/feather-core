public extension Svg {
    static var clock: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Polyline([12, 6, 12, 12, 16, 14]),
		])
	}
}
