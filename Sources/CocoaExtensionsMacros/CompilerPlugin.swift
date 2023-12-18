import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FoundationExtensionsPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CustomViewMacro.self,
		CustomWindowMacro.self
  ]
}
