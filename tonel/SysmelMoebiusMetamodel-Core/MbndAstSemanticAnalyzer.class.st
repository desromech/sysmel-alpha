"
I am an AST visitor that performs semantic analysis.
"
Class {
	#name : #MbndAstSemanticAnalyzer,
	#superclass : #MbndAstTransformVisitor,
	#instVars : [
		'scope',
		'module',
		'compilationTarget',
		'astBuilder',
		'continueOwner',
		'breakOwner'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addImplicitCVariadicCastFor: nodeRequiringCasting [
	| sourceType cvariadicType |
	sourceType := nodeRequiringCasting type.
	cvariadicType := sourceType asCVariadicTypeRequiredAt: nodeRequiringCasting.
	^ self addImplicitCastFor: nodeRequiringCasting to: cvariadicType
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addImplicitCastFor: nodeRequiringCasting to: expectedTargetType [
	| sourceType |
	sourceType := nodeRequiringCasting type.

	"Omit the cast if not needed."
	sourceType = expectedTargetType ifTrue: [
		^ nodeRequiringCasting
	].

	^ self visitNode: (MbndAstImplicitCastNode new
		position: nodeRequiringCasting;
		expression: nodeRequiringCasting;
		targetType: expectedTargetType;
		yourself)

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNode: node ]
		ifNotNil: [ node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNodesIfNeeded: nodes [
	^ nodes collect: [ :node | self analyzeNodeIfNeeded: node ]
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeNonConcreteNodeIfNeeded: node [
	"Visit the node only if it does not have a type value."
	^ node type
		ifNil: [ self visitNonConcreteNode: node ]
		ifNotNil: [ node ]
]

{ #category : #coercing }
MbndAstSemanticAnalyzer >> arithmeticCoercionTypeFor: leftType with: rightType at: position [
	| coercionType |
	coercionType := leftType arithmeticCoercionWith: rightType.
	coercionType ifNil: [ 
		self error: 'Cannot compute arithmetic coercion type with values of type {1} and type {2}.'
			format: { leftType printString . rightType printString } at: position
	].
	
	^ coercionType
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> astBuilder [
	^ astBuilder ifNil: [ astBuilder := MbndAstBuilder forModule: module ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> compilationTarget [
	^ compilationTarget ifNil: [ compilationTarget := module compilationTarget ]
]

{ #category : #coercing }
MbndAstSemanticAnalyzer >> conditionalResultCoercionTypeFor: leftType with: rightType at: node [
	^ leftType conditionalResultCoercionTypeWith: rightType

]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensureIntegerValue: node at: position [
	| result resultType |
	result := self analyzeNodeIfNeeded: node.
	resultType := result type withoutTopDecorations.
	resultType isLiteralIntegerType ifTrue: [
		^ result
	].
	resultType isPrimitiveIntegerType ifTrue: [ 
		^ result
	].

	resultType isReferenceType ifTrue: [
		^ self ensureIntegerValue: (MbndAstReferenceLoadNode new
			reference: node;
			position: position;
			yourself)
			at: position
	].

	self halt	
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensureLiteralIsConcreted: node [
	node type isLiteralValueType ifFalse: [ ^ node ].
	self assert: node isLiteralValueNode.
	^ self addImplicitCastFor: node to: (node type bestConcreteTypeForLiteralValueNode: node inScope: scope)
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensurePointerValue: node at: position [
	| result resultType |
	result := self analyzeNodeIfNeeded: node.
	resultType := result type withoutTopDecorations.
	resultType isPointerType ifTrue: [
		^ result
	].

	resultType isReferenceType ifTrue: [
		^ self ensurePointerValue: (MbndAstReferenceLoadNode new
			reference: node;
			position: position;
			yourself)
			at: position
	].

	self halt	
]

{ #category : #errors }
MbndAstSemanticAnalyzer >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: scope;
		signal
]

{ #category : #'compile time evaluation' }
MbndAstSemanticAnalyzer >> evaluateCompileTimeExpression: compileTimeExpression [
	^ MbndAstSemanticAnalyzerAndEvaluator new
		module: module;
		evaluateNode: compileTimeExpression withReturnContextInScope: scope
]

{ #category : #'compile time evaluation' }
MbndAstSemanticAnalyzer >> evaluateTypeExpression: typeExpression [
	| evaluationResult |
	typeExpression isMbndType ifTrue: [ ^ typeExpression ].
	self assert: typeExpression isMbndAstNode.
	
	evaluationResult := self evaluateCompileTimeExpression: typeExpression.
	evaluationResult type isMetaType ifFalse: [
		^ self error: 'Expected a type expression, instead of an expression evaluated to {1}.' format: { evaluationResult printString } at: typeExpression
	].

	^ evaluationResult value
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> module [
	^ module
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> scope [
	^ scope
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> scope: anObject [
	scope := anObject
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitArgumentDefinitionNode: node [
	| result |
	result := node copy.
	
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType)
	].

	result initialValue ifNil: [
		result valueType ifNil: [
			self error: 'function argument {1} requires an explicit type.' format: { result name asPrettySymbolName } at: result
		]
	] ifNotNil: [ 
		result initialValue: node initialValue.
		self halt
	].

	^ result

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitArrayElementReferenceNode: node [
	| result |
	result := node copy
		container: (self analyzeNodeIfNeeded: node container);
		index: (self analyzeNodeIfNeeded: node container);
		yourself.
		
	self halt
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAssignmentNode: node [
	| result |
	result := node copy.
	result value: (self analyzeNodeIfNeeded: node value);
		reference: (self analyzeNodeIfNeeded: node reference);
		yourself.
		
	"Make sure the reference can be assigned."
	result reference type isReferenceType ifFalse: [ 
		self error: 'Cannot assign a value to something that is not a reference.' at: result
	].
	result reference type baseType isConstantType ifTrue: [ 
		self error: 'Cannot assign a value to a constant reference.' at: node
	].

	"Add an implicit cast to the assigned value."
	result value: (self addImplicitCastFor: result value to: result reference type baseType withoutDecorations).
	
	"Return the reference after the assignment."
	result type: result reference type.	
	^ result

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitClassDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndClassType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndClassType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitCompileTimeConstantDefinitionNode: node [
	| aliasName owner alias |
	aliasName := node name.
	aliasName isMbndAnonymousSymbol ifTrue: [ 
		self error: 'Anonymous aliases are not supported, yet.' at: node
	].
	
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	(owner lookupLocalSymbol: aliasName) ifNotNil: [ :previousDefintion |
		self error: 'Alias {1} definition overrides previous definition {2}.'
			format: {aliasName asPrettySymbolName . previousDefintion} at: node
	].

	alias := MbndCompileTimeConstant new
		name: aliasName;
		valueNode: node value;
		valueScope: scope;
		yourself.
	owner
		addChild: alias;
		setLocalSymbol: aliasName value: alias.
	alias enqueueDelayedSemanticAnalysis.

	^ self astBuilder literalVoid
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandedMessageSendNode: node [
	| result receiverType method |
	result := node copy
		receiver: (node receiver ifNotNil: [:receiver | self analyzeNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector);
		arguments: (self analyzeNodesIfNeeded: node arguments).
		
	"Find the method in order to perform a typed message send."
	result receiver ifNil: [ 
		result selector isLiteralSymbolValueNode ifFalse: [ 
			self error: 'Message send without a receiver cannot have non-constant selector.' at: result
		].
	
		method := scope lookupOverloadedSelector: result selector value.
		method ifNil: [
			self error: 'Failed to find definition for scoped selector {1}.' format: { result selector value printString } at: result
		].
	
		^ method analyzeExpandedMessageSendNode: result with: self
	].

	receiverType := result receiver type.
	result selector isLiteralSymbolValueNode ifTrue: [
		^ receiverType analyzeExpandedMessageSendNode: result with: self
	].

	^ receiverType analyzeMessageSendNodeWithDynamicSelector: result with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExplicitCastNode: node [
	| result sourceType conversionRule |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		targetType: (self evaluateTypeExpression: node targetType);
		yourself.
	
	sourceType := result expression type.
	conversionRule := sourceType node: result expression convertedExplicitlyInto: result targetType.
	conversionRule ifNil: [
		self error: 'Cannot perform implicit cast from type {1} to type {2}.' format: { sourceType printString.  result targetType printString} at: node
	].
	
	result
		typeConversionRule: conversionRule;
		type: result targetType.
	^ conversionRule postProcessCastNode: result withAnalyzer: self.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitFieldDefinitionNode: node [
	| result owner fieldName field |
	result := node copy.

	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType)
	].

	result bits ifNotNil: [ 
		result bits isMbndAstNode ifTrue: [ 
			result bits: (self evaluateCompileTimeExpression: result bits) unwrapMbndValue.
			self error: 'Expected an integer value for the bit count of a field.' at: node bits
		] ifFalse: [ 
			self error: 'Expected an integer value for the bit count of a field.' at: node
		]
	].

	result initialValue ifNil: [
		result valueType ifNil: [
			self error: 'function argument {1} requires an explicit type.' format: { result name asPrettySymbolName } at: result
		]
	] ifNotNil: [ 
		result initialValue: node initialValue.
		self halt
	].

	fieldName := node name.
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	fieldName isMbndAnonymousSymbol ifFalse: [ 
		(owner lookupLocalSymbol: fieldName) ifNotNil: [ :previousDefintion |
			self error: 'Cannot redefine field {1}.' format: { fieldName asPrettySymbolName } at: result
		].
	].

	field := MbndFieldVariable new
		name: fieldName;
		valueType: result valueType;
		type: result valueType ref;
		bits: result bits;
		yourself.
	owner addField: field.

	result
		binding: field;
		type: self compilationTarget voidType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitFunctionCallNode: node [
	| result functionalType |
	result := node copy.
	result arguments isMbndAstNode ifTrue: [
		"Rewrite the node by removing the tuple object."
		result arguments isTupleNode ifTrue: [
			^ self visitNode: (result arguments: result arguments elements)
		] ifFalse: [
			self flag: 'TODO: Generate code for unwrapping the tuple.'.
			self halt
		]
	].

	result
		function: (self analyzeNodeIfNeeded: node function);
		arguments: (self visitNodesAndCollect: result arguments).
		
	functionalType := result function type withoutReferences.
	self assert: functionalType isFunctionalType.
	^ functionalType analyzeFunctionCallNode: result with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitFunctionDefinitionNode: node [
	| result |
	result := node copy.
	result prototype: (self visitNode: result prototype).
	result concreteMethod definitionNode ifNil: [ 
		result concreteMethod
			declarationPosition: result prototype;
			definitionNode: result;
			definitionScope: scope;
			enqueueDelayedSemanticAnalysis
	] ifNotNil: [ 
		self error: 'multiples definitions for method {1}.' format: { result name asPrettySymbolName } at: result
	].
	
	result type: result prototype type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitFunctionPrototypeNode: node [
	| result |
	result := node copy.
	result
		arguments: (self visitNodesAndCollect: result arguments);
		returnType: (self evaluateTypeExpression: result returnType).
		
	result functionType: (self compilationTarget
		functionTypeWithArguments: (result arguments collect: #valueType)
		returnType: result returnType
		cvariadic: node isCVariadic).
	result type: result functionType ref.
	
	result ownerProgramEntity ifNil: [
		result ownerProgramEntity: scope lookupProgramEntityForNewDefinitions
	].
	
	result name isMbndAnonymousSymbol ifFalse: [
		result ownerProgramEntity ifNotNil: [ :newOwner |
			newOwner findOrAddOverloadedFunctionPrototype: result
		].
	].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGCClassDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndGCClassType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGCClassDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndGCClassType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitIdentifierReferenceNode: node [
	| binding |
	binding := scope lookupSymbolRecursively: node symbol ifAbsent: [
		self error: 'Failed to find binding for {1}.' format: { node symbol asPrettySymbolName } at: node
	].

	^ binding analyzeReferenceNode: node with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitIfConditionNode: node [
	| result resultCoercionType |
	result := node copy.
	result condition: (self visitNode: result condition).

	result condition isLiteralValueNode ifTrue: [
		result condition type isLiteralBooleanTrueType ifTrue: [
			^ result trueValue
				ifNotNil: [ :child | self visitNode: child ]
				ifNil: [ self astBuilder literalUndefined ]
		].
	
		result condition type isLiteralBooleanFalseType ifTrue: [
			^ result falseValue
				ifNotNil: [ :child | self visitNode: child ]
				ifNil: [ self astBuilder literalUndefined ]
		].
	].
	
	result trueValue ifNil: [
		result trueValue: self astBuilder literalUndefined
	].

	result falseValue ifNil: [
		result falseValue: self astBuilder literalUndefined
	].

	result
		trueValue: (self analyzeNodeIfNeeded: result trueValue);
		falseValue: (self analyzeNodeIfNeeded: result falseValue).

	resultCoercionType := self conditionalResultCoercionTypeFor: result trueValue type
		with: result falseValue type at: result.
	resultCoercionType isVoidType ifFalse: [
		result
			trueValue: (self addImplicitCastFor: result trueValue to: resultCoercionType);
			falseValue: (self addImplicitCastFor: result falseValue to: resultCoercionType).
	].
	result type: resultCoercionType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitImplicitCastNode: node [
	| result sourceType conversionRule |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		targetType: (self evaluateTypeExpression: node targetType);
		yourself.
	
	sourceType := result expression type.
	conversionRule := sourceType node: result expression convertedImplicitlyInto: result targetType.
	conversionRule ifNil: [
		self error: 'Cannot perform implicit cast from type {1} to type {2}.' format: { sourceType printString. result targetType printString } at: node
	].
	
	result
		typeConversionRule: conversionRule;
		type: result targetType.
	^ conversionRule postProcessCastNode: result withAnalyzer: self.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitLexicalScopeNode: node [
	| result analyzedContent |
	result := node copy.
	
	self withScope: scope newLexicalScope do: [
		analyzedContent := self visitNode: result expression.
		analyzedContent isLiteralValueNode ifTrue: [ ^ analyzedContent ].
		
		result
			expression: analyzedContent;
			type: analyzedContent type.
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitLocalVariableDefinitionNode: node [
	| result valueType |
	result := node copy.
	
	"Make sure the value type is evaluated."
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType).
	].

	"Analyze the initial value."
	result initialValue ifNotNil: [
		result initialValue: (self analyzeNodeIfNeeded: result initialValue)
	].
	
	"Infer the value type, if needed"
	result valueType ifNil: [
		result initialValue ifNil: [
			self error: 'Variable {1} without an explicit type, or an initial value.' format: { node name asPrettySymbolName } at: node
		].
	
		result valueType: (result initialValue type inferValueTypeForNode: result initialValue inScope: scope).
	].

	"Cast implicitly the initial value."
	valueType := result valueType.
	result initialValue ifNotNil: [ :valueNode |
		result initialValue: (self addImplicitCastFor: valueNode to: valueType)
	].

	"Make sure there is always an initial value."
	result initialValue ifNil: [ 
		result initialValue: (result valueType defaultValueASTNode
			position: result;
			yourself)
	].

	"Compute the variable reference type"
	self assert: valueType isNotNil.
	result isMutable ifTrue: [
		result type: valueType ref
	] ifFalse: [
		result isAccessedByReference ifTrue: [ 
			result type: valueType const ref
		] ifFalse: [ 
			result type: valueType
		]
	].

	"Create a matching variable"
	result binding: (MbndFunctionLocalVariable new
		definitionNode: result;
		name: node name;
		valueType: valueType;
		type: result type;
		yourself
	).

	"Add the variable to the current scope."
	scope addSymbol: result name binding: result binding ifPresent: [ :previousDefinition |
		self error: 'Variable {1} overrides a previous definition in the same scope.' format: { result name asPrettySymbolName } at: { result }
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMacroMessageDefinitionNode: node [
	| result |
	result := node copy.
	result prototype: (self visitNode: result prototype).
	result concreteMethod definitionNode ifNil: [
		result concreteMethod
			declarationPosition: result prototype;
			definitionNode: result;
			definitionScope: (result prototype ownerProgramEntity programEntityScope parent: scope);
			enqueueDelayedSemanticAnalysis
	] ifNotNil: [ 
		self error: 'multiples definitions for macro with selector {1}.' format: { result selector asPrettySymbolName } at: result
	].
	
	result type: result prototype type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMacroMessagePrototypeNode: node [
	| result |
	result := node copy.
	result
		arguments: (result arguments collect: [:arg |
			self visitNode: (arg valueType
				ifNil: [ arg copy valueType: self compilationTarget astNodeType ]
				ifNotNil: [ arg ])
		]);
		returnType: (result returnType
			ifNil: [ self compilationTarget astNodeType ]
			ifNotNil: [self evaluateTypeExpression: result returnType]).
		
	result functionType: (self compilationTarget
		functionTypeWithArguments: (result arguments collect: #valueType)
		returnType: result returnType).
	result type: result functionType ref.
	
	result ownerProgramEntity ifNil: [
		result ownerProgramEntity: scope lookupProgramEntityForNewDefinitions
	].

	result ownerProgramEntity ifNotNil: [ :newOwner |
		newOwner findOrAddMacroSelectorPrototype: result
	].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMessageDefinitionNode: node [
	| result |
	result := node copy.
	result prototype: (self visitNode: result prototype).
	result concreteMethod definitionNode ifNil: [ 
		result concreteMethod
			declarationPosition: result prototype;
			definitionNode: result;
			definitionScope: scope;
			enqueueDelayedSemanticAnalysis
	] ifNotNil: [ 
		self error: 'multiples definitions for method with selector {1}.' format: { result selector asPrettySymbolName } at: result
	].
	
	result type: result prototype type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMessagePrototypeNode: node [
	| result |
	result := node copy.
	result
		arguments: (self visitNodesAndCollect: result arguments);
		returnType: (self evaluateTypeExpression: result returnType).
		
	result functionType: (self compilationTarget
		functionTypeWithArguments: (result arguments collect: #valueType)
		returnType: result returnType).
	result type: result functionType ref.
	
	result ownerProgramEntity ifNil: [
		result ownerProgramEntity: scope lookupProgramEntityForNewDefinitions
	].

	result ownerProgramEntity ifNotNil: [ :newOwner |
		newOwner findOrAddOverloadedSelectorPrototype: result
	].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNamespaceDefinitionNode: node [
	| namespaceName owner namespace |
	namespaceName := node name.
	namespaceName isMbndAnonymousSymbol ifTrue: [ 
		self error: 'Anonymous namespace are not supported, yet.' at: node
	].
	
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	namespace := owner ensureSymbolIsNamespace: namespaceName at: node.
	self assert: namespace isNotNil.
	
	self withScope: (namespace programEntityScope parent: scope) newLexicalScope do: [ 
		self visitNode: node body
	].

	^ self astBuilder literalVoid
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNode: node [
	^ (node accept: self) concretizeNodeWithAnalyzer: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNonConcreteNode: node [
	^ node accept: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPointerAsReferenceNode: node [
	| result basePointerType |
	result := super visitPointerAsReferenceNode: node.
	basePointerType := result pointer type withoutTopDecorations.
	basePointerType isPointerType ifFalse: [
		self error: 'Expected a pointer value.' at: node pointer.
	].

	^ result
		type: result pointer type asReferenceType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPointerElementReferenceNode: node [
	| result pointerType elementReferenceType |
	result := node copy
		container: (self ensurePointerValue: node container at: node);
		index: (self ensureIntegerValue: node index at: node);
		yourself.
		
	pointerType := node container type withoutTopDecorations.
	self assert: pointerType isPointerType.
	
	elementReferenceType := pointerType asReferenceType.
	result type: elementReferenceType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitQuasiQuoteNode: node [
	| result |
	result := node copy.
	result type: self compilationTarget astNodeType.
	
	result expression: (MbndAstQuasiQuoteSemanticAnalyzer new
		unquoteAnalyzer: self;
		visitNode: result expression
	).
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitQuasiUnquoteNode: node [
	self error: 'Quasi unquote (e.g: `, ) expressions are only valid inside of a quasi quote.' at: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitQuoteNode: node [
	^ node copy
		type: self compilationTarget astNodeType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReferenceAsPointerNode: node [
	| result basePointerType |
	result := super visitReferenceAsPointerNode: node.
	basePointerType := result reference type withoutTopDecorations.
	basePointerType isReferenceType ifFalse: [
		self error: 'Expected a reference value.' at: node pointer.
	].

	^ result
		type: result reference type asPointerType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReferenceLoadNode: node [
	| result |
	result := node copy.
	result reference: (self analyzeNodeIfNeeded: node reference);
		yourself.
		
	"Make sure the reference can be assigned."
	result reference type isReferenceType ifFalse: [ 
		self error: 'Cannot assign a value to something that is not a reference.' at: result
	].

	"Return the reference after the assignment."
	result type: result reference type baseType withoutDecorations.	
	^ result

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReinterpretCastNode: node [
	| result sourceType |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		targetType: (self evaluateTypeExpression: node targetType);
		yourself.
	
	sourceType := result expression type.
	^ sourceType analyzeReinterpretCastNode: result to: result targetType with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReturnStatementNode: node [
	| result |
	result := node copy
		expression: (self visitNode: node expression);
		type: self compilationTarget returnType.

	scope returnType ifNotNil: [ :expectedReturnType |
		result expression: (self addImplicitCastFor: result expression to: expectedReturnType)
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSequenceNode: node [
	| result explicitReturnIndex |
	result := super visitSequenceNode: node.
	result elements ifEmpty: [
		result type: self compilationTarget voidType
	] ifNotEmpty: [
		"Remove sequences with a single element."
		result elements size = 1 ifTrue: [ ^ result elements first ].
		
		"If there is an explicit return, cut the analyzer elements."
		explicitReturnIndex := result elements detectIndex: [ :el | el type isReturnType ] ifNone: [ result elements size + 1 ].
		explicitReturnIndex < result elements size ifTrue: [ 
			result elements: (result elements first: explicitReturnIndex).
		].
	
		result elements at: result elements size put: (self ensureLiteralIsConcreted: result elements last).
		result type: result elements last type
	].
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSpecificCastNode: node [
	| result |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		targetType: (self evaluateTypeExpression: node targetType);
		yourself.
	result type: result targetType.
	self flag: 'TODO: Add validation checks.'.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSpliceNode: node [
	self error: 'Splice expressions (e.g: `@ ) are only valid inside of a quasi quote.' at: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitStructureDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndStructureType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitStructureDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndStructureType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTemplateDefinitionNode: node [
	| result owner template |
	result := node copy
		arguments: (self visitNodesAndCollect: node arguments);
		yourself.
	
	owner := result ownerProgramEntity ifNil: [ scope lookupProgramEntityForNewDefinitions ].
	result name isMbndAnonymousSymbol ifFalse: [ 
		(owner lookupLocalSymbol: result name) ifNotNil: [
			self error: 'Template {1} override a previous definition.' format: { node name asPrettySymbolName } at: result
		].
	].

	template := MbndTemplate new
		name: result name;
		definitionPosition: result;
		argumentDefinitions: result arguments;
		mainDefinitionBody: result body scope: scope;
		yourself.
		
	owner addChild: template.
	template name isMbndAnonymousSymbol ifFalse: [ 
		owner setLocalSymbol: template name value: template
	].

	^ result
		binding: template;
		type: template type;
		yourself

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTupleNode: node [
	| result |
	result := super visitTupleNode: node.
	^ result
		type: (self compilationTarget tuple: (result elements collect: #type));
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTypeDeclarationNode: node ofKind: typeKindClass [
	| result owner type |
	(node name isMbndAnonymousSymbol and: [ node isPartOfDefinition not ]) ifTrue: [
		self error: 'Anonymous declaration of types are forbidden. Only anonymous definitions are allowed.' at: node
	].
	
	result := node copy.
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].

	type := nil.
	node name isMbndAnonymousSymbol ifFalse: [ 
		(owner lookupLocalSymbol: node name) ifNotNil: [ :previousDefintion |
			previousDefintion class == typeKindClass ifFalse: [ 
				self error: 'Cannot redefine symbol {1} as a type of another kind.' format: { node name asPrettySymbolName } at: result
			].
	
			type := previousDefintion.
		].
	].

	type ifNil: [ 
		type := self compilationTarget createNamedType: result name ofKind: typeKindClass.
		owner addChild: type.
		type name isMbndAnonymousSymbol ifFalse: [ 
			owner setLocalSymbol: type name value: type.
		].
	].
	result binding: type.

	type enqueueDelayedSemanticAnalysis.
	result type: type type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTypeDefinitionNode: node ofKind: typeKindClass [
	| result definitionScope |
	result := node copy.
	result declaration: (self visitNode: result declaration ensurePartOfDefinitionFlagIsMarked).

	"Set the defined flag"
	result binding addFlag: #defined.
	
	"Create a new lexical scope for the definition body."	
	definitionScope := (result binding programEntityScope parent: scope) newLexicalScope.
	
	"Analyze the definition body."
	self withScope: definitionScope do: [ 
		result body: (self evaluateCompileTimeExpression: result body)
	].

	"Enqueue the result semantic analysis."
	result binding enqueueDelayedSemanticAnalysis.
	
	"Pass through the declaration result."
	result type: result declaration type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnexpandedMessageSendNode: node [
	| result selector macroMethod |
	result := node copy
		receiver: (node receiver ifNotNil: [self analyzeNonConcreteNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector);
		yourself.

	result receiver ifNotNil: [
		^ result receiver type analyzeUnexpandedMessageSendNode: result with: self
	].

	result selector isLiteralSymbolValueNode ifFalse: [
		^ self error: 'Invalid message send without receiver. The selector must be a constant.' at: node
	].

	selector := result selector value.
	macroMethod := scope lookupMacroSelector: selector.
	macroMethod ifNil: [
		^ self visitNode: result asExpandedMessageSend
	].

	"Apply the macro method."
	^ macroMethod expandMessageNode: result with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnionDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndUnionType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnionDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndUnionType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitWhileLoopNode: node [
	| result |
	result := node copy.
	result
		condition: (self visitNode: result condition);
		type: self compilationTarget voidType.
	
	self withContinueAndBreakOwnerNode: node do: [ 
		result action: (result action ifNotNil: [:action | self analyzeNodeIfNeeded: action]).
	].

	result	 continueAction: (result continueAction ifNotNil: [:action | self analyzeNodeIfNeeded: action]).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> withContinueAndBreakOwnerNode: continueAndBreakOwner do: aBlock [
	| oldContinueOwner oldBreakOwner |
	oldContinueOwner := continueOwner.
	oldBreakOwner := breakOwner.

	continueOwner := continueAndBreakOwner.
	breakOwner := continueAndBreakOwner.
	aBlock ensure: [
		continueOwner := oldContinueOwner.
		breakOwner := oldBreakOwner.
	]
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> withScope: newAnalysisScope do: aBlock [
	| oldAnalysisScope |
	oldAnalysisScope := scope.
	scope := newAnalysisScope.
	
	^ aBlock ensure: [ 
		scope := oldAnalysisScope
	]
]
