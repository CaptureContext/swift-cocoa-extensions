#if !os(watchOS)
@attached(accessor)
@attached(peer, names: named(loadView))
public macro CustomView() = #externalMacro(
	module: "CocoaExtensionsMacrosPlugin",
	type: "CustomViewMacro"
)
#endif

#if os(macOS)
@attached(accessor)
@attached(peer, names: named(loadWindow))
public macro CustomWindow() = #externalMacro(
	module: "CocoaExtensionsMacrosPlugin",
	type: "CustomWindowMacro"
)
#endif
