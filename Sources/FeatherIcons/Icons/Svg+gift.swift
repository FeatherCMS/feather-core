public extension Svg {
    static var gift: Svg {
		.icon([
			Polyline([20, 12, 20, 22, 4, 22, 4, 12]),
			Rect(x: 2, y: 7, width: 20, height: 5),
			Line(x1: 12, y1: 22, x2: 12, y2: 7),
			Path("M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"),
			Path("M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"),
		])
	}
}
