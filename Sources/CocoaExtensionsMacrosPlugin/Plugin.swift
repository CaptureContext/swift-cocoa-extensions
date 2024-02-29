import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacrosPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		CustomViewMacro.self,
		CustomWindowMacro.self
	]
}
