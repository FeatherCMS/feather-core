public extension Svg {
    static var xSquare: Svg {
		.icon([
			Rect(x: 3, y: 3, width: 18, height: 18, rx: 2, ry: 2),
			Line(x1: 9, y1: 9, x2: 15, y2: 15),
			Line(x1: 15, y1: 9, x2: 9, y2: 15),
		])
	}
}
