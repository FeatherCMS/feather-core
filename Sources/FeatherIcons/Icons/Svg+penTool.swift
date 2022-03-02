public extension Svg {
    static var penTool: Svg {
		.icon([
			Path("M12 19l7-7 3 3-7 7-3-3z"),
			Path("M18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5z"),
			Path("M2 2l7.586 7.586"),
			Circle(cx: 11, cy: 11, r: 2),
		])
	}
}
