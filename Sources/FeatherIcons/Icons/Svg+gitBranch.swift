public extension Svg {
    static var gitBranch: Svg {
		.icon([
			Line(x1: 6, y1: 3, x2: 6, y2: 15),
			Circle(cx: 18, cy: 6, r: 3),
			Circle(cx: 6, cy: 18, r: 3),
			Path("M18 9a9 9 0 0 1-9 9"),
		])
	}
}
