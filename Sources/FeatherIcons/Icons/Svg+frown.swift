public extension Svg {
    static var frown: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Path("M16 16s-1.5-2-4-2-4 2-4 2"),
			Line(x1: 9, y1: 9, x2: 9.01, y2: 9),
			Line(x1: 15, y1: 9, x2: 15.01, y2: 9),
		])
	}
}
