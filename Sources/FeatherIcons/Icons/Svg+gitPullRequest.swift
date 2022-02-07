public extension Svg {
    static var gitPullRequest: Svg {
		.icon([
			Circle(cx: 18, cy: 18, r: 3),
			Circle(cx: 6, cy: 6, r: 3),
			Path("M13 6h3a2 2 0 0 1 2 2v7"),
			Line(x1: 6, y1: 9, x2: 6, y2: 21),
		])
	}
}
