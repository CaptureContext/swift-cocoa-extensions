import MacroToolkit
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct CustomWindowMacro: CustomPropertyMacro {
	public static func expansion<
		_Declaration: DeclSyntaxProtocol,
		_Context: MacroExpansionContext
	>(
		of node: AttributeSyntax,
		providingAccessorsOf declaration: _Declaration,
		in context: _Context
	) throws -> [AccessorDeclSyntax] {
		let property: ProperyInfo

		switch _validatedProperyInfo(node, declaration, context) {
		case let .success(value):
			property = value
		case let .failure(diagnostic):
			return context.diagnose(diagnostic, return: [])
		}

		return [
			AccessorDeclSyntax(
				accessorSpecifier: .keyword(.get),
				body: CodeBlockSyntax {
					"self.window as? \(raw: property.type.unwrappedDescription)"
				}
			),
			AccessorDeclSyntax(
				accessorSpecifier: .keyword(.set),
				body: CodeBlockSyntax {
					"self.window = newValue"
				}
			),
		]
	}

	public static func expansion(
		of node: AttributeSyntax,
		providingPeersOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		let property: ProperyInfo

		switch _validatedProperyInfo(node, declaration, context) {
		case let .success(value):
			property = value
		case .failure:
			// Handled in AccessorMacro expansion
			return []
		}

		let initializer: String = property.binding.initialValue?._syntax.description
		?? "\(property.type.unwrappedDescription)()"

		let accessModifier = property.accessModifier == ._open ? "open" : "public"

		let decl: DeclSyntax = """
		\(raw: accessModifier) override func loadWindow() {
			self.window = \(raw: initializer)
		}
		"""

		return [decl]
	}
}
