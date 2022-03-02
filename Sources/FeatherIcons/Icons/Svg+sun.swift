public extension Svg {
    static var sun: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 5),
			Line(x1: 12, y1: 1, x2: 12, y2: 3),
			Line(x1: 12, y1: 21, x2: 12, y2: 23),
			Line(x1: 4.22, y1: 4.22, x2: 5.64, y2: 5.64),
			Line(x1: 18.36, y1: 18.36, x2: 19.78, y2: 19.78),
			Line(x1: 1, y1: 12, x2: 3, y2: 12),
			Line(x1: 21, y1: 12, x2: 23, y2: 12),
			Line(x1: 4.22, y1: 19.78, x2: 5.64, y2: 18.36),
			Line(x1: 18.36, y1: 5.64, x2: 19.78, y2: 4.22),
		])
	}
}
