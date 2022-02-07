public extension Svg {
    static var pauseCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Line(x1: 10, y1: 15, x2: 10, y2: 9),
			Line(x1: 14, y1: 15, x2: 14, y2: 9),
		])
	}
}
