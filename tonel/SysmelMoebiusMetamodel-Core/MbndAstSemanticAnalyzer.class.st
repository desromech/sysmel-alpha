"
I am an AST visitor that performs semantic analysis.
"
Class {
	#name : #MbndAstSemanticAnalyzer,
	#superclass : #MbndAstSemanticAnalyzerForExplicitMacroExpansion,
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
	sourceType ifNil: [
		(expectedTargetType canValueBeCreatedForNode: nodeRequiringCasting) ifTrue: [ 
			^ self analyzeNodeIfNeeded: (expectedTargetType createValueForNode: nodeRequiringCasting withAnalyzer: self)
		].
		^ self addImplicitCastFor: (self analyzeNodeIfNeeded: nodeRequiringCasting) to: expectedTargetType
	].

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
		^ self addImplicitCastFor: temporaryVariable to: expectedTargetType
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
	valueType := enumType baseType.
	evaluatedDictionary value keysAndValuesDo: [ :key :value |
		convertedDictionary at: key put:
			(valueType isPrimitiveType
				ifTrue: [ value copy type: enumType ]
				ifFalse: [ MbndValue value: value type: enumType ])
	].

	enumType values: convertedDictionary
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> analyzePatternMatchingPatternNode: node withValueOfType: patternValueType [
	| pattern |
	pattern := MbndAstPatternSemanticAnalyzer new
		semanticAnalyzer: self;
		patternValueType: patternValueType;
		visitNode: node.
	pattern isPatternMatchingPatternNode ifFalse: [ 
		self error: 'Expected an expression that represents a pattern.' at: node
	].
	^ pattern
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> createBindingPatternLocalVariable: bindingPattern [
	"Bindings without a name are always a nop in this context."
	| valueType |
	bindingPattern name isMbndAnonymousSymbol ifTrue: [^nil].
	
	"For now only support immutable bindings."
	valueType := bindingPattern type asImmutableValueType.
	
	"Create the variable"
	bindingPattern binding: (self createLocalVariableNamed: bindingPattern name withValueType: valueType
		type: valueType at: bindingPattern).
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> createLocalVariableNamed: localVariableName withValueType: valueType type: referenceType at: definitionNode [
	| localVariable owner |
	localVariable := MbndFunctionLocalVariable new
		definitionNode: definitionNode;
		name: localVariableName;
		valueType: valueType;
		type: referenceType;
		yourself.
		
	owner := scope lookupProgramEntityForNewDefinitions.

	"Add the variable to the current scope."
	localVariableName isMbndAnonymousSymbol ifFalse: [ 
		scope addSymbol: localVariableName binding: localVariable ifPresent: [ :previousDefinition |
			self error: 'Variable {1} overrides a previous definition in the same scope.' format: { localVariableName asPrettySymbolName } at: definitionNode
		].
	].

	owner addChild: localVariable.
	^ localVariable
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> ensureConcreteValue: node [
	node type isLiteralValueType ifTrue: [ self ensureLiteralIsConcreted: node ].
	^ self ensureReferencesAreEvaluated: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> ensureDirectMacrosAreExpanded: node [
	node isUnexpandedMessageSendNode ifTrue: [
		self halt
	].
	^ node
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

{ #category : #coercing }
MbndAstSemanticAnalyzer >> ensureReferencesAreEvaluated: node [
	^ self addImplicitCastFor: node to: node type withoutReferences
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
			self evaluateCompileTimeExpression: (self addImplicitCastFor: valueNode to: enumType baseType).
		].
		self assert: value type == enumType baseType.
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

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> markCompileTimeEvaluationImpossibility [
	scope lookupProgramEntityForNewDefinitions ifNotNil: [ :programEntity |
		programEntity markCompileTimeEvaluationImpossibility
	]
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
MbndAstSemanticAnalyzer >> visitArrayConstructionNode: node [
	| result elementType |
	result := node copy
		elementType: (self evaluateTypeExpression: node elementType);
		elements: (self visitSplicingTupleNode: node elements);
		yourself.
	elementType := result elementType.
	result elements: (result elements collect: [:el |
		self addImplicitCastFor: el to: elementType
	]).
	result type: (elementType array: result elements size).

	(result elements allSatisfy: #isLiteralValueNode) ifTrue: [ 
		| resultValue |
		resultValue := result type defaultValueAt: node.
		result elements doWithIndex: [ :element :index |
			self assert: element isLiteralValueNode.
			resultValue slots at: index put: element value
		].
		^ (resultValue asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
			position: node
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
MbndAstSemanticAnalyzer >> visitCasesOfCaseNode: node [
	| result matchingScope |
	matchingScope := scope newLexicalScope.

	self withScope: matchingScope do: [ 
		result := node copy
			pattern: (self analyzePatternMatchingPatternNode: node pattern withValueOfType: node patternValueType);
		yourself.
		result bindings: result pattern collectBindings.
		result action: (self ensureLiteralIsConcreted: (self analyzeNodeIfNeeded: result action))
	].

	result type: result action type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitCasesOfNode: node [
	| result patternValueType resultType dummyNode defaultCaseIndex |
	result := node copy
		matchedExpression: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node matchedExpression)).
	patternValueType := result matchedExpression type.
	result cases isMbndAstNode ifTrue: [ 
		result cases: (self ensureDirectMacrosAreExpanded: result cases).

		result cases isDictionaryNode ifFalse: [ 
			self error: 'A dictionary node with the list of the cases is expected for doing pattern matching.' at: node.
		].

		result cases: (result cases elements collect: [:el |
			el isAssociationNode ifFalse: [ self error: 'An association node is expected for specifying a <pattern> : <action> pair.' at: el].
			self visitNode: (MbndAstCasesOfCaseNode new
				position: el;
				patternValueType: patternValueType;
				pattern: el key;
				action: el value)
		]).
	] ifFalse: [
		self assert: result cases isCollection.
		result cases: (result cases collect: [:case |
			self visitNode: (case copy patternValueType patternValueType)
		] as: Array)
	].

	"Ignore all the patterns after the default case pattern."
	defaultCaseIndex := result cases findFirst: #hasDefaultPattern.
	defaultCaseIndex > 0 ifTrue: [ 
		result hasDefaultCase: true.
		defaultCaseIndex < result cases size ifTrue: [ 
			self warning: 'Default matching pattern is not last. All of the case patterns defined after this pattern are ignored.' at: result.
			result cases: (result cases first: defaultCaseIndex)
		].
	].
	

	resultType := nil.
	dummyNode := MbndAstNode dummy.
	result cases do: [ :case |
		resultType ifNil: [
			resultType := case type withoutReferences withoutTopDecorations .
		] ifNotNil: [ 
			resultType := self
				conditionalResultCoercionTypeFor: resultType node: dummyNode
					with: case type node: dummyNode at: result.
		].
	].

	resultType ifNil: [ resultType := self compilationTarget voidType ].
	resultType isVoidType ifFalse: [
		result cases do: [ :case |
			case action: (self addImplicitCastFor: case action to: resultType)
		]
	].
	
	^ result
		type: resultType;
		yourself
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
		condition: (self addImplicitCastFor: result condition to: self compilationTarget booleanType);
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

	result binding baseType: valueType.

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
	| result owner fieldName field visibility location intrinsic |
	result := node copy.

	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType)
	].

	result bits ifNotNil: [ 
		result bits isMbndAstNode ifTrue: [ 
			result bits: (self evaluateCompileTimeExpression: result bits) unwrapMbndValue.
			result bits isInteger ifFalse: [ 
				self error: 'Expected an integer value for the bit count of a field.' at: node bits
			].
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

	location := nil.
	result location ifNotNil: [:loc |
		location := (self evaluateCompileTimeExpression: loc) unwrapMbndValue.
		location isInteger ifFalse: [
			self error: 'Field location must be an integer.' at: loc.
		]
	].

	intrinsic := nil.
	result intrinsic ifNotNil: [:intr |
		intrinsic := (self evaluateCompileTimeExpression: intr) unwrapMbndValue.
		intrinsic isSymbol ifFalse: [
			self error: 'Field intrinsic must be an integer.' at: intr.
		]
	].

	field := MbndFieldVariable new
		name: fieldName;
		flags: result flags;
		valueType: (result valueType asFieldTypeFor: owner);
		type: result valueType ref;
		bits: result bits;
		location: location;
		intrinsic: intrinsic;
		yourself.
	owner addField: field.

	result
		binding: field;
		type: self compilationTarget voidType.
	^ result
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
	result specialSemantics ifNotNil: [ 
		result concreteMethod specialSemantics: node specialSemantics
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
MbndAstSemanticAnalyzer >> visitGCVariableDataArrayElementReferenceNode: node [
	| result arrayType elementType containerType |
	result := node copy
		container: (self analyzeNodeIfNeeded: node container);
		index: (self ensureIntegerValue: (self analyzeNodeIfNeeded: node index) at: node);
		yourself.
		
	containerType := result container type.
	containerType isReferenceType ifFalse: [
		self error: 'A gc class variable data array reference is required for getting a reference to one of its elements.' at: node
	].

	arrayType := containerType baseType.
	arrayType isGCClassVariableDataArrayType ifFalse: [
		self error: 'A gc class variable data array reference is required for getting a reference to one of its elements.' at: node
	].

	elementType := arrayType elementType.
	result type: elementType ref.
	^ result
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
MbndAstSemanticAnalyzer >> visitGetGCVariableDataArraySizeNode: node [
	| result arrayType elementType containerType container |
	result := node copy
		container: (self analyzeNodeIfNeeded: node container);
		yourself.
		
	containerType := result container type.
	result container isGetFieldReferenceNode ifFalse: [
		self error: 'A GC class variable data array size reference to a container is required.' at: node
	].

	container := result container aggregate.
	containerType := container type withoutReferences withoutTopDecorations.
	containerType isGCClassType ifFalse: [
		self error: 'A GC class must be the owner of the GC class variable data.' at: node
	].
	
	^ self visitNode: (MbndAstGetFieldValueNode new
		aggregate: container;
		field: containerType variableDataSizeField;
		yourself)
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGlobalVariableDefinitionNode: node [
	| result valueType globalVariable owner |
	result := node copy.
	
	"Make sure the value type is evaluated."
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType).
	] ifNil: [
		result initialValue ifNil: [
			self error: 'Global variable {1} without an explicit type, or an initial value.' format: { result name asPrettySymbolName } at: node
		].

		result initialValue: (self analyzeNodeIfNeeded: result initialValue).
		result valueType: (result initialValue type inferValueTypeForNode: result initialValue inScope: scope).
	].

	"If accessed by reference, make sure an initial value is provided."
	result initialValue ifNil: [
		result isAccessedByReference ifTrue: [ 
			self error: 'Global variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
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
MbndAstSemanticAnalyzer >> visitIOChannelReceiveAction: node [
	| result |
	result := node copy
		channel: (self ensureReferencesAreEvaluated: (self analyzeNodeIfNeeded: node channel)).
	result channel type isInputChannelType ifFalse: [ 
		self error: 'An input channel is expected for receiving message.' at: node
	].

	^ result
		type: result channel type messageType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitIOChannelSendAction: node [
	| result |
	result := node copy
		channel: (self ensureReferencesAreEvaluated: (self analyzeNodeIfNeeded: node channel));
		message: (self analyzeNodeIfNeeded: node message).
		
	result channel type isOutputChannelType ifFalse: [ 
		self error: 'An output channel is expected for receiving message.' at: node
	].
	result message: (self addImplicitCastFor: result message to: result channel type messageType).

	^ result
		type: result channel type;
		yourself
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
		self addImplicitCastFor: arg to: (expectedArgumentTypes at: index)
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
MbndAstSemanticAnalyzer >> visitLiteralArrayToArrayCastNode: node [
	| literalArrayExpression targetType arrayValues resultValue expectedElementType elementLiteralNode |
	literalArrayExpression := self analyzeNodeIfNeeded: node expression.
	self assert: literalArrayExpression isLiteralValueNode.
	arrayValues := literalArrayExpression value.
	self assert: arrayValues isArray.
	
	targetType := node targetType.
	self assert: targetType isArrayType.
	targetType elements > 0 ifTrue: [
		arrayValues size = targetType elements ifFalse: [ 
			self error: 'Literal array with {1} cannot be converted into an array with {2} elements.' format: { arrayValues size asString. targetType elements asString } at: node
		]
	].

	expectedElementType := targetType elementType.
	resultValue := targetType defaultValueAt: node.
	arrayValues doWithIndex: [:element :index |
		self flag: 'FIXME: Preserve the per-element nodes.'.
		elementLiteralNode := (element asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
			position: literalArrayExpression.
		elementLiteralNode := self addImplicitCastFor: elementLiteralNode to: expectedElementType.
		self assert: elementLiteralNode isLiteralValueNode.
		resultValue slots at: index put: elementLiteralNode value.
	].
	
	^ (resultValue asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
		position: node
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
	] ifNil: [
		result isAccessedByReference ifTrue: [ 
			self error: 'Local variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
	].
	
	"Infer the value type, if needed"
	result valueType ifNil: [
		result initialValue ifNil: [
			self error: 'Variable {1} without an explicit type requires an initial value.' format: { node name asPrettySymbolName } at: node
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

	"Create the matching local variable"
	result binding: (self createLocalVariableNamed: node name withValueType: valueType type: result type at: result).

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
MbndAstSemanticAnalyzer >> visitProgramEntityExtensionNode: node [
	| programEntity |
	programEntity := node programEntity.
	programEntity isMbndAstNode ifTrue: [ 
		programEntity := (self evaluateCompileTimeExpression: programEntity) unwrapMbndValue.
		programEntity isMbndProgramEntity ifFalse: [ 
			self error: 'Expected a program entity to extend.' at: node programEntity
		]
	].

	programEntity addFlag: #defined.
	self withScope: (programEntity programEntityScope parent: scope) newLexicalScope do: [ 
		self evaluateCompileTimeExpression: node body
	].

	^ self astBuilder literalVoid
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
		result expression: (self addImplicitCastFor: result expression to: (expectedReturnType asConcreteTypeForAnalysisOfFunction: scope returnTypeProgramEntity))
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSampleTextureWithExplicitDerivativesNode: node [
	| result derivativeType |
	result := self visitSampleTextureWithImplicitLodNode: node.
	derivativeType := result texture type derivativeType.
	result
		dtdx: (self addImplicitCastFor: result dtdx to: derivativeType);
		dtdy: (self addImplicitCastFor: result dtdy to: derivativeType).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSampleTextureWithExplicitLodNode: node [
	| result |
	result := self visitSampleTextureWithImplicitLodNode: node.
	result lod: (self addImplicitCastFor: result lod to: self compilationTarget float32Type).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSampleTextureWithImplicitLodNode: node [
	| result |
	result := node copy
		sampler: (self ensureReferencesAreEvaluated: (self analyzeNodeIfNeeded: node sampler));
		texture: (self ensureReferencesAreEvaluated: (self analyzeNodeIfNeeded: node texture));
		texcoord: (self analyzeNodeIfNeeded: node texcoord);
		yourself.
	result sampler type isSamplerType ifFalse: [
		self error: 'A sampler is expected for sampling a texture.' at: result sampler.
	].

	result texture type isTextureType ifFalse: [
		self error: 'A texture to be sampled is expected instead of a value of type {1}.' format: { result texture type asString } at: result texture.
	].

	result texture type sampled ifFalse: [
		self error: 'A sampled texture must be used for sampling instead of a texture of type {1}.' format: { result texture type asString } at: result texture.
	].

	result
		texcoord: (self addImplicitCastFor: result texcoord to: result texture type samplingCoordinateType);
		type: self compilationTarget float32x4Type.
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
		(result elements size = 1 and: [result pragmas isEmpty]) ifTrue: [ ^ result elements first ].
		
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
MbndAstSemanticAnalyzer >> visitTupleToArrayCastNode: node [
	| tupleNodes tupleElements targetType expectedElementType |
	tupleNodes := self visitSplicingTupleNode: node expression.

	tupleElements := tupleNodes size.
	targetType := node targetType.
	self assert: targetType isArrayType.
	targetType elements > 0 ifTrue: [
		tupleElements = targetType elements ifFalse: [ 
			self error: 'Array with {1} elements cannot be constructed with a tuple with {2} elements.' format: { targetType elements asString . tupleElements asString } at: node
		]
	].

	expectedElementType := targetType elementType.
	^ self visitNode: ((self astBuilder constructArrayOf: expectedElementType withElements: tupleNodes)
		position: node)
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
	result body ifNotNil: [ 
		self withScope: definitionScope do: [ 
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
MbndAstSemanticAnalyzer >> visitUnionDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndUnionType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnionDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndUnionType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitUnwrapEnumValueCastNode: node [
	| result enumType |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		targetType: (node targetType ifNotNil: [:tt | self evaluateTypeExpression: tt]);
		yourself.
	result targetType ifNil: [
		enumType := node expression type withoutReferences withoutTopDecorations.
		enumType isEnumType ifFalse: [
			self error: 'An expression with an enum type is expected for extracting a value.' at: node
		].
		result
			expression: (self addImplicitCastFor: result expression to: enumType);
			targetType: enumType baseType.
	].

	^ result
		type: result targetType;
		yourself
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
		condition: (self addImplicitCastFor: result condition to: self compilationTarget booleanType);
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
