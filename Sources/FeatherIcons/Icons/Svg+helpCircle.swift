public extension Svg {
    static var helpCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Path("M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"),
			Line(x1: 12, y1: 17, x2: 12.01, y2: 17),
		])
	}
}
