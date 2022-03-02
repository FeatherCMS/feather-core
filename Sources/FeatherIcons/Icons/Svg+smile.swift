public extension Svg {
    static var smile: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Path("M8 14s1.5 2 4 2 4-2 4-2"),
			Line(x1: 9, y1: 9, x2: 9.01, y2: 9),
			Line(x1: 15, y1: 9, x2: 15.01, y2: 9),
		])
	}
}
