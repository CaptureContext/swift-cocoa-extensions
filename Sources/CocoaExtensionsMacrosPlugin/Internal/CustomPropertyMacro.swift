import MacroToolkit
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct ProperyInfo {
	var attribute: AttributeSyntax
	var binding: VariableBinding
	var accessModifier: AccessModifier?
	var name: String
	var type: Type

	enum AccessModifier {
		case _private
		case _fileprivate
		case _internal
		case _package
		case _public
		case _open

		init?(_ modifier: DeclModifierListSyntax.Element) {
			switch modifier.trimmedDescription {
			case "private":
				self = ._private
			case "fileprivate":
				self = ._fileprivate
			case "internal":
				self = ._internal
			case "package":
				self = ._package
			case "public":
				self = ._public
			case "open":
				self = ._open
			default:
				return nil
			}
		}
	}
}

public protocol CustomPropertyMacro: AccessorMacro, PeerMacro {
	static var macroName: String { get }
}

extension CustomPropertyMacro {
	public static var macroName: String {
		let typeName = String(describing: self)
		return typeName.hasSuffix("Macro")
		? String(typeName.dropLast("Macro".count))
		: typeName
	}

	static func _validatedProperyInfo<
		_Declaration: DeclSyntaxProtocol,
		_Context: MacroExpansionContext
	>(
		_ node: AttributeSyntax,
		_ declaration: _Declaration,
		_ context: _Context
	) -> Result<ProperyInfo, Diagnostic> {
		guard let decl = Decl(declaration).asVariable else {
			return .failure(.requiresComputedProperty(macroName, declaration))
		}

		guard
			let binding = destructureSingle(decl.bindings),
			decl._syntax.bindingSpecifier.tokenKind != .keyword(.let),
			let name = binding.identifier
		else {
			return .failure(.requiresComputedProperty(macroName, decl._syntax.bindingSpecifier))
		}

		guard let type = binding.type else {
			return .failure(.requiresExplicitType(macroName, decl._syntax.bindingSpecifier))
		}
		guard type.isOptional else {
			return .failure(.requiresOptionalType(macroName, type._baseSyntax))
		}

		let getter = binding.accessors.first(
			where: \.accessorSpecifier.tokenKind == .keyword(.get)
		)

		if let getter {
			return .failure(.unexpectedGetAccessor(macroName, getter.accessorSpecifier))
		}

		let setter = binding.accessors.first(
			where: \.accessorSpecifier.tokenKind == .keyword(.set)
		)

		if let setter {
			return .failure(.unexpectedSetAccessor(macroName, setter.accessorSpecifier))
		}

		let willSetHandler = binding.accessors.first(
			where: \.accessorSpecifier.tokenKind == .keyword(.willSet)
		)

		if let willSetHandler {
			return .failure(.unexpectedWillSetHandler(macroName, willSetHandler.accessorSpecifier))
		}

		let didSetHandler = binding.accessors.first(
			where: \.accessorSpecifier.tokenKind == .keyword(.didSet)
		)

		if let didSetHandler {
			return .failure(.unexpectedDidSetHandler(macroName, didSetHandler.accessorSpecifier))
		}

		let accessModifier = decl._syntax.modifiers
			.compactMap(ProperyInfo.AccessModifier.init)
			.first

		return .success(.init(
			attribute: node,
			binding: binding, 
			accessModifier: accessModifier,
			name: name,
			type: type
		))
	}
}

extension Diagnostic {
	fileprivate static func requiresComputedProperty(
		_ macroName: String,
		_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "requeres_computed_property")
			.message("`@\(macroName)` must be attached to a computed property declaration.")
			.build()
	}

	fileprivate static func requiresExplicitType(
			_ macroName: String,
			_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "requres_explicit_type")
			.message("`@\(macroName)` requires explicit type declaration.")
			.build()
	}


	fileprivate static func unexpectedGetAccessor(
		_ macroName: String,
		_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "unexpected_get_accessor")
			.message("`@\(macroName)` does not support custom `get` accessors")
			.build()
	}

	fileprivate static func unexpectedSetAccessor(
		_ macroName: String,
		_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "unexpected_set_accessor")
			.message("`@\(macroName)` does not support custom `set` accessors")
			.build()
	}

	fileprivate static func unexpectedWillSetHandler(
		_ macroName: String,
		_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "unexpected_set_accessor")
			.message("`@\(macroName)` does not support custom `willSet` handlers")
			.build()
	}

	fileprivate static func unexpectedDidSetHandler(
		_ macroName: String,
		_ node: some SyntaxProtocol
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "unexpected_set_accessor")
			.message("`@\(macroName)` does not support custom `didSet` handlers")
			.build()
	}

	fileprivate static func requiresOptionalType(
		_ macroName: String,
		_ node: TypeSyntax
	) -> Self {
		DiagnosticBuilder(for: node)
			.messageID(domain: macroName, id: "requres_optional_type")
			.message("`@\(macroName)` requires property to be of Optional type")
			.suggestReplacement(
				"Add exclamation mark",
				old: node,
				new: ImplicitlyUnwrappedOptionalTypeSyntax(wrappedType: node)
			)
			.build()
	}
}
