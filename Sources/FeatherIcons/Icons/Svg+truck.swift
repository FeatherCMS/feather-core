public extension Svg {
    static var truck: Svg {
		.icon([
			Rect(x: 1, y: 3, width: 15, height: 13),
			Polygon([16, 8, 20, 8, 23, 11, 23, 16, 16, 16, 16, 8]),
			Circle(cx: 5.5, cy: 18.5, r: 2.5),
			Circle(cx: 18.5, cy: 18.5, r: 2.5),
		])
	}
}
