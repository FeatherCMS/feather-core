public extension Svg {
    static var xCircle: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Line(x1: 15, y1: 9, x2: 9, y2: 15),
			Line(x1: 9, y1: 9, x2: 15, y2: 15),
		])
	}
}
