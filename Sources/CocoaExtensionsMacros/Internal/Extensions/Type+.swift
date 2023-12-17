import MacroToolkit

extension MacroToolkit.`Type` {
	var isOptional: Bool {
		description.hasPrefix("Optional<")
		|| description.hasSuffix("!")
		|| description.hasSuffix("?")
	}

	var unwrappedDescription: String {
		if description.hasPrefix("Optional<") {
			return String(description.dropFirst("Optional<".count))
			+ String(description.dropLast())
		}
		if description.hasSuffix("!") || description.hasSuffix("?") {
			return String(description.dropLast())
		}
		return description
	}
}
