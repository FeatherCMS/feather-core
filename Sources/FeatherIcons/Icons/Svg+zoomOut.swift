public extension Svg {
    static var zoomOut: Svg {
		.icon([
			Circle(cx: 11, cy: 11, r: 8),
			Line(x1: 21, y1: 21, x2: 16.65, y2: 16.65),
			Line(x1: 8, y1: 11, x2: 14, y2: 11),
		])
	}
}
