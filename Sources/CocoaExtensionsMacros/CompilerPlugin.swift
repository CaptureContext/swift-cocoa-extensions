import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CocoaExtensionsPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		CustomViewMacro.self,
		CustomWindowMacro.self
	]
}
