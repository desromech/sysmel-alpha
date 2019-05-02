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
		'astBuilder'
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

	^ sourceType createNode: nodeRequiringCasting implicitCastTo: expectedTargetType with: self
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
	leftType == rightType ifTrue: [ ^ leftType ].
	(leftType isReferenceType or:
	[ leftType isDecorationType or:
	[ rightType isReferenceType or:
	[ rightType isDecorationType ]]]) ifTrue: [
		^ self arithmeticCoercionTypeFor: leftType withoutReferences withoutDecorations
			with: rightType withoutReferences withoutDecorations at: position
	].

	self halt
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> astBuilder [
	^ astBuilder ifNil: [ astBuilder := MbndAstBuilder forModule: module ]
]

{ #category : #accessing }
MbndAstSemanticAnalyzer >> compilationTarget [
	^ compilationTarget ifNil: [ compilationTarget := module compilationTarget ]
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensureLiteralIsConcreted: node [
	node type isLiteralValueType ifFalse: [ ^ node ].
	self assert: node isLiteralValueNode.
	^ self addImplicitCastFor: node to: (node type bestConcreteTypeForLiteralValueNode: node inScope: scope)
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
	| returnContext evaluator |
	returnContext := MbndReturnContextScope parent: scope.
	
	evaluator := MbndAstSemanticAnalyzerAndEvaluator new
		module: module;
		scope: returnContext newLexicalScope.
		
	[
		^ evaluator visitNode: compileTimeExpression
	] on: MbndEvaluationReturn do: [ :e |
		e targetReturnContext == returnContext
			ifTrue: [ ^ e returnValue ]
			ifFalse: [ ^ e pass ]
	]
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

{ #category : #'as yet unclassified' }
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
MbndAstSemanticAnalyzer >> visitCompileTimeConstantDefinitionNode: node [
	| aliasName owner alias |
	aliasName := node name.
	aliasName isMbndAnonymousSymbol ifTrue: [ 
		self error: 'Anonymous aliases are not supported, yet.' at: node
	].
	
	owner := scope lookupProgramEntityForNewDefinitions.
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
		setLocalSymbol: aliasName value: alias;
		enqueueDelayedSemanticAnalysis.

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
	result prototype: (self visitNode: node prototype).
	result concreteMethod definitionNode ifNil: [ 
		result concreteMethod
			declarationPosition: result prototype;
			definitionNode: result;
			definitionScope: scope;
			enqueueDelayedSemanticAnalysis
	] ifNotNil: [ 
		self error: 'multiples definitions for method {1}.' format: { node name asPrettySymbolName } at: node
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
MbndAstSemanticAnalyzer >> visitIdentifierReferenceNode: node [
	| binding |
	binding := scope lookupSymbolRecursively: node symbol ifAbsent: [
		self error: 'Failed to find binding for {1}.' format: { node symbol asPrettySymbolName } at: node
	].

	^ binding analyzeReferenceNode: node with: self
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitIfConditionNode: node [
	| result |
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

	self halt
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
MbndAstSemanticAnalyzer >> visitMessageDefinitionNode: node [
	| result |
	result := node copy.
	result prototype: (self visitNode: node prototype).
	result concreteMethod definitionNode ifNil: [ 
		result concreteMethod
			declarationPosition: node prototype;
			definitionNode: node;
			definitionScope: scope;
			enqueueDelayedSemanticAnalysis
	] ifNotNil: [ 
		self error: 'multiples definitions for method with selector {1}.' format: { node selector asPrettySymbolName } at: node
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
	
	owner := scope lookupProgramEntityForNewDefinitions.
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

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
MbndAstSemanticAnalyzer >> withScope: newAnalysisScope do: aBlock [
	| oldAnalysisScope |
	oldAnalysisScope := scope.
	scope := newAnalysisScope.
	
	^ aBlock ensure: [ 
		scope := oldAnalysisScope
	]
]
