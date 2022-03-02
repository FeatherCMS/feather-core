public extension Svg {
    static var globe: Svg {
		.icon([
			Circle(cx: 12, cy: 12, r: 10),
			Line(x1: 2, y1: 12, x2: 22, y2: 12),
			Path("M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"),
		])
	}
}
