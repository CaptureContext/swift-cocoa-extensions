import CocoaExtensionsMacros

@attached(accessor)
@attached(peer, names: named(loadView))
public macro CustomView() = #externalMacro(
	module: "CocoaExtensionsMacros",
	type: "CustomViewMacro"
)
