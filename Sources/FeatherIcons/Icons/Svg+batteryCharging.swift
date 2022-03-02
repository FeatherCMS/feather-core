public extension Svg {
    static var batteryCharging: Svg {
		.icon([
			Path("M5 18H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3.19M15 6h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-3.19"),
			Line(x1: 23, y1: 13, x2: 23, y2: 11),
			Polyline([11, 6, 7, 12, 13, 12, 9, 18]),
		])
	}
}
