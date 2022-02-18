public extension Svg {
    static var image: Svg {
		.icon([
			Rect(x: 3, y: 3, width: 18, height: 18, rx: 2, ry: 2),
			Circle(cx: 8.5, cy: 8.5, r: 1.5),
			Polyline([21, 15, 16, 10, 5, 21]),
		])
	}
}
