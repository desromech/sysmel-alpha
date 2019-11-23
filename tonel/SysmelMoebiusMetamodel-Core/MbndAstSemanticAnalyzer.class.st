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

	sourceType isReturnType ifTrue: [
		^ nodeRequiringCasting
	].

	expectedTargetType isVoidType ifTrue: [
		^ nodeRequiringCasting
	].

	^ self visitNode: (MbndAstImplicitCastNode new
		position: nodeRequiringCasting;
		expression: nodeRequiringCasting;
		targetType: expectedTargetType;
		yourself)

]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addReceiverImplicitCastFor: nodeRequiringCasting to: expectedTargetType [
	| sourceType temporaryVariable |
	sourceType := nodeRequiringCasting type.
	
	"Aggregate value -> aggregate mutable reference. We need to create a temporary value in this special case."
	(expectedTargetType isReferenceType and: [ sourceType withoutTopDecorations isReferenceType not ]) ifTrue: [
		temporaryVariable := (self astBuilder defineLocalVariable: #_ withValueType: nil withInitialValue: nodeRequiringCasting)
			position: nodeRequiringCasting;
			mutable.
		^ self addImplicitCastFor: (self visitNode: temporaryVariable) to: expectedTargetType
	].

	^ self addImplicitCastFor: nodeRequiringCasting to: expectedTargetType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeEnumDefinition: enumDefinition values: values [
	| enumType evaluatedDictionary convertedDictionary valueType |
	enumType := enumDefinition binding.
	evaluatedDictionary := values isMbndAstNode ifTrue: [
		values isDictionaryNode ifTrue: [
			self evaluateEnum: enumType literalDictionaryNode: values
		] ifFalse: [
			self evaluateCompileTimeExpression: values.
		]
	] ifFalse: [ values ].

	(evaluatedDictionary type isLiteralDictionaryType or: [ evaluatedDictionary isDictionaryType ]) ifFalse: [ 
		self error: 'Expected a dictionary, or an expression that evaluates to a dictionary for the values for enumeration {1}.' format: { enumType name asPrettySymbolName } at: enumDefinition
	].

	self assert: evaluatedDictionary value isDictionary.
	convertedDictionary := evaluatedDictionary value species new.
	valueType := enumType valueType.
	evaluatedDictionary value keysAndValuesDo: [ :key :value |
		convertedDictionary at: key put:
			(valueType isPrimitiveType
				ifTrue: [ value copy type: enumType ]
				ifFalse: [ MbndValue value: value type: enumType ])
	].

	enumType values: convertedDictionary
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

{ #category : #coercing }
MbndAstSemanticAnalyzer >> arithmeticCoercionTypeFor: leftType with: rightType leftNode: leftNode rightNode: rightNode at: position [
	| coercionType |
	coercionType := leftType arithmeticCoercionWith: rightType leftNode: leftNode rightNode: rightNode inScope: scope.
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

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> computeImplicitCoercionCostFor: argumentNode to: expectedType at: node [
	| conversionRule |
	self assert: argumentNode type isNotNil.
	
	argumentNode type == expectedType ifTrue: [ ^ 0 ].
		
	conversionRule := argumentNode type node: argumentNode convertedImplicitlyInto: expectedType.
	conversionRule ifNil: [ ^ nil ].
	
	^ conversionRule conversionCost
]

{ #category : #coercing }
MbndAstSemanticAnalyzer >> conditionalResultCoercionTypeFor: leftType node: leftNode with: rightType node: rightNode at: node [
	^ leftType conditionalResultCoercionTypeWith: rightType leftNode: leftNode rightNode: rightNode inScope: scope

]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensureIntegerValue: node at: position [
	| result resultType |
	result := self analyzeNodeIfNeeded: node.
	resultType := result type withoutTopDecorations.
	resultType isLiteralIntegerType ifTrue: [
		^ self ensureLiteralIsConcreted: result
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
	^ self addImplicitCastFor: node to: (node type standardConcreteTypeForLiteralValueNode: node inScope: scope)
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> ensureValue: valueNode isVectorOrScalarOfType: requiredElementType [
	| cleanValueType |
	cleanValueType := valueNode type withoutReferences withoutTopDecorations.
	self flag: 'TODO: Support implicit casting of vectors.'.
	cleanValueType isPrimitiveVectorType ifTrue: [
		cleanValueType elementType ~~ requiredElementType ifTrue: [ 
			self error: 'Expected a scalar or vector whose elements are of type {1} instead of a value of type {2}.' format: { requiredElementType asString . cleanValueType asString }.
		].
		^ self addImplicitCastFor: valueNode to: cleanValueType
	] ifFalse: [
		^ self addImplicitCastFor: valueNode to: requiredElementType
	]
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> evaluateEnum: enumType literalDictionaryNode: dictionaryNode [
	| dictionary lastValue |
	self assert: dictionaryNode isDictionaryNode.
	dictionary := OrderedDictionary new.
	lastValue := nil.
	
	self withScope: scope newLexicalScope do: [ 
		dictionaryNode elements do: [ :valueDefinition |
			| association |
			association := self evaluateEnum: enumType valueDefinition: valueDefinition lastValue: lastValue.
			scope addSymbol: association key binding: association value ifPresent: [ 
				self error: 'Enum {1} symbol {2} is duplicated.' format: { enumType asPrettySymbolName . association key asPrettySymbolName } at: valueDefinition
			].
		
			dictionary add: association.
			lastValue := association value
		].
	].

	^ MbndValue value: dictionary type: compilationTarget literalDictionaryType
	
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> evaluateEnum: enumType valueDefinition: valueDefinition lastValue: lastValue [
	| key value evaluatedValue |
	valueDefinition isAssociationNode ifTrue: [
		key := self evaluateCompileTimeExpression: valueDefinition key.
		key type isLiteralSymbolType ifFalse: [
			(key type isCompilerObjectType and: [ key value isSymbol not ]) ifTrue: [ 
				self error: 'Expected a symbol for the key definition for enum elements.' at: valueDefinition key.
			]
		].
	
		value := valueDefinition value ifNil: [
			self generateValueForEnum: enumType withLastValue: lastValue at: valueDefinition
		] ifNotNil: [ :valueNode |
			self evaluateCompileTimeExpression: (self addImplicitCastFor: valueNode to: enumType valueType).
		].
		self assert: value type == enumType valueType.
		^ key value -> value
	].

	valueDefinition isLiteralSymbolValueNode ifTrue: [
		^ valueDefinition value -> (self generateValueForEnum: enumType withLastValue: lastValue at: valueDefinition)
	].

	evaluatedValue := self evaluateCompileTimeExpression: valueDefinition.
	evaluatedValue type isAssociationType ifTrue: [ 
		self halt.
	].

	evaluatedValue type isLiteralAssociationType ifTrue: [ 
		self halt.
	].

	self halt
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> generateValueForEnum: enumType withLastValue: lastValue at: node [
	| valueType |
	valueType := enumType valueType.
	valueType isPrimitiveNumberType ifFalse: [ 
		self error: 'Cannot generate automatically an enumeration value with non-numerical type {1}.' format: { valueType name asPrettySymbolName } at: node
	].

	lastValue ifNil: [ ^ valueType defaultValueAt: node].
	^ MbndValue value: lastValue value + 1 type: lastValue type
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
	| result containerType arrayType elementType |
	result := node copy
		container: (self analyzeNodeIfNeeded: node container);
		index: (self ensureIntegerValue: (self analyzeNodeIfNeeded: node index) at: node);
		yourself.
		
	containerType := result container type.
	containerType isReferenceType ifFalse: [
		self error: 'An array reference is required for getting a refence to one of its elements.' at: node
	].

	arrayType := containerType baseType withoutDecorations.
	arrayType isArrayType ifFalse: [
		self error: 'An array reference is required for getting a refence to one of its elements.' at: node
	].
	
	elementType := arrayType elementType.
	result type: ((elementType withDecorations: containerType baseType decorations)
		refFor: containerType addressSpace).
	 
	^ result
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
	result value: (self addImplicitCastFor: result value to: result reference type baseType withoutTopDecorations).
	
	"Return the reference after the assignment."
	result type: result reference type.	
	^ result

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAssociationNode: node [
	| result associationType |
	result := super visitAssociationNode: node.
	associationType := result key type --> result value type.
	result type: associationType.
	^ result type correctAssociationTypeForNode: result withAnalyzer: self.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitBlockClosureNode: node [
	| result bodyScope resultType blockClosureEntity owner |
	result := node copy.
	result
		arguments: (self visitNodesAndCollect: result arguments);
		returnType: (result returnType ifNotNil: [self evaluateTypeExpression: result returnType]).

	"Create the block closure program entity."
	owner := scope lookupProgramEntityForNewDefinitions.
	
	blockClosureEntity := MbndBlockClosureMethod new
		definitionPosition: result;
		analyzedNode: result;
		defineArguments.
	result blockClosureProgramEntity: blockClosureEntity.

	bodyScope := blockClosureEntity createSemanticAnalysisScopeWithParent: scope.
	
	"Add the argument to the scope."
	self withScope: bodyScope do: [
		"Analyze the body"
		result body: (self visitNode: result body).
		
		"Infer the return type."
		resultType := result body type.
		result returnType ifNil: [
			result returnType: (resultType inferValueTypeForNode: result body inScope: scope)
		].
	
		"Cast the implicit return value."
		resultType isReturnType ifFalse: [
			result body: (self addImplicitCastFor: result body to: result returnType)
		].
	].

	blockClosureEntity type: (self compilationTarget blockClosureTypeWithArguments: (blockClosureEntity arguments collect: #type) returnType: result returnType).
	result type: blockClosureEntity type.

	owner addChild: blockClosureEntity.
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
MbndAstSemanticAnalyzer >> visitCleanUpScopeNode: node [
	| result analyzedContent |
	result := node copy.
	
	analyzedContent := self visitNode: result expression.
	analyzedContent isLiteralValueNode ifTrue: [ ^ analyzedContent ].
	
	self flag: 'TODO: Implement the clean up scope analysis correctly.'.
	result
		expression: analyzedContent;
		type: analyzedContent type;
		cleanUpActions: (self visitNodesAndCollect: result cleanUpActions).
	
	^ result
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
MbndAstSemanticAnalyzer >> visitDoWhileLoopNode: node [
	| result |
	result := node copy.
	self withContinueAndBreakOwnerNode: node do: [ 
		result action: (result action ifNotNil: [:action | self analyzeNodeIfNeeded: action]).
	].
	result
		continueAction: (result continueAction ifNotNil: [:action | self analyzeNodeIfNeeded: action]);
		condition: (self addImplicitCastFor: (self analyzeNodeIfNeeded: result condition) to: self compilationTarget booleanType);
		type: self compilationTarget voidType.

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitEnumDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndEnumType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitEnumDefinitionNode: node [
	| result definitionScope valueType |
	result := node copy.
	result declaration: (self visitNode: result declaration ensurePartOfDefinitionFlagIsMarked).
	
	"Evaluate the value type"
	node valueType ifNotNil: [ :valueTypeNode |
		valueType := self evaluateTypeExpression: valueTypeNode.
	] ifNil: [
		valueType := compilationTarget int32Type.
	].

	result binding valueType: valueType.

	"Set the defined flag"
	result binding addFlag: #defined.
	
	"Create a new lexical scope for the definition body."	
	definitionScope := (result binding programEntityScope parent: scope) newLexicalScope.

	"Analyze the values."
	result values ifNotNil: [ :values |
		self analyzeEnumDefinition: result values: values
	].
	
	"Analyze the definition content."
	result body ifNotNil: [ 
		self withScope: definitionScope do: [

			"Analyze the definition body. This optional."		
			result body: (self evaluateCompileTimeExpression: result body)
		].
	].

	"Enqueue the result semantic analysis."
	result binding enqueueDelayedSemanticAnalysis.
	
	"Pass through the declaration result."
	result type: result declaration type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandScalarToMatrixCastNode: node [
	| scalarNode matrixType columnType zeroConstantNode resultNode |
	scalarNode := self analyzeNodeIfNeeded: node expression.
	matrixType := node targetType isMbndAstNode
			ifTrue: [self evaluateTypeExpression: node targetType]
			ifFalse: [node targetType].

	columnType := matrixType columnType.
	zeroConstantNode := matrixType elementType zeroConstantValue asLiteralValueNode position: node.
	resultNode := (self astBuilder 
		constructMatrix: matrixType withColumns:
		((0 to: matrixType columns - 1) collect: [ :columnIndex |
			(self astBuilder constructVector: columnType withElements: ((0 to: matrixType rows - 1) collect: [ :rowIndex |
				columnIndex = rowIndex
					ifTrue: [ scalarNode ]
					ifFalse: [ zeroConstantNode ]
			])) position: node
		])
	) position: node.
	
	^ self visitNode: resultNode
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandScalarToVectorCastNode: node [
	| scalarNode vectorType |
	scalarNode := self analyzeNodeIfNeeded: node expression.
	vectorType := node targetType isMbndAstNode
			ifTrue: [self evaluateTypeExpression: node targetType]
			ifFalse: [node targetType].

	^ (self astBuilder 
		constructVector: vectorType withElements:
		((1 to: vectorType elements) collect: [ :i | scalarNode ])
	) position: node
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
		self error: 'Cannot perform explicit cast from type {1} to type {2}.' format: { sourceType printString.  result targetType printString} at: node
	].
	
	result
		typeConversionRule: conversionRule;
		type: result targetType.
	^ conversionRule postProcessCastNode: result withAnalyzer: self.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitFieldDefinitionNode: node [
	| result owner fieldName field visibility |
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
			self error: 'field {1} requires an explicit type.' format: { result name asPrettySymbolName } at: result
		]
	] ifNotNil: [ 
		result initialValue: node initialValue.
		self halt
	].

	visibility := nil.
	(result hasFlag: #public) ifTrue: [
		visibility := #public.
	].
	(result hasFlag: #protected) ifTrue: [
		visibility := #protected.
	].
	(result hasFlag: #private) ifTrue: [
		visibility := #private.
	].
	visibility ifNil: [ visibility := #protected ].

	fieldName := node name.
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	fieldName isMbndAnonymousSymbol ifFalse: [ 
		(owner lookupLocalSymbol: fieldName) ifNotNil: [ :previousDefintion |
			self error: 'Cannot redefine field {1}.' format: { fieldName asPrettySymbolName } at: result
		].
	].

	field := MbndFieldVariable new
		name: fieldName;
		flags: result flags;
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
		arguments: (self analyzeNodesIfNeeded: result arguments).
		
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
MbndAstSemanticAnalyzer >> visitGetFieldReferenceNode: node [
	| result aggregateType |
	result := node copy
		aggregate: (self analyzeNodeIfNeeded: node aggregate);
		yourself.
	aggregateType := result aggregate type withoutReferences withoutDecorations.
	self assert: aggregateType isAggregateType.

	^ result
		type: result field type;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGetFieldValueNode: node [
	| result aggregateType |
	result := node copy
		aggregate: (self analyzeNodeIfNeeded: node aggregate);
		yourself.
	aggregateType := result aggregate type withoutReferences.
	self assert: aggregateType isAggregateType.

	^ result
		type: result field valueType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGlobalVariableDefinitionNode: node [
	| result valueType globalVariable owner |
	result := node copy.
	
	"Make sure the value type is evaluated."
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType).
	].

	"Analyze the initial value."
	result initialValue ifNotNil: [
		result initialValue: (self analyzeNodeIfNeeded: result initialValue)
	] ifNil: [
		result isAccessedByReference ifTrue: [ 
			self error: 'Global variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
	].
	
	"Infer the value type, if needed"
	result valueType ifNil: [
		result initialValue ifNil: [
			self error: 'Global variable {1} without an explicit type, or an initial value.' format: { result name asPrettySymbolName } at: node
		].
	
		result valueType: (result initialValue type inferValueTypeForNode: result initialValue inScope: scope).
	].

	"Cast implicitly the initial value."
	valueType := result valueType.
	result initialValue ifNotNil: [ :valueNode |
		result initialValue: (self addImplicitCastFor: valueNode to: valueType)
	].

	"Compute the variable reference type"
	self assert: valueType isNotNil.
	result isMutable ifTrue: [
		result type: valueType asMutableValueType
	] ifFalse: [
		result isAccessedByReference ifTrue: [
			result type: valueType const ref
		] ifFalse: [ 
			result type: valueType asImmutableValueType
		]
	].

	"Create a matching variable"
	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	globalVariable := owner findOrAddGlobalVariableNamed: result name valueType: result valueType type: result type at: result.

	result binding: globalVariable.
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
	| result resultCoercionType |
	result := node copy.
	result condition: (self analyzeNodeIfNeeded: result condition).

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
	
	result condition type isCompilerObjectType ifFalse: [ 
		result condition: (self addImplicitCastFor: result condition to: self compilationTarget booleanType)
	].

	result trueValue ifNil: [
		result trueValue: self astBuilder literalUndefined
	].

	result falseValue ifNil: [
		result falseValue: self astBuilder literalUndefined
	].

	result
		trueValue: (self ensureLiteralIsConcreted: (self analyzeNodeIfNeeded: result trueValue));
		falseValue: (self ensureLiteralIsConcreted: (self analyzeNodeIfNeeded: result falseValue)).

	resultCoercionType := self
		conditionalResultCoercionTypeFor: result trueValue type node: result trueValue
		with: result falseValue type node: result falseValue
		at: result.
	resultCoercionType isVoidType ifFalse: [
		result
			trueValue: (self addImplicitCastFor: result trueValue to: resultCoercionType);
			falseValue: (self addImplicitCastFor: result falseValue to: resultCoercionType).
	].
	result type: resultCoercionType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitImmediateBlockClosureActivationNode: node [
	| result blockClosureType expectedArgumentTypes |
	self flag: 'TODO: Assist the type inference machinery.'.

	"Analyze the block node."
	result := node copy
		blockNode: (self analyzeNodeIfNeeded: node blockNode);
		yourself.

	"Analyze and coerce the arguments."
	blockClosureType := result blockNode type.
	expectedArgumentTypes := blockClosureType argumentTypes.
	result arguments: (node arguments collectWithIndex: [:arg :index |
		self addImplicitCastFor: (self analyzeNodeIfNeeded: arg) to: (expectedArgumentTypes at: index)
	]).

	self assert: result blockNode isBlockClosureNode.
	result blockNode blockClosureProgramEntity makeBlockClosureWithImmediateActivation.
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
		
		self flag: 'TODO: Implement the clean up scope analysis correctly.'.
		
		result
			expression: analyzedContent;
			type: analyzedContent type;
			cleanUpActions: (self visitNodesAndCollect: result cleanUpActions).
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitLocalVariableDefinitionNode: node [
	| result valueType owner |
	result := node copy.
	
	"Make sure the value type is evaluated."
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType).
	].

	"Analyze the initial value."
	result initialValue ifNotNil: [
		result initialValue: (self analyzeNodeIfNeeded: result initialValue)
	] ifNil: [
		result isAccessedByReference ifTrue: [ 
			self error: 'Local variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
	].
	
	"Infer the value type, if needed"
	result valueType ifNil: [
		result initialValue ifNil: [
			self error: 'Variable {1} without an explicit type requires an initial value.' format: { node v asPrettySymbolName } at: node
		].
	
		result valueType: (result initialValue type inferValueTypeForNode: result initialValue inScope: scope).
		result isAccessedByReference ifFalse: [ 
			result valueType: result valueType withoutReferences
		].
	].

	"Cast implicitly the initial value."
	valueType := result valueType.
	result initialValue ifNotNil: [ :valueNode |
		result initialValue: (self addImplicitCastFor: valueNode to: valueType)
	].

	"Make sure there is always an initial value."
	result initialValue ifNil: [ 
		result initialValue: (result valueType defaultValueASTNodeAt: result)
	].

	"Compute the variable reference type"
	self assert: valueType isNotNil.
	result isMutable ifTrue: [
		result type: valueType asMutableValueType
	] ifFalse: [
		result isAccessedByReference ifTrue: [
			result type: valueType const ref
		] ifFalse: [ 
			result type: valueType asImmutableValueType
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
	
	owner := scope lookupProgramEntityForNewDefinitions.
	owner addChild: result binding.

	"Add the variable to the current scope."
	result name isMbndAnonymousSymbol ifFalse: [ 
		scope addSymbol: result name binding: result binding ifPresent: [ :previousDefinition |
			self error: 'Variable {1} overrides a previous definition in the same scope.' format: { result name asPrettySymbolName } at: result
		].
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
MbndAstSemanticAnalyzer >> visitMatrixConstructionNode: node [
	| result expectedColumnType |
	result := node copy
		matrixType: (self evaluateTypeExpression: node matrixType);
		columns: (self visitNodesAndCollect: node columns);
		yourself.
		
	result matrixType isPrimitiveMatrixType ifFalse: [ 
		self error: 'Matrix construction requires a matrix type instead of {1} for constructing the matrix.' format: { result vectorType asString } at: result
	].
	result type: result matrixType.
	
	result columns size = result matrixType columns ifFalse: [
		self error: 'Matrix construction requires {1} instead of the supplied {2} columns.'
			format: { result matrixType columns asString . result columns size asString } at: result
	].

	expectedColumnType := result matrixType columnType.
	result columns: (result columns collect: [:column | self addImplicitCastFor: column to: expectedColumnType]).
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMatrixGetColumnNode: node [
	| result matrixType resultType |
	result := node copy
		matrix: (self analyzeNodeIfNeeded: node matrix);
		element: (self ensureIntegerValue: (self analyzeNodeIfNeeded: node element) at: node);
		yourself.
	matrixType := result matrix type withoutReferences withoutTopDecorations.
	self assert: matrixType isPrimitiveMatrixType.
	
	result element isLiteralValueNode ifTrue: [ 
		result element value >= matrixType columns ifTrue: [
			self error: 'Accessing matrix column that is out of bounds.' at: result
		]
	].
	
	resultType := matrixType columnType.
	result matrix type isReferenceType ifTrue: [ 
		resultType := (resultType withDecoration: result matrix type decorations)
			refFor: result matrix type addressSpace
	].
	
	^ result
		type: resultType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMatrixGetRowNode: node [
	| result matrixType |
	result := node copy
		matrix: (self analyzeNodeIfNeeded: node matrix);
		element: (self ensureIntegerValue: (self analyzeNodeIfNeeded: node matrix) at: node);
		yourself.
	matrixType := result matrix type withoutReferences withoutTopDecorations.
	self assert: matrixType isPrimitiveMatrixType.
	
	result element isLiteralValueNode ifTrue: [ 
		result element value >= matrixType rows ifTrue: [
			self error: 'Accessing matrix row that is out of bounds.' at: result
		]
	].

	^ result
		matrix: (self addImplicitCastFor: result matrix to: matrixType);
		type: matrixType rowType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMatrixMultiplicationOperationNode: node [
	| result leftMatrixType rightMatrixType |
	result := node copy
		leftMatrix: (self analyzeNodeIfNeeded: node leftMatrix);
		rightMatrix: (self analyzeNodeIfNeeded: node rightMatrix);
		yourself.
	
	leftMatrixType := result leftMatrix type withoutReferences withoutTopDecorations.
	rightMatrixType := result rightMatrix type withoutReferences withoutTopDecorations.
	"The receiver must be always a matrix or a vector."
	self assert: leftMatrixType isPrimitiveMatrixOrVectorType.
	
	rightMatrixType isPrimitiveMatrixOrVectorType ifFalse: [
		rightMatrixType isPrimitiveScalarType ifTrue: [
			"Coerce the right scalar type."
			result rightMatrix: (self addImplicitCastFor: result rightMatrix to: rightMatrixType elementType).
			
			"If the right type is a scalar, we should expand it into a matrix"
			result rightMatrix: (self astBuilder expandScalar: result rightMatrix toMatrixType: (
				leftMatrixType elementType primitiveMatrixWithRows: leftMatrixType columns columns: leftMatrixType columns
			)).
			
			^ self visitNode: result
		] ifFalse: [
		
			self error: 'Cannot multiply a matrix with a value of type {1}.' format: { rightMatrixType asString } at: result
		]
	].

	"Make sure the element type matches."
	leftMatrixType elementType = rightMatrixType elementType ifFalse: [ 
		self error: 'Cannot multiply matrices (or vectors) with incompatible element types ({1} vs {2}).' format: { 
			leftMatrixType elementType asString . rightMatrixType elementType asString
		} at: result
	].

	"Make sure there are no references."
	result 
		leftMatrix: (self addImplicitCastFor: result leftMatrix to: leftMatrixType);
		rightMatrix: (self addImplicitCastFor: result rightMatrix to: rightMatrixType).

	leftMatrixType isPrimitiveVectorType ifTrue: [ 
		self assert: rightMatrixType isPrimitiveMatrixType.
		leftMatrixType 	elements = rightMatrixType rows ifFalse: [
			self error: 'Cannot multiply a vector with {1} elements with a matrix with {2} rows.'
				format: { leftMatrixType elements asString . rightMatrixType rows asString } at: result
		].
	
		^ result type: leftMatrixType;
			yourself
	].

	rightMatrixType isPrimitiveVectorType ifTrue: [ 
		self assert: leftMatrixType isPrimitiveMatrixType.
		leftMatrixType 	columns = rightMatrixType elements ifFalse: [
			self error: 'Cannot multiply a matrix with {1} columns with a vector with {2} elements.'
				format: { leftMatrixType columns asString . rightMatrixType elements asString } at: result
		].

		^ result type: rightMatrixType;
			yourself
	].

	self assert: leftMatrixType isPrimitiveMatrixType.
	self assert: rightMatrixType isPrimitiveMatrixType.
	leftMatrixType columns = rightMatrixType rows ifFalse: [ 
		self error: 'Cannot multiply a matrix with {1} columns with another matrix with {2} rows.'
			format: { leftMatrixType columns asString . rightMatrixType rows asString } at: result
	].

	^ result
		type: (leftMatrixType elementType primitiveMatrixWithRows: leftMatrixType rows columns: rightMatrixType columns);
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMessageChainNode: node [
	| receiverVariable receiverVariableReference messages unconvertedMessages analyzedReceiver convertedMetaMessages |
	node messages ifEmpty: [
		^ self visitNode: node receiver
	].

	node messages size = 1 ifTrue: [
		^ self visitNode: (node messages first asUnexpandedMessageSend
			receiver: node receiver;
			yourself)
	].

	unconvertedMessages := node messages.
	
	analyzedReceiver := self analyzeNonConcreteNodeIfNeeded: node receiver.
	
	convertedMetaMessages := OrderedCollection new.
	[analyzedReceiver isNonConcreteNode and: [unconvertedMessages isNotEmpty]] whileTrue: [ 
		| message analyzedMessage |
		message := unconvertedMessages first asUnexpandedMessageSend receiver: analyzedReceiver.
		unconvertedMessages := unconvertedMessages allButFirst.
		analyzedMessage := self visitNonConcreteNode: message.
		analyzedMessage isNonConcreteNode ifFalse: [ 
			convertedMetaMessages add: analyzedMessage.
		].
	].

	(convertedMetaMessages isEmpty and: [ unconvertedMessages isEmpty ]) ifTrue: [ 
		^ analyzedReceiver
	].

	self assert: (scope lookupSymbol: node) isNil.
	receiverVariable := MbndAstLocalVariableDefinitionNode new
		mutable;
		ref;
		position: node;
		name: node;
		initialValue: analyzedReceiver;
		yourself.
	receiverVariableReference := MbndAstIdentifierReferenceNode new
		position: node;
		symbol: node;
		yourself.
		
	messages := unconvertedMessages collect: [ :message |
		message asUnexpandedMessageSend
			receiver: receiverVariableReference; yourself
	].

	^ self visitNode: (MbndAstSequenceNode new
		position: node;
		elements: { receiverVariable } , convertedMetaMessages asArray, messages;
		yourself)
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
	| namespaceName owner namespace result |
	result := node copy.
	namespaceName := node name.
	namespaceName isMbndAnonymousSymbol ifTrue: [ 
		self error: 'Anonymous namespace are not supported, yet.' at: result
	].
	
	owner := result ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
	namespace := owner ensureSymbolIsNamespace: namespaceName at: result.
	self assert: namespace isNotNil.
	
	self withScope: (namespace programEntityScope parent: scope) newLexicalScope do: [ 
		self evaluateCompileTimeExpression: node body
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
	result := node copy
		pointer: (self analyzeNodeIfNeeded: node pointer);
		yourself.
	result pointer: (self ensurePointerValue: node pointer at: node).

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
		
	pointerType := result container type withoutTopDecorations.
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
		expression: (self analyzeNodeIfNeeded: node expression);
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
MbndAstSemanticAnalyzer >> visitSetFieldValueNode: node [
	| result aggregateType |
	result := node copy
		aggregate: (self analyzeNodeIfNeeded: node aggregate);
		newValue: (self analyzeNodeIfNeeded: node newValue);
		yourself.
	aggregateType := result aggregate type withoutReferences.
	aggregateType isConstantType ifTrue: [
		self error: 'Cannot modify value of field "{1}" in constant aggregate.' format: { node field name asPrettySymbolName } at: node
	].
	aggregateType := aggregateType withoutTopDecorations.
	self assert: aggregateType isAggregateType.
	
	result newValue: (self addImplicitCastFor: result newValue to: result field valueType).

	^ result
		type: result aggregate type;
		yourself
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
MbndAstSemanticAnalyzer >> visitSplicingTupleNode: nodeOrList [
	nodeOrList isMbndAstNode ifFalse: [ ^ self analyzeNodesIfNeeded: nodeOrList ].
	nodeOrList isTupleNode ifTrue: [ ^ self analyzeNodesIfNeeded: nodeOrList elements ].
	
	self halt
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
	| result definitionScope superType |
	result := node copy.
	result declaration: (self visitNode: result declaration ensurePartOfDefinitionFlagIsMarked).
	
	"Evaluate the supertype"
	node superTypeNode ifNotNil: [ :superTypeNode |
		superType := self evaluateTypeExpression: superTypeNode.
		result binding setSupertypeFromDefinition: superType
	].

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
MbndAstSemanticAnalyzer >> visitVectorConstructionNode: node [
	| result passedElementsCount requiredElementType |
	result := node copy
		vectorType: (self evaluateTypeExpression: node vectorType);
		elements: (self visitSplicingTupleNode: node elements);
		yourself.
		
	result vectorType isPrimitiveVectorType ifFalse: [ 
		self error: 'Vector construction requires a vector type instead of {1} for constructing the vector.' format: { result vectorType asString } at: result
	].
	result type: result vectorType.

	passedElementsCount := 0.
	requiredElementType := result vectorType elementType.
	result elements: (result elements collect: [ :element |
		| convertedElement |
		convertedElement := self ensureValue: element isVectorOrScalarOfType: requiredElementType.
		passedElementsCount := passedElementsCount + (convertedElement type isPrimitiveVectorType ifTrue: [ convertedElement type elements ] ifFalse: [ 1 ]).
		convertedElement
	]).

	passedElementsCount = result vectorType elements ifFalse: [
		self error: 'Vector construction does not have sufficient elements for constructing a vector of type {1}.' format: { result vectorType asString } at: result
	].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitVectorGetElementsNode: node [
	| result vectorType |
	result := node copy
		vector: (self analyzeNodeIfNeeded: node vector);
		yourself.
	vectorType := result vector type withoutReferences withoutTopDecorations.
	self assert: vectorType isPrimitiveVectorType.

	result type: (vectorType elementType primitiveVectorWithElements: node elements size).
	(node elements size = 1 and: [ node vector type isReferenceType ]) ifTrue: [
		
		^ result type: ((result type 
			withDecorations: node vector type baseType decorations)
				refFor: node vector type addressSpace)
	].

	^ result
		vector: (self addImplicitCastFor: result vector to: vectorType);
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitVectorSetElementsNode: node [
	| result vectorType |
	result := node copy
		vector: (self analyzeNodeIfNeeded: node vector);
		values: (self visitNodesAndCollect: node values);
		yourself.
	vectorType := result vector type withoutReferences withoutTopDecorations.
	self assert: vectorType isPrimitiveVectorType.
	(result vector type isReferenceType and: [ result vector type baseType isConstantType ]) ifTrue: [
		result vector: (self addImplicitCastFor: result vector to: vectorType)
	].
	
	^ result
		type: result vector type;
		yourself

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitWhileLoopNode: node [
	| result |
	result := node copy.
	result
		condition: (self addImplicitCastFor: (self analyzeNodeIfNeeded: result condition) to: self compilationTarget booleanType);
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
