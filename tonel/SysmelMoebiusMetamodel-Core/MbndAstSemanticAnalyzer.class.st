"
I am an AST visitor that performs semantic analysis.
"
Class {
	#name : #MbndAstSemanticAnalyzer,
	#superclass : #MbndAstSemanticAnalyzerForExplicitMacroExpansion,
	#instVars : [
		'currentCleanUpScope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-SemanticAnalysis'
}

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addImplicitCVariadicCastFor: nodeRequiringCasting [
	| sourceType cvariadicType analyzedNodeRequiringCasting |
	analyzedNodeRequiringCasting := self analyzeNodeIfNeeded: nodeRequiringCasting.
	sourceType := analyzedNodeRequiringCasting type.
	cvariadicType := sourceType asCVariadicTypeRequiredAt: nodeRequiringCasting.
	^ self addImplicitCastFor: analyzedNodeRequiringCasting to: cvariadicType
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addImplicitCastFor: nodeRequiringCasting to: expectedTargetType [
	| sourceType |
	sourceType := nodeRequiringCasting type.
	sourceType ifNil: [
		(expectedTargetType canValueBeCreatedForNode: nodeRequiringCasting) ifTrue: [ 
			^ self analyzeNodeIfNeeded: (expectedTargetType createValueForNode: nodeRequiringCasting withAnalyzer: self)
		].
		nodeRequiringCasting isBlockClosureNode ifTrue: [ 
			^ self addImplicitCastFor: (self analyzeNodeIfNeeded: (nodeRequiringCasting assistTypeInferenceWithExpectedType: expectedTargetType with: self)) to: expectedTargetType
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
MbndAstSemanticAnalyzer >> addImplicitCastForOrMoveable: nodeRequiringCasting to: expectedTargetType [
	| sourceType |
	sourceType := nodeRequiringCasting type.
	sourceType ifNil: [ 
		(expectedTargetType canValueBeCreatedForNode: nodeRequiringCasting) ifTrue: [ 
			^ self analyzeNodeIfNeeded: (expectedTargetType createValueForNode: nodeRequiringCasting withAnalyzer: self)
		].
		^ self addImplicitCastForOrMoveable: (self analyzeNodeIfNeeded: nodeRequiringCasting) to: expectedTargetType
	].
	
	(sourceType isTemporaryReferenceType and: [ sourceType baseType = expectedTargetType ]) ifTrue: [ 
		^ nodeRequiringCasting
	].

	^ self addImplicitCastFor: nodeRequiringCasting to: expectedTargetType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> addNodeWithImplicitFinalization: node [
	currentCleanUpScope ifNil: [
		self error: 'AST node {1} is invalid at this context because it requires implicit finalization support.' format: {node class name} at: node.
	].
	
	currentCleanUpScope addNodeWithImplicitFinalization: node
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> addReceiverImplicitCastFor: nodeRequiringCasting to: expectedTargetType [
	| sourceType |
	sourceType := nodeRequiringCasting type. 
	self assert: sourceType isNotNil.
	
	"This is the only special case where it is allowed to implicitly spill value types into non-const references."
	(expectedTargetType isReferenceType and: [ expectedTargetType isConstantType not]) ifTrue: [
		(sourceType isReferenceType not and: [ sourceType isTemporaryReferenceType not ]) ifTrue: [
			sourceType isTypePassedByReference ifTrue: [
				^ self visitNode: (MbndAstCopyIntoTemporaryVariableNode new
					position: nodeRequiringCasting;
					value: nodeRequiringCasting;
					yourself)
			] ifFalse: [
				"Spill the receiver in a temporary."
				self flag: 'TODO: convert this into a proper conversion rule/node.'.
				^ self visitNode: ((self astBuilder defineLocalVariable: #_ withValueType: nil withInitialValue: nodeRequiringCasting)
					position: nodeRequiringCasting;
					mutable)
			].
		].
	].
	^ self addImplicitCastFor: nodeRequiringCasting to: expectedTargetType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeBlockNode: blockNode calledWithArgumentNodes: argumentNodes expectedReturnType: expectedReturnType [
	"I take care of analyzing a block, and of also provide automatic block closure signature inference when possible."

	| result |
	blockNode isBlockClosureNode ifFalse: [ ^ self analyzeNodeIfNeeded: blockNode ].

	result := blockNode.
	 
	argumentNodes ifNotNil: [
		result := result copy
			arguments: (result arguments collectWithIndex: [:argDefinition :index |
				argDefinition valueType
					ifNotNil: [ argDefinition ]
					ifNil: [
						| argumentNode |
						argumentNode := argumentNodes at: index.
						argDefinition copy
						valueType: (argumentNode type inferValueTypeForNode: argumentNode inScope: scope)
					].
			])
	].

	(expectedReturnType isNotNil and: [result returnType isNil]) ifTrue: [
		result := result copy returnType: expectedReturnType.
	].

	^ self analyzeNodeIfNeeded: result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeBlockNode: blockNode calledWithArgumentTypes: argumentTypes expectedReturnType: expectedReturnType [
	"I take care of analyzing a block, and of also provide automatic block closure signature inference when possible."

	| result |
	blockNode isBlockClosureNode ifFalse: [ ^ self analyzeNodeIfNeeded: blockNode ].

	result := blockNode.
	argumentTypes ifNotNil: [
		result arguments size = argumentTypes size ifFalse: [ 
			^ self error: 'Block closure receives {1} arguments instead of the specified {2} arguments.' format: { argumentTypes size asString . result arguments size asString } at: blockNode
		].
	
		result := result copy
			arguments: (result arguments collectWithIndex: [:argDefinition :index |
				argDefinition valueType
					ifNotNil: [ argDefinition ]
					ifNil: [ argDefinition copy valueType: (argumentTypes at: index) ].
		])
	].

	(expectedReturnType isNotNil and: [result returnType isNil]) ifTrue: [
		result := result copy returnType: expectedReturnType.
	].

	^ self analyzeNodeIfNeeded: result
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeExpandedMessageSend: messageSendNode arguments: argumentNodes [
	| methodOrMethodGroupLooked methodOrMethodGroup receiverType |
	(messageSendNode receiver isNil or: [messageSendNode selector isLiteralSymbolValueNode not]) ifTrue: [ ^ self analyzeNodesIfNeeded: argumentNodes ].
	
	methodOrMethodGroupLooked := false.
	methodOrMethodGroup := nil.
	receiverType := messageSendNode receiver type.
	^ argumentNodes collectWithIndex: [ :each :index |
		each type ifNil: [
			each isBlockClosureNode ifTrue: [
				| withAssistedTypeInference |
				methodOrMethodGroupLooked ifFalse: [
					methodOrMethodGroup := receiverType lookupOverloadedFinalSelector: messageSendNode selector value.
					methodOrMethodGroupLooked := true.
				].
			
				withAssistedTypeInference := methodOrMethodGroup ifNil: [
					receiverType assistBlockClosureNodeTypeInference: each asArgument: index with: self
				] ifNotNil: [ 
					methodOrMethodGroup assistBlockClosureNodeTypeInference: each asArgument: index with: self
				].
				self visitNode: withAssistedTypeInference
			] ifFalse: [ 
				self visitNode: each
			]
		] ifNotNil: [
			each
		]
	]
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> analyzePattern: pattern matchingWithValueOfType: patternValueType [
	^ MbndAstPatternSemanticAnalyzer new
		semanticAnalyzer: self;
		patternValueType: patternValueType;
		visitNode: pattern
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> analyzePatternMatchingPatternNode: node withValueOfType: patternValueType [
	^ self analyzePattern: (self parsePatternMatchingPatternNode: node) matchingWithValueOfType: patternValueType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> analyzeVariableDefinition: definition initialValue: initialValueNode [
	| valueType initialValueType |
	valueType := definition valueType.
	self assert: valueType isNotNil.
	initialValueNode ifNotNil: [
		initialValueType := initialValueNode type.
		(initialValueType isTemporaryReferenceType and: [initialValueType baseType == valueType]) ifTrue: [
			(valueType isNonMoveable and: [valueType isNonCopyable]) ifTrue: [
				self error: 'Cannot initialize variable with non-moveable and non-copyable value type "{1}".' format: {valueType asString} at: definition
			].
		
			valueType hasTrivialInitializationMovingFrom ifFalse: [ 
				definition
					initialValueKind: #move;
					initialValue: initialValueNode.
				^ self
			].
		].

		valueType isNonCopyable ifTrue: [
			self error: 'Cannot initialize variable with non-copyable value type "{1}".' format: {valueType asString} at: definition
		].
	
		valueType hasTrivialInitializationCopyingFrom ifTrue: [ 
			definition
				initialValueKind: #copy;
				initialValue: (self addImplicitCastFor: initialValueNode to: valueType)
		] ifFalse: [
			definition
				initialValueKind: #copy;
				initialValue: (self addImplicitCastFor: initialValueNode to: valueType asCopyConstructorParameter)
		]	
	] ifNil: [ 
		"Make sure there is always an initial value."
		definition
			initialValueKind: #default;
			initialValue: (definition valueType defaultValueASTNodeAt: definition)
	]
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

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> attemptImplicitCast: baseNode intoType: targetType [
	| sourceNode conversionRule |
	sourceNode := self analyzeNodeIfNeeded: baseNode.
	sourceNode type = targetType ifTrue: [ ^ sourceNode ].
	
	conversionRule := sourceNode type node: sourceNode convertedImplicitlyInto: targetType.
	conversionRule ifNil: [ ^ nil ].
	
	^ self addImplicitCastFor: baseNode to: targetType.
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> collectEvaluatingSplices: nodeList with: aBlock [
	| result |
	(nodeList anySatisfy: [ :each | each isSpliceNode ]) ifFalse: [ ^ nodeList collect: aBlock ].
	result := OrderedCollection new.
	nodeList do: [ :each |
		each isSpliceNode ifTrue: [
			(self evaluateSpliceNode: each) do: [ :splicedNode |
				result add: (aBlock value: splicedNode)
			]
		] ifFalse: [ 
			result add: (aBlock value: each)
		]
	].
	^ result asArray
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> computeArithmethicCoercionTypeNodeFor: leftNode with: rightNode fallbackTo: fallbackType at: position [
	<compileTime>
	<returnType: #_ASTNodeType>
	
	| leftAnalyzedNode rightAnalyzedNode coercionType |
	leftAnalyzedNode := self analyzeNodeIfNeeded: leftNode.
	rightAnalyzedNode := self analyzeNodeIfNeeded: rightNode.
	coercionType := self compilationTarget computeArithmeticCoercionTypeFor: leftAnalyzedNode type with: rightAnalyzedNode type leftNode: leftAnalyzedNode rightNode: rightAnalyzedNode inScope: scope.
	coercionType ifNil: [ coercionType := fallbackType ].
	
	^ coercionType asLiteralValueNode
		position: position
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

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> createFuncletWithNode: node [
	^ MbndConcreteFunclet new
		module: scope module;
		contentNode: node;
		definitionScope: scope;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> createLocalVariableNamed: localVariableName withValueType: valueType type: referenceType at: definitionNode [
	^ self createLocalVariableNamed: localVariableName withValueType: valueType type: referenceType variableClass: MbndFunctionLocalVariable flags: #() at: definitionNode
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> createLocalVariableNamed: localVariableName withValueType: valueType type: referenceType variableClass: variableClass flags: flags at: definitionNode [
	| localVariable owner |
	localVariable := variableClass new
		flags: flags;
		definitionNode: definitionNode;
		definitionScope: scope;
		name: localVariableName;
		valueType: valueType;
		type: referenceType;
		yourself.
		
	owner := scope lookupProgramEntityForNewDefinitions.

	"Add the variable to the current scope."
	localVariableName isMbndAnonymousSymbol ifFalse: [
		self checkForRestrictedSymbol: localVariableName at: definitionNode.
		scope addSymbol: localVariableName binding: localVariable ifPresent: [ :previousDefinition |
			self error: 'Variable {1} overrides a previous definition in the same scope.' format: { localVariableName asPrettySymbolName } at: definitionNode
		].
	].

	owner addPrivateChild: localVariable.
	localVariable enqueueDelayedSemanticAnalysis.
	^ localVariable
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> ensureConcreteValue: node [
	node type isLiteralValueType ifTrue: [ ^ self ensureLiteralIsConcreted: node ].
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
MbndAstSemanticAnalyzer >> ensureIntegerIndexValue: node at: position [
	| result resultType |
	result := self ensureIntegerValue: node at: position.
	resultType := result type.
	self assert: resultType isPrimitiveIntegerType.
	
	resultType instanceSize < self compilationTarget pointerSize ifTrue: [
		^ self visitNode: (MbndAstIndexTypeExpansionCastNode new
			position: position;
			expression: result;
			targetType: (resultType isSigned
				ifTrue: [ self compilationTarget intPointerType ]
				ifFalse: [ self compilationTarget uintPointerType ]);
			yourself)
	].

	^ result
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
		^ self ensureIntegerIndexValue: (MbndAstReferenceLoadNode new
			reference: node;
			position: position;
			yourself)
			at: position
	].

	self halt	
]

{ #category : #'implicit casting' }
MbndAstSemanticAnalyzer >> ensureLiteralIsConcreted: node [
	| concreteType |
	concreteType := node type standardConcreteTypeForLiteralValueNode: node inScope: scope.
	concreteType == node type ifTrue: [ ^ node ].
	^ self addImplicitCastFor: node to: concreteType
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
			self error: 'Expected a scalar or vector whose elements are of type {1} instead of a value of type {2}.' format: { requiredElementType asString . cleanValueType asString } at: valueNode.
		].
		^ self addImplicitCastFor: valueNode to: cleanValueType
	] ifFalse: [
		^ self addImplicitCastFor: valueNode to: requiredElementType
	]
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> ensureValueIsSpilledInReference: node [
	(node type isReferenceType or: [ node type isTemporaryReferenceType ]) ifTrue: [ ^ node ].
	^ self visitNode: (MbndAstCopyIntoTemporaryVariableNode new
		value: node;
		yourself)
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
	
	self withScope: (scope newLexicalScopeAt: dictionaryNode) do: [ 
		dictionaryNode elements do: [ :valueDefinition |
			| association |
			association := self evaluateEnum: enumType valueDefinition: valueDefinition lastValue: lastValue.
			scope addSymbol: association key binding: association value ifPresent: [ 
				self error: 'Enum {1} symbol {2} is duplicated.' format: { enumType asString . association key asPrettySymbolName } at: valueDefinition
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

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> evaluateSpliceNode: node [
	| evaluatedNodeList |
	evaluatedNodeList := (self evaluateCompileTimeExpression: node expression) unwrapMbndValue.
	evaluatedNodeList isMbndAstNode ifTrue: [ 
		evaluatedNodeList isSequenceNode ifTrue: [ 
			evaluatedNodeList := evaluatedNodeList elements
		].
	].

	evaluatedNodeList isCollection ifFalse: [ 
		self error: 'Expected an iterable sequence for the result of a splice node expression.' at: node
	].
	(evaluatedNodeList allSatisfy: [ :each | each isMbndAstNode ]) ifFalse: [ 
		self error: 'All of the members in a splice node operation must be a node.' at: node
	].

	^ evaluatedNodeList
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
MbndAstSemanticAnalyzer >> expandAggregate: aggregateType constructionWithFields: fields values: values at: position [
	| resultValue receiverVariable receiverVariableReference fieldAssignments |
	resultValue := self astBuilder temporaryVariableOfType: aggregateType.
	receiverVariable := MbndAstLocalVariableDefinitionNode new
		tempRef;
		position: position;
		name: position;
		initialValue: resultValue;
		yourself.
	receiverVariableReference := MbndAstIdentifierReferenceNode new
		position: position;
		symbol: position;
		yourself.
		
	fieldAssignments := values collectWithIndex: [ :fieldValue :fieldIndex |
		| fieldReference |
		fieldReference := MbndAstGetFieldReferenceNode new
			position: position;
			aggregate: receiverVariableReference;
			field: (fields at: fieldIndex)
			yourself.
			
			self astBuilder unexpandedSend: ((astBuilder literalSymbol: #'assignValue:') position: values) 
				to: fieldReference withArguments: { fieldValue }
	].

	^ self visitNode: (MbndAstSequenceNode new
		position: position;
		elements: { receiverVariable } , fieldAssignments , { receiverVariableReference };
		yourself)

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> forNode: node deferAnalysisWith: aBlock [
	^ MbndAstNodeWithDeferredAnalysis new
		position: node;
		node: node;
		analyzer: self copy;
		analysisBlock: aBlock;
		yourself
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

{ #category : #testing }
MbndAstSemanticAnalyzer >> isEmptyTupleNode: node [
	node isMbndAstNode ifFalse: [
		^ node isEmpty
	].

	node isTupleNode ifTrue: [
		^ node elements isEmpty
	].

	^ false.
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> markCompileTimeEvaluationImpossibility [
	scope lookupProgramEntityForNewDefinitions ifNotNil: [ :programEntity |
		programEntity markCompileTimeEvaluationImpossibility
	]
]

{ #category : #'as yet unclassified' }
MbndAstSemanticAnalyzer >> parsePatternMatchingPatternNode: node [
	| pattern |
	pattern := MbndAstPatternParsingAnalyzer new
		semanticAnalyzer: self;
		parseNode: node.
	pattern isPatternMatchingPatternNode ifFalse: [ 
		self error: 'Expected an expression that represents a pattern.' at: node
	].
	^ pattern
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAggregateConstructionWithNamedElementsNode: node [
	| aggregateType |
	aggregateType := self evaluateTypeExpression: node aggregate.
	self assert: aggregateType isAggregateTypeWithFields.
	
	"TODO: Analyze the actual elements."
	self halt.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAggregateConstructionWithOrderedElementsNode: node [
	| aggregateType elements fields |
	aggregateType := self evaluateTypeExpression: node aggregate.
	self assert: aggregateType isAggregateTypeWithFields.

	elements := self visitSplicingTupleNode: node elements.
	fields := aggregateType allNamedFields.
	elements size > fields size ifTrue: [
		self error: 'Aggregate construction of type {1} has is provided more fields than the ones supported by the aggregate. ' format: { aggregateType asString } at: node
	].

	^ self expandAggregate: aggregateType constructionWithFields: (fields first: elements size) values: elements at: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitArgumentDefinitionNode: node [
	| result |
	result := node copy.
	
	result name isMbndAstNode ifTrue: [
		result name: (self visitNodeForIdentifierMacroExpansion: result name).
		result name isIdentifierReferenceNode ifFalse: [
			self error: 'Macro did not expand into an identifier reference node.' at: node name.
		].
		result name: result name symbol
	].
	
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: node valueType)
	].

	result initialValue ifNil: [
		result valueType ifNil: [
			| defaultArgumentType |
			defaultArgumentType := scope defaultArgumentType.
			defaultArgumentType ifNil: [ 
				self error: 'function argument {1} requires an explicit type.' format: { result name asPrettySymbolName } at: result
			].
		
			result valueType: defaultArgumentType
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
	
	result type hasTrivialFinalization ifFalse: [ 
		self addNodeWithImplicitFinalization: result
	].

	result type: result type tempRef.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitArrayElementReferenceNode: node [
	| result containerType arrayType elementType |
	result := node copy
		container: (self ensureValueIsSpilledInReference: (self analyzeNodeIfNeeded: node container));
		index: (self ensureIntegerIndexValue: (self analyzeNodeIfNeeded: node index) at: node);
		yourself.
		
	containerType := result container type.
	self assert:(containerType isReferenceType or: [ containerType isTemporaryReferenceType ]).

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
MbndAstSemanticAnalyzer >> visitArraySliceElementReferenceNode: node [
	| result containerType arrayType elementType |
	result := node copy
		container: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node container));
		index: (self ensureIntegerIndexValue: (self analyzeNodeIfNeeded: node index) at: node);
		yourself.
	
	containerType := result container type.
	arrayType := containerType withoutDecorations.
	arrayType isArraySliceType ifFalse: [
		self error: 'An array slice is required for getting a refence to one of its elements.' at: node
	].
	
	elementType := arrayType elementType.
	result type: (elementType withDecorations: containerType decorations) ref.
	 
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAssignmentNode: node [
	| result expectedValueType |
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

	"Return the reference after the assignment."
	result type: result reference type.
		
	expectedValueType := result reference type baseType withoutTopDecorations.
	^ expectedValueType analyzeReferenceAssignmentNode: result with: self

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitAssociationNode: node [
	| result associationType |
	result := node copy
		key: (node key ifNotNil: [:n | self analyzeNodeIfNeeded: n]);
		value: (node value ifNotNil: [:n | self analyzeNodeIfNeeded: n]);
		yourself.
	associationType := result key type --> result value type.
	result type: associationType.
	^ result type correctAssociationTypeForNode: result withAnalyzer: self.
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitBlockClosureActivationAttemptNode: node [
	| blockNode blockNodeType |
	blockNode := node blockNode.
	(blockNode isExceptionScopeNode or: [blockNode isSequenceNode]) ifTrue: [ ^ self analyzeNodeIfNeeded: blockNode ].

	blockNode := self analyzeNodeIfNeeded: blockNode.
	blockNodeType := blockNode type withoutReferences withoutTopDecorations.
	blockNodeType isBlockClosureType ifTrue: [
		blockNodeType argumentTypes size > node arguments size ifTrue: [
			self error: 'Cannot activate block closure that requires {1} with the {2} arguments provided.'
				format: {blockNodeType argumentTypes size asString . node arguments size asString}
				at: node
		].
	
		^ self visitNode: (
		(self astBuilder
			unexpandedSend: ((self astBuilder literalSymbol: #applyWithArguments:) position: node; yourself)
			to: blockNode
			withArguments: {(self astBuilder tuple: (node arguments first: blockNodeType argumentTypes size))
				position: node;
				yourself})
					position: node
		)
	].

	(blockNodeType isGarbageCollectedType and: [
	blockNodeType == self compilationTarget dynamicObjectType and: [
		scope currentLanguageHasImplicitDynamicObjectBlockEvaluation
	]]) ifTrue: [
		| selector |
		selector := #(value cull: cull:cull: cull:cull:cull: cull:cull:cull:cull:) at: node arguments size + 1.
		
		^ self visitNode: (
		(self astBuilder unexpandedSend: ((self astBuilder literalSymbol: selector) position: node; yourself) to: blockNode withArguments: node arguments)
			position: node
		)
	].
	
	^ blockNode
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitBlockClosureNode: node [
	| result bodyScope blockClosureEntity owner functionType needsGC preprocessedBody |
	result := node copy.
	result
		arguments: (self visitNodesAndCollect: result arguments);
		returnType: (result returnType ifNotNil: [self evaluateTypeExpression: result returnType]).
	result returnType ifNil: [
		| defaultReturnType |
		defaultReturnType := scope defaultReturnType.
		defaultReturnType ifNil: [ self error: 'Block closure requires an explicit return type.' at: result
		].
		result returnType: defaultReturnType
	].

	"Create the block closure program entity."
	owner := scope lookupProgramEntityForNewDefinitions.
	
	blockClosureEntity := MbndBlockClosureMethod new
		parent: owner;
		definitionPosition: result;
		definitionScope: scope;
		analyzedNode: result;
		setNonLocalReturnTarget: node isBlockWithNonLocalReturn not;
		closureKind: node closureKind;
		defineArguments.
	result blockClosureProgramEntity: blockClosureEntity.
	
	blockClosureEntity boundType: (self compilationTarget functionTypeWithArguments: (blockClosureEntity arguments collect: #type as: Array) returnType: result returnType).

	bodyScope := blockClosureEntity createSemanticAnalysisScopeWithParent: scope.
	preprocessedBody := result body.
	(preprocessedBody isLexicalScopeNode and: [ preprocessedBody expression isReturnStatementNode ]) ifFalse: [
		preprocessedBody := (MbndAstReturnStatementNode new
			position: preprocessedBody;
			implicitReturn: true;
			expression: preprocessedBody) lexicallyScoped
	].
	
	"Add the argument to the scope."
	self withScope: bodyScope do: [
		"Analyze the body"
		result body: (self visitNode: preprocessedBody).
	].

	blockClosureEntity returnType ifNil: [ 
		self error: 'Block closure requires an explicit return type because it was not possible to infer it.' at: node
	].

	functionType := blockClosureEntity boundType.
	blockClosureEntity closureKind ifNil: [
		blockClosureEntity closureKind: (blockClosureEntity needsGarbageCollection
			ifTrue: [ #gc ]
			ifFalse: [ #native ])
	].
	result closureKind: blockClosureEntity closureKind.
	blockClosureEntity type: (blockClosureEntity closureKind = #gc
		ifTrue: [ functionType asGCBlockClosureType ]
		ifFalse: [ functionType asNativeBlockClosureType]).
	result type: blockClosureEntity type.

	owner addLambdaChild: blockClosureEntity.
	^ result

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitBreakStatementNode: node [
	breakOwner ifNil: [
		self error: 'Break cannot be used in this location.' at: node
	].

	^ node copy
		type: self compilationTarget returnType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitCasesOfCaseNode: node [
	| result matchingScope |
	matchingScope := scope newLexicalScopeAt: node.

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
		matchedExpression: (self ensureLiteralIsConcreted: (self analyzeNodeIfNeeded: node matchedExpression)).
	patternValueType := result matchedExpression type withoutReferences withoutTopDecorations.
	(patternValueType isPrimitiveType or: [ patternValueType isEnumType and: [patternValueType valueType isPrimitiveType] ]) ifTrue: [ 
		result matchedExpression: (self ensureReferencesAreEvaluated: result matchedExpression).
		patternValueType := result matchedExpression type.
	] ifFalse: [
		patternValueType := result matchedExpression type.
	].

	result cases isMbndAstNode ifTrue: [ 
		result cases: (self ensureDirectMacrosAreExpanded: result cases).

		result cases isDictionaryNode ifFalse: [ 
			self error: 'A dictionary node with the list of the cases is expected for doing pattern matching.' at: node.
		].

		result cases: (self collectEvaluatingSplices: result cases elements with: [:el |
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
		resultType isTypePassedByReference ifTrue: [ 
			result cases do: [ :case |
				case action: (self addImplicitCastForOrMoveable: case action to: resultType)
			].
		
			resultType := resultType tempRef.
			resultType baseType hasTrivialFinalization ifFalse: [
				self addNodeWithImplicitFinalization: result
			].
		] ifFalse: [ 
			result cases do: [ :case |
				case action: (self addImplicitCastFor: case action to: resultType)
			]
		].
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
MbndAstSemanticAnalyzer >> visitContinueStatementNode: node [
	continueOwner ifNil: [
		self error: 'Continue cannot be used in this location.' at: node
	].

	^ node copy
		type: self compilationTarget returnType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitCopyIntoTemporaryVariableNode: node [
	| result valueType |
	result := node copy
		value: (self analyzeNodeIfNeeded: node value);
		yourself.
	valueType := result value type withoutReferences withoutTopDecorations.
	valueType hasTrivialFinalization ifFalse: [ 
		self addNodeWithImplicitFinalization: result
	].

	result type: valueType tempRef.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitDestructuringAssignmentNode: node [
	| result |
	result := node copy
		value: (self ensureLiteralIsConcreted: (self analyzeNodeIfNeeded: node value));
		pattern: (self parsePatternMatchingPatternNode: node pattern);
		yourself.

	result pattern: (self analyzePattern: result pattern matchingWithValueOfType: result value type).
	result pattern isNeverPattern ifTrue: [
		self error: 'Destructuring assignment pattern is never matched.' at: result
	].
	
	result
		bindings: result pattern collectBindings;
		type: result value type.		
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitDiscardFragmentStatementNode: node [
	^ node copy
		type: self compilationTarget returnType;
		yourself
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
	result declaration: (self analyzeNodeIfNeeded: result declaration ensurePartOfDefinitionFlagIsMarked).
	
	"Evaluate the value type"
	node valueType ifNotNil: [ :valueTypeNode |
		valueType := self evaluateTypeExpression: valueTypeNode.
	] ifNil: [
		valueType := compilationTarget int32Type.
	].

	result binding baseType: valueType.

	"Set the defined flag"
	result binding markAsDefined.
	
	"Create a new lexical scope for the definition body."	
	definitionScope := (result binding programEntityScope parent: scope) newLexicalScopeAt: result.

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
MbndAstSemanticAnalyzer >> visitExceptionCatchExpressionNode: node [
	| result exceptionReferenceType caughtExceptionReferenceNode hasAddedImmediateActivationNode cleanExceptionTypeExpression |
	result := node copy.
	result exceptionTypeExpression: (self analyzeNodeIfNeeded: node exceptionTypeExpression).
	cleanExceptionTypeExpression := result exceptionTypeExpression type withoutReferences withoutTopDecorations.
	(cleanExceptionTypeExpression isMetaType or: [ cleanExceptionTypeExpression isGarbageCollectedType ]) ifFalse: [ 
		self error: 'An exception type expression is expected in the catch clause instead of an expression with type "{1}".' format: { result exceptionTypeExpression type asString } at: result.
	].

	result exceptionTypeExpression isLiteralValueNode ifTrue: [
		result exceptionTypeExpression value isMbndType ifFalse: [ 
			self error: 'Exception catch literal "{1}" is not a type.' format: { result exceptionTypeExpression value asString } at: result.
		].
	
		result
			exceptionType: result exceptionTypeExpression value;
			exceptionTypeIsLiteral: true.
	] ifFalse: [
		"Allow the exception type to be an object for implementing BlockClosure >> #on:do:"
		result
			exceptionType: (cleanExceptionTypeExpression instanceTypeForExceptionCatch);
			exceptionTypeIsLiteral: false.
	].

	exceptionReferenceType := result exceptionType isGarbageCollectedType
		ifTrue: [ result exceptionType ]
		ifFalse: [ result exceptionType ref ].
	caughtExceptionReferenceNode := MbndAstCaughtExceptionReferenceNode new
		position: node;
		catchExpressionNode: result;
		type: exceptionReferenceType;
		yourself.
	result caughtExceptionReferenceNode: caughtExceptionReferenceNode.

	"Assist the block closure type inference machinery."
	hasAddedImmediateActivationNode := false.
	result catchAction isBlockClosureNode ifTrue: [
		result catchAction: result catchAction copy.

		result catchAction arguments size > 1 ifTrue: [ 
			self error: 'Exception catch action can only receive at most one argument.' at: result
		].
	
		result catchAction: (MbndAstImmediateBlockClosureActivationNode new
			position: node;
			blockNode: result catchAction;
			arguments: (result catchAction arguments
				ifEmpty: [ #() ]
				ifNotEmpty: [ { caughtExceptionReferenceNode } ]);
				yourself).
			hasAddedImmediateActivationNode := true.
	].

	result catchAction: (self analyzeNodeIfNeeded: result catchAction).
	
	result catchAction isLexicalScopeNode ifFalse: [ 
		result catchAction type isBlockClosureType ifTrue: [
			hasAddedImmediateActivationNode ifFalse: [
				result catchAction: (self analyzeNodeIfNeeded: (MbndAstFunctionCallNode new
					position: node;
					function: result catchAction;
					arguments: (result catchAction type argumentTypes
						ifEmpty: [ #() ]
						ifNotEmpty: [ { caughtExceptionReferenceNode } ] )))
			].
		].
	].

	result type: self compilationTarget voidType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExceptionScopeNode: node [
	| result analyzedContent |
	result := node copy.
	
	self withExceptionScope: result do: [
		analyzedContent := self analyzeNodeIfNeeded: result expression.
		(analyzedContent isLiteralValueNode and: [result explicitCleanUpActions isEmpty]) ifTrue: [ ^ analyzedContent ].

		analyzedContent := (self ensureLiteralIsConcreted: analyzedContent).
		result
			expression: analyzedContent;
			catchExpressions: (self analyzeNodesIfNeeded: result catchExpressions);
			type: analyzedContent type.
		result catchExpressions ifNotEmpty: [
			| coercionType previousNode |
			coercionType := analyzedContent type.
			previousNode := analyzedContent type.
			result catchExpressions do: [ :each |
				coercionType := self
					conditionalResultCoercionTypeFor: coercionType node: previousNode
					with: each catchAction type node: each catchAction
					at: result.
				previousNode := each
			].
		
			self assert: coercionType isNotNil.
			coercionType hasTrivialCopyAssignment ifFalse: [
				coercionType := self compilationTarget voidType
			].
		
			coercionType isVoidType ifFalse: [
				result catchExpressions do: [ :each |
					each catchAction: (self addImplicitCastFor: each catchAction to: coercionType)
				].
			
				result
					expression: (self addImplicitCastFor: result expression to: coercionType)
			].
		
			result
				type: coercionType.
		].
	].
	result
		explicitCleanUpActions: (self visitNodesAndCollect: result explicitCleanUpActions).
	
	currentCleanUpScope ifNotNil: [
		result type hasTrivialFinalization ifFalse: [
			self addNodeWithImplicitFinalization: result
		].
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandedDynamicMessageSendNode: node [
	| dynobjectType |
	dynobjectType := self compilationTarget dynamicObjectType.
	^ node copy
		receiver: (self addImplicitCastFor: (self analyzeNodeIfNeeded: node receiver) to: dynobjectType);
		selector: (self addImplicitCastFor: (self analyzeNodeIfNeeded: node selector) to: dynobjectType);
		arguments: (node arguments collect: [:arg |
			self addImplicitCastFor: arg to: dynobjectType
		]);
		type: dynobjectType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitExpandedMessageSendNode: node [
	| result receiverType method |
	result := node copy
		receiver: (node receiver ifNotNil: [:receiver | self analyzeNodeIfNeeded: node receiver]);
		selector: (self analyzeNodeIfNeeded: node selector).
		
	result
		arguments: (self analyzeExpandedMessageSend: result arguments: node arguments).
		
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
	| result owner fieldName field visibility location intrinsic valueType referenceType minimalAlignment |
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
			scope defaultVariableType ifNil: [ 
				self error: 'field {1} requires an explicit type.' format: { result name asPrettySymbolName } at: result
			] ifNotNil: [ :defaultType |
				result valueType: defaultType
			].
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
	owner module ~~ scope module ifTrue: [ 
		self error: 'It is forbbiden to extend "{1}" which is defined in another module with additional fields.' format: { owner asString } at: { node }
	].
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

	valueType := result valueType asFieldTypeFor: owner.
	referenceType := valueType ref.
	(result hasFlag: #workgroupShared) ifTrue: [ 
		referenceType := valueType refFor: #workgroup.
	].
	(result hasFlag: #crossWorkgroupShared) ifTrue: [ 
		referenceType := valueType refFor: #crossWorkgroup
	].
	
	minimalAlignment := node minimalAlignment ifNotNil: [ :ma | (self evaluateCompileTimeExpression: ma) value ].
	field := MbndFieldVariable new
		definitionScope: scope;
		definitionNode: node;
		name: fieldName;
		flags: result flags;
		valueType: valueType;
		minimalAlignment: minimalAlignment;
		type: referenceType;
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
	scope isInFunctionScope ifTrue: [ 
		^ self analyzeNodeIfNeeded: node asBlockClosureNode
	].

	result := node copy.
	result prototype: (self analyzeNodeIfNeeded: result prototype).
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
	| result specialSemantics |
	scope isInFunctionScope ifTrue: [ 
		self error: 'Function prototypes are not valid inside other functions or methods.' at: node.
	].

	result := node copy.
	result arguments: (self visitNodesAndCollect: result arguments).
	result returnType ifNil: [
		result returnType: (scope defaultReturnType ifNil: [
			self error: 'Function requires an explicit return type.' at: node
		]).
	] ifNotNil: [ 
		result returnType: (self evaluateTypeExpression: result returnType)
	].
		
	specialSemantics := node specialSemantics.
	result functionType: (self compilationTarget
		functionTypeWithArguments: (result arguments collect: [:arg | arg valueType withSpecialSemantics: specialSemantics])
		returnType: result returnType
		cvariadic: node isCVariadic).
	result type: result functionType ref.
	
	result ownerProgramEntity ifNil: [
		result ownerProgramEntity: scope lookupProgramEntityForNewDefinitions
	].
	
	result ownerProgramEntity ifNotNil: [ :newOwner |
		newOwner findOrAddOverloadedFunctionPrototype: result defineInModule: scope module
	].

	result concreteMethod specialSemantics: node specialSemantics.
	
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
		index: (self ensureIntegerIndexValue: (self analyzeNodeIfNeeded: node index) at: node);
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
	aggregateType isGarbageCollectedType ifTrue: [
		result aggregate: (self ensureReferencesAreEvaluated: result aggregate)
	].

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
	aggregateType isGarbageCollectedType ifTrue: [
		result aggregate: (self ensureReferencesAreEvaluated: result aggregate)
	].

	^ result
		type: result field valueType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGetGCVariableDataArraySizeNode: node [
	| result containerType container |
	result := node copy
		container: (self analyzeNodeIfNeeded: node container);
		yourself.
		
	containerType := result container type.
	result container isGetFieldReferenceNode ifFalse: [
		self error: 'A GC class variable data array size reference to a container is required.' at: node
	].

	container := result container aggregate.
	containerType := container type withoutReferences withoutTopDecorations.
	containerType isGarbageCollectedType ifFalse: [
		self error: 'A GC class must be the owner of the GC class variable data.' at: node
	].
	
	^ self visitNode: (MbndAstGetFieldValueNode new
		aggregate: container;
		field: containerType variableDataSizeField;
		yourself)
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitGlobalVariableDefinitionNode: node [
	| result valueType globalVariable owner initialValueFunclet |
	result := node copy.
	
	(result valueType isNil and: [ result initialValue isNil ]) ifTrue: [ 
		result valueType: scope defaultVariableType
	].

	"Make sure the value type is evaluated."
	result valueType ifNotNil: [ 
		result valueType: (self evaluateTypeExpression: result valueType).
	] ifNil: [
		result initialValue ifNil: [
			self error: 'Global variable {1} without an explicit type, or an initial value.' format: { result name asPrettySymbolName } at: node
		].

		initialValueFunclet := self createFuncletWithNode: result initialValue lexicallyScoped.
		initialValueFunclet 
			parent: (node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions]);
			setArguments: #() returnType: nil.
		result isAccessedByReference ifTrue: [ 
			initialValueFunclet addFlag: #ref.
		].
		result isForwardingValue ifTrue: [ 
			initialValueFunclet addFlag: #tempRef.
		].
			
		result valueType: initialValueFunclet inferResultValueType.
		(result isAccessedByReference or: [ result isForwardingValue ]) ifFalse: [ 
			result valueType: result valueType withoutReferences
		].
	].

	"If accessed by reference, make sure an initial value is provided."
	result initialValue ifNil: [
		(result isAccessedByReference or: [ result isForwardingValue ]) ifTrue: [ 
			self error: 'Global variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
	].
	
	"Compute the variable reference type"
	valueType := result valueType.
	self assert: valueType isNotNil.
	result isForwardingValue ifTrue: [
		result type: valueType asForwardingReferenceType
	] ifFalse: [ 
		result isMutable ifTrue: [
			result type: valueType asMutableValueType
		] ifFalse: [
			result isAccessedByReference ifTrue: [
				result type: valueType asImmutableReferenceType
			] ifFalse: [ 
				result type: valueType asImmutableValueType
			]
		].
	].

	result minimalAlignment ifNotNil: [ :ma |
		result minimalAlignment: (self evaluateCompileTimeExpression: ma) unwrapMbndValue.
		result minimalAlignment isInteger ifFalse: [
			self error: 'The minimal alignment specified for a variable {1} must be an integer.'
				format: { result name asPrettySymbolName } at: node minimalAlignment
		]
	].
	
	result constructionPriority ifNotNil: [ :cp |
		result constructionPriority: (self evaluateCompileTimeExpression: cp) unwrapMbndValue.
		result constructionPriority isInteger ifFalse: [
			self error: 'The construction priority specified for a variable {1} must be an integer.'
				format: { result name asPrettySymbolName } at: node minimalAlignment
		]
	].
	"Create a matching variable"
	(node isLocalVariableDefinitionNode or: [node isStatic]) ifTrue: [
		globalVariable := self createLocalVariableNamed: result name withValueType: valueType type: result type variableClass: MbndGlobalVariable flags: (node flags copyWith: #static) at: node
	] ifFalse: [ 
		owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].
		globalVariable := owner findOrAddGlobalVariableNamed: result name valueType: result valueType type: result type at: result.
	].

	result minimalAlignment ifNotNil: [ :ma |
		globalVariable minimalAlignment: ma
	].

	result constructionPriority ifNotNil: [ :cp |
		globalVariable constructionPriority: cp
	].

	"Turn the initial value into a funclet."
	initialValueFunclet ifNil: [ 
		result initialValue ifNotNil: [ :valueNode |
			globalVariable initialValueFunclet: (self createFuncletWithNode: valueNode )
		].
	] ifNotNil: [ 
		globalVariable initialValueFunclet: initialValueFunclet
	].

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
				ifNotNil: [ :child | self analyzeNodeIfNeeded: child ]
				ifNil: [ self astBuilder literalUndefined ]
		].
	
		result condition type isLiteralBooleanFalseType ifTrue: [
			^ result falseValue
				ifNotNil: [ :child | self analyzeNodeIfNeeded: child ]
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
	resultCoercionType isVoidType ifTrue: [
		(result falseValue isLiteralValueNode and: [ result falseValue type isUndefinedType ]) ifTrue: [ 			result falseValue: nil.
		].
	] ifFalse: [

		resultCoercionType isTypePassedByReference ifTrue: [
			result
				trueValue: (self addImplicitCastForOrMoveable: result trueValue to: resultCoercionType);
				falseValue: (self addImplicitCastForOrMoveable: result falseValue to: resultCoercionType).

			resultCoercionType := resultCoercionType tempRef.
			resultCoercionType baseType hasTrivialFinalization ifFalse: [
				self addNodeWithImplicitFinalization: result
			].
		] ifFalse: [ 
			result
				trueValue: (self addImplicitCastFor: result trueValue to: resultCoercionType);
				falseValue: (self addImplicitCastFor: result falseValue to: resultCoercionType).
		]
	].


	result type: resultCoercionType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitImmediateBlockClosureActivationNode: node [
	| result blockClosureType expectedArgumentTypes |

	"Initial analysis of the arguments"
	result := node copy
		arguments: (node arguments collect: [:arg | self analyzeNodeIfNeeded: arg]);
		yourself.
		
	"Infer the argument block argument node"
	result blockNode: (self analyzeBlockNode: node blockNode
		calledWithArgumentNodes: result arguments
		expectedReturnType: nil).

	"Analyze and coerce the arguments."
	blockClosureType := result blockNode type.
	expectedArgumentTypes := blockClosureType argumentTypes.
	result arguments: (result arguments collectWithIndex: [:arg :index |
		self addImplicitCastFor: arg to: (expectedArgumentTypes at: index)
	]).

	self assert: result blockNode isBlockClosureNode.
	result blockNode blockClosureProgramEntity makeBlockClosureWithImmediateActivation.
	result type: result blockNode returnType.
	result blockNode blockClosureProgramEntity hasExplicitReturnStatement ifTrue: [
		result type: self compilationTarget returnType
	].
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
MbndAstSemanticAnalyzer >> visitInlineAssembly: node [
	| result |
	result := node copy.
	result assembly: (self evaluateCompileTimeExpression: node assembly) unwrapMbndValue.
	result assembly isString ifFalse: [
		self error: 'Inline assembly source code must be evaluated into a string in compile time.' at: node assembly.
	].

	result architecture: (self evaluateCompileTimeExpression: node architecture) unwrapMbndValue.
	result architecture isSymbol ifFalse: [ 
		self error: 'Inline assembly architecture name must be evaluated into a symbol in compile time.' at: node architecture.
	].

	result dialect: (self evaluateCompileTimeExpression: node dialect) unwrapMbndValue.
	result dialect isSymbol ifFalse: [ 
		self error: 'Inline assembly dialect name must be evaluated into a symbol in compile time.' at: node architecture.
	].

	result inputList: ((self visitSplicingTupleNode: result inputList) collect: [ :inputConstraint |
		self analyzeInlineAssemblyInputConstraint: inputConstraint for: result
	]).

	result outputList: ((self visitSplicingTupleNode: result outputList) collect: [ :outputConstraint |
		self analyzeInlineAssemblyOutputConstraint: outputConstraint for: result
	]).

	result clobberList: ((self visitSplicingTupleNode: result clobberList) collect: [ :clobberConstraint |
		self analyzeInlineAssemblyClobberConstraint: clobberConstraint for: result
	]).
	
	scope isInFunctionScope ifFalse: [
		(result inputList isNotEmpty or: [ result outputList isNotEmpty or: [ result clobberList isNotEmpty ] ]) ifTrue: [
			self error: 'Module level inline assembly (i.e. not inside a function) cannot have I/O constraints, or elements in the cloberred list.' at: result
		].
	
		result markAsModuleLevel.
		scope lookupProgramEntityForNewDefinitions module
			addModuleLevelInlineAssembly: result
	].

	result type: self compilationTarget voidType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitInterfaceDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndInterfaceType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitInterfaceDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndInterfaceType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitLexicalScopeNode: node [
	| result |
	result := node copy.
	result lexicalScope: (scope newLexicalScopeAt: result).
	^ self withScope: result lexicalScope do: [
		self visitExceptionScopeNode: result
	].

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

	"If this is not in a function scope, then this is actually a static global variable."
	scope isInFunctionScope ifFalse: [
		 ^ self visitGlobalVariableDefinitionNode: node
	].
	
	"Make sure the value type is evaluated."
	result valueType ifNotNil: [
		result valueType: (self evaluateTypeExpression: node valueType).
	].

	"Analyze the initial value."
	result initialValue ifNotNil: [
		result initialValue: (self analyzeNodeIfNeeded: result initialValue)
	] ifNil: [
		(result isAccessedByReference or: [result isForwardingValue]) ifTrue: [ 
			self error: 'Local variable "{1}" definition with ref access requires an initial value.' format: { result name asPrettySymbolName } at: result
		]
	].
	
	"Infer the value type, if needed"
	result valueType ifNil: [
		result initialValue ifNil: [
			scope defaultVariableType ifNil: [ 
				self error: 'Variable {1} without an explicit type requires an initial value.' format: { node name asPrettySymbolName } at: node
			] ifNotNil: [ :defaultType |
				result valueType: defaultType
			]
		] ifNotNil: [ 
			result valueType: (result initialValue type inferValueTypeForNode: result initialValue inScope: scope).
			(result isAccessedByReference or: [ result isForwardingValue ]) ifFalse: [ 
				result valueType: result valueType withoutReferences withoutTopDecorations
			].
		].
	].

	"Compute the variable reference type"
	valueType := result valueType.
	self assert: valueType isNotNil.
	
	result isForwardingValue ifTrue: [
		result type: valueType tempRef.
	] ifFalse: [ 
		result isMutable ifTrue: [
			result type: valueType asMutableValueType
		] ifFalse: [
			result isAccessedByReference ifTrue: [
				result type: valueType asImmutableReferenceType
			] ifFalse: [ 
				result type: valueType asImmutableValueType
			]
		].
	].

	"Analyze the initial value, and its kind of initialization."
	self analyzeVariableDefinition: result initialValue: result initialValue.

	"Create the matching local variable"
	result binding: (self createLocalVariableNamed: node name withValueType: valueType type: result type at: result).

	valueType hasTrivialFinalization ifFalse: [
		currentCleanUpScope ifNil: [
			self error: 'Cannot instantiate a local variable with finalization in a context that does not admit finalizations.' at: result.
		].
	
		currentCleanUpScope addNodeWithImplicitFinalization: result
	].

	result valueType isMemoryReturnedType ifTrue: [
		result initialValue ifNotNil: [ :iv | iv markStorageCreationNodeForCopyEllision: result]
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMacroMessageDefinitionNode: node [
	| result |
	result := node copy.
	result prototype: (self analyzeNodeIfNeeded: result prototype).
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
		newOwner findOrAddMacroSelectorPrototype: result defineInModule: scope module
	].
	
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMatchingMatchedValueNode: node [
	^ node
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
	(result columns allSatisfy: [ :each | each isLiteralValueNode ]) ifTrue: [
		^ (MbndMatrixTypeInstanceValue new
			type: result type;
			slots: (result columns collect: [:each | each evaluateMbndValue unwrapMbndValue copy ]);
			yourself) asLiteralValueNode
				position: result;
				yourself
	].
	
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
		element: (self ensureIntegerValue: (self analyzeNodeIfNeeded: node element) at: node);
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
		leftMatrix: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node leftMatrix));
		rightMatrix: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node rightMatrix));
		yourself.
	
	leftMatrixType := result leftMatrix type.
	rightMatrixType := result rightMatrix type.
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
	
		^ result type: (leftMatrixType elementType primitiveVectorWithElements: rightMatrixType columns);
			yourself
	].

	rightMatrixType isPrimitiveVectorType ifTrue: [ 
		self assert: leftMatrixType isPrimitiveMatrixType.
		leftMatrixType 	columns = rightMatrixType elements ifFalse: [
			self error: 'Cannot multiply a matrix with {1} columns with a vector with {2} elements.'
				format: { leftMatrixType columns asString . rightMatrixType elements asString } at: result
		].

		^ result type: (rightMatrixType elementType primitiveVectorWithElements: leftMatrixType rows);
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
MbndAstSemanticAnalyzer >> visitMatrixTransposeNode: node [
	| result  matrixType |
	result := node copy
		matrix: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node matrix));
		yourself.

	matrixType := result matrix type.
	self assert: matrixType isPrimitiveMatrixType.
	result type: matrixType transpose.

	result matrix isLiteralValueNode ifTrue: [
		^ result matrix evaluateMbndValue transpose asLiteralValueNode
			position: result;
			yourself
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitMessageDefinitionNode: node [
	| result |
	scope isInFunctionScope ifTrue: [ 
		^ self analyzeNodeIfNeeded: node asBlockClosureNode
	].

	result := node copy.
	result prototype: (self analyzeNodeIfNeeded: result prototype).
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
	scope isInFunctionScope ifTrue: [ 
		self error: 'Method prototypes are not valid inside other functions or methods.' at: node.
	].

	result := node copy.
	result arguments: (self visitNodesAndCollect: result arguments).
	result returnType ifNil: [
		result returnType: (scope defaultReturnType ifNil: [
			self error: 'Message requires an explicit return type.' at: node
		]).
	] ifNotNil: [ 
		result returnType: (self evaluateTypeExpression: result returnType)
	].
		
	result functionType: (self compilationTarget
		functionTypeWithArguments: (result arguments collect: [:each | each valueType])
		returnType: result returnType).
	result type: result functionType ref.
	
	result ownerProgramEntity ifNil: [
		result ownerProgramEntity: scope lookupProgramEntityForNewDefinitions
	].

	result ownerProgramEntity ifNotNil: [ :newOwner |
		newOwner findOrAddOverloadedSelectorPrototype: result defineInModule: scope module
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
	
	self withScope: ((namespace programEntityScope parent: scope) newLexicalScopeAt: node) do: [ 
		self evaluateCompileTimeExpression: node body
	].

	^ self astBuilder literalVoid
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitNodeWithDeferredAnalysis: node [
	self assert: node type isNotNil.
	^ node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingAnyPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingBindingPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingIntervalPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingLiteralValuePatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingNeverPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingPatternNode: node [
	^ node copy
		type: self compilationTarget patternMatchingPatternType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingSameValuePatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingSetPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingTuplePatternNode: node [
	^ self visitPatternMatchingPatternNode: node
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPatternMatchingVariantTypeSelectionPatternNode: node [
	^ self visitPatternMatchingPatternNode: node
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
		index: (self ensureIntegerIndexValue: node index at: node);
		yourself.
		
	pointerType := result container type withoutTopDecorations.
	self assert: pointerType isPointerType.
	
	elementReferenceType := pointerType asReferenceType.
	result type: elementReferenceType.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPointerToArraySliceNode: node [
	| result |
	result := node copy
		pointer: (self ensureConcreteValue: (self analyzeNodeIfNeeded: node pointer));
		firstIndex: (self ensureIntegerIndexValue: (self analyzeNodeIfNeeded: node firstIndex) at: node);
		lastIndex: (self ensureIntegerIndexValue: (self analyzeNodeIfNeeded: node lastIndex) at: node);
		yourself.
	
	self assert: result pointer type isPointerType.
	result type: (result pointer type baseType arraySlice).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPragmaNode: pragmaNode [
	| selector result |
	result := pragmaNode copy
		selector: (pragmaNode selector);
		arguments: (self analyzeNodesIfNeeded: pragmaNode arguments);
		yourself.
	selector := pragmaNode selector.
	(result arguments allSatisfy: [ :arg | arg isLiteralValueNode ]) ifTrue: [ 
		scope lookupProgramEntityForNewDefinitions ifNotNil: [ :programEntity |
			programEntity analyzePragmaInDefinitionBodyWithSelector: selector arguments: (result arguments collect: [:each | each evaluateMbndValue])
		].
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitPredicatedTypeConceptDefinitionNode: node [
	| result predicate owner concept |
	node name isMbndAnonymousSymbol ifTrue: [
		self error: 'Anonymous type concepts are not allowed.' at: node
	].

	owner := node ownerProgramEntity ifNil: [scope lookupProgramEntityForNewDefinitions].

	node name isMbndAnonymousSymbol ifFalse: [ 
		(owner lookupLocalSymbol: node name) ifNotNil: [ :previousDefintion |
			self error: 'Cannot redefine symbol {1} as a type of another kind.' format: { node name asPrettySymbolName } at: node
		].
	].

	result := node copy
		predicate: (self analyzeBlockNode: node predicate
			calledWithArgumentTypes: {self compilationTarget compilerObjectType}
			expectedReturnType: self compilationTarget compilerObjectType);
		yourself.
	predicate := self evaluateCompileTimeExpression: result predicate.

	concept := self compilationTarget createNamedType: result name ofKind: MbndPredicatedTypeConcept inModule: scope module.
	concept predicate: predicate.
	concept addFlags: node flags.
	owner addChild: concept.
	owner setLocalSymbol: concept name value: concept.
	result binding: concept.

	concept enqueueDelayedSemanticAnalysis. "Not required"
	result type: concept type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitProgramEntityExtensionNode: node [
	| programEntity definitionScope |
	programEntity := node programEntity.
	programEntity isMbndAstNode ifTrue: [ 
		programEntity := (self evaluateCompileTimeExpression: programEntity) unwrapMbndValue.
		programEntity isMbndProgramEntity ifFalse: [ 
			self error: 'Expected a program entity to extend.' at: node programEntity
		]
	].

	programEntity isTemplate ifTrue: [
		programEntity addExtension: node body inScope: scope.
		^ self astBuilder literalVoid
	].

	(programEntity isMbndType and: [programEntity isVariantUnionType]) ifTrue: [
		programEntity components do: [ :each |
			definitionScope := (each programEntityScope parent: scope) newLexicalScopeAt: node.
			each addPendingDefinitionFragment: (MbndPendingDefinitionBody new
				module: module;
				node: node body;
				scope: definitionScope;
				yourself).

		].
		^ self astBuilder literalVoid
	].

	programEntity markAsDefined.
	definitionScope := (programEntity programEntityScope parent: scope) newLexicalScopeAt: node.
	programEntity addPendingDefinitionFragment: (MbndPendingDefinitionBody new
			module: module;
			node: node body;
			scope: definitionScope;
			yourself).

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
	result := node copy
		reference: (self analyzeNodeIfNeeded: node reference);
		yourself.
	basePointerType := result reference type withoutTopDecorations.
	(basePointerType isReferenceType or: [basePointerType isTemporaryReferenceType]) ifFalse: [
		self error: 'Expected a reference value.' at: node pointer.
	].

	^ result
		type: result reference type asPointerType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitReferenceLoadNode: node [
	| result referenceType |
	result := node copy.
	result reference: (self analyzeNodeIfNeeded: node reference);
		yourself.
		
	"Make sure the reference can be assigned."
	referenceType := result reference type.
	(referenceType isReferenceType or: [ referenceType isTemporaryReferenceType ]) ifFalse: [ 
		self error: 'Cannot assign a value to something that is not a reference.' at: result
	].

	"Return the reference after the assignment."
	result type: referenceType baseType withoutTopDecorations.	
		
	"We cannot load non-copyable types."
	referenceType isReferenceType ifTrue: [ 
		result type isNonCopyable ifTrue: [
			self error: 'It is not possible to load a reference into non-copyable value of type {1}.' format: { result type asString } at: result
		]
	].

	referenceType isTemporaryReferenceType ifFalse: [
		(result type isNonCopyable and: [ result type isNonMoveable ]) ifTrue: [ 
			self error: 'It is not possible to move or load a reference into non-moveable and non-copyable value of type {1}.' format: { result type asString } at: result
		].
	].
	
	"We may need to create a new temporary copy in some cases."
	result type isTypePassedByReference ifTrue: [
		referenceType isReferenceType ifTrue: [
			result createsImplicitTemporary: true.
			self addNodeWithImplicitFinalization: result
		].
	].	
	
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
	| result expectedReturnType returnTypeProgramEntity localReturnTypeProgramEntity |
	result := node copy
		expression: (self analyzeNodeIfNeeded: node expression);
		type: self compilationTarget returnType.

	result expression type isReturnType ifTrue: [
		result expectedReturnType: result expression type.
		^ result
	].
	
	localReturnTypeProgramEntity := scope returnTypeProgramEntity.
	node implicitReturn ifTrue: [
		expectedReturnType := scope returnType.
		returnTypeProgramEntity := localReturnTypeProgramEntity.
	] ifFalse: [
		expectedReturnType := scope nonLocalReturnType.
		returnTypeProgramEntity := scope nonLocalReturnTypeProgramEntity.
	].

	(expectedReturnType isNil and: [returnTypeProgramEntity isNotNil]) ifTrue: [
		expectedReturnType := returnTypeProgramEntity inferReturnTypeFromAnalyzedResultExpression: result expression with: self
	].
	result expectedReturnType: expectedReturnType.
	expectedReturnType ifNotNil: [
		result expression: (self addImplicitCastFor: result expression to: (expectedReturnType asConcreteTypeForAnalysisOfFunction: returnTypeProgramEntity)).
		
		expectedReturnType isMemoryReturnedType ifTrue: [
			result expression markStorageCreationNodeForCopyEllision: result
		].
	].

	localReturnTypeProgramEntity ~~ returnTypeProgramEntity ifTrue: [
		result nonLocalReturnTarget: localReturnTypeProgramEntity getNonLocalReturnTarget.
		expectedReturnType isVoidType ifFalse: [
			result nonLocalResultVariable: localReturnTypeProgramEntity getNonLocalResultVariable
		].
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSampleTextureWithDepthReferenceNode: node [
	| result |
	result := self visitSampleTextureWithImplicitLodNode: node.
	result
		depthReference: (self addImplicitCastFor: result depthReference to: self compilationTarget float32Type).
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
		type: (result texture type depth
			ifTrue: [ self compilationTarget float32Type ]
			ifFalse: [ self compilationTarget float32x4Type ]).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSequenceNode: node [
	| result explicitReturnIndex |
	result := node copy
		pragmas: (self analyzeNodesIfNeeded: node pragmas);
		elements: (self analyzeNodesIfNeeded: node elements);
		yourself.
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
	| result aggregateType valueType |
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
	aggregateType isGarbageCollectedType ifTrue: [
		result aggregate: (self ensureReferencesAreEvaluated: result aggregate)
	].
	
	"This is an special case where actually have to invoke an assign value operator, so replace myself with an unexpanded message send into assignValue:"
	valueType := result field valueType.
	((result newValue type isTemporaryReferenceType and: [ valueType hasTrivialMoveAssignment not]) or: [ valueType hasTrivialCopyAssignment not or: [ valueType isMemoryReturnedType ] ]) ifTrue: [
		^ self visitNode: ((self astBuilder unexpandedSend: ((self astBuilder literalSymbol: #assignValue:) position: node position)
			to: (MbndAstGetFieldReferenceNode new
				position: node position;
				aggregate: result aggregate;
				field: result field;
				yourself) withArguments: { result newValue })
			position: node position)
	].
	result newValue: (self addImplicitCastFor: result newValue to: valueType).

	^ result
		type: result aggregate type;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitSignExtensionCastNode: node [
	| result |
	result := self visitSpecificCastNode: node.
	(result expression isLiteralValueNode and: [ result expression value isInteger ]) ifTrue: [ 
		^ node expression copy
			position: result;
			type: result type;
			yourself
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
MbndAstSemanticAnalyzer >> visitSplicingTupleNode: nodeOrList [
	| tupleType firstElement |
	nodeOrList isMbndAstNode ifFalse: [ ^ self analyzeNodesIfNeeded: nodeOrList ].
	nodeOrList isTupleNode ifTrue: [ ^ self analyzeNodesIfNeeded: nodeOrList elements ].
	
	nodeOrList type ifNil: [ ^ self visitSplicingTupleNode: (self analyzeNodeIfNeeded: nodeOrList) ].
	tupleType := nodeOrList type.
	(tupleType isReferenceType or: [ tupleType isTemporaryReferenceType ]) ifTrue: [
		^ self visitSplicingTupleNode: (self addImplicitCastFor: nodeOrList to: tupleType withoutReferences)
	].

	tupleType isTupleType ifFalse: [ 
		self error: 'Expected a tuple value.' at: nodeOrList.
	].

	tupleType elements ifEmpty: [ ^ #() ].
	
	firstElement := MbndAstTupleSplicingNode new
		position: nodeOrList;
		tupleExpression: nodeOrList;
		elementIndex: 1;
		type: tupleType elements first;
		yourself.
	^ { firstElement } , ((2 to: tupleType elements size) collect: [ :i | MbndAstTupleSplicingNode new
		position: nodeOrList;
		tupleExpression: firstElement;
		elementIndex: i;
		type: (tupleType elements at: i);
		yourself.
	])
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
MbndAstSemanticAnalyzer >> visitTemporaryVariableNode: node [
	| result |
	result := node copy.
	result type: result valueType tempRef.
	
	result valueType hasTrivialFinalization ifFalse: [
		self addNodeWithImplicitFinalization: result
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitThisContextReferenceNode: node [
	^ node copy
		type: (self compilationTarget dynamicObjectType ifNil: [ self compilationTarget voidType pointer ]);
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTraitDeclarationNode: node [
	^ self visitTypeDeclarationNode: node ofKind: MbndTraitType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTraitDefinitionNode: node [
	^ self visitTypeDefinitionNode: node ofKind: MbndTraitType
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTupleElementReferenceNode: node [
	| result index referenceAddressSpace resultDecorations containerType tupleType rawIndex resultType |
	result := node copy container: (self analyzeNodeIfNeeded: node container).
	index := (self evaluateCompileTimeExpression: node index) unwrapMbndValue.
	index isInteger ifFalse: [ 
		self error: 'Tuple element access requires an index that can be evaluated in compile time. ' at: node.
	].

	rawIndex := index.
	node isOneBasedIndex ifTrue: [ 
		index := index - 1.
	].
	result index: index.

	referenceAddressSpace := nil.
	resultDecorations := #().
	containerType := result container type.
	containerType isReferenceType ifTrue: [ 
		referenceAddressSpace := containerType addressSpace.
		containerType := containerType baseType.
		resultDecorations := 	containerType decorations.
	].

	tupleType := containerType withoutDecorations.
	tupleType isTupleType ifFalse: [
		self error: 'A tuple reference or value is required to access one of its elements.' at: node
	].
	
	(index < 0 or: [ index >= tupleType elements size ]) ifTrue: [
		self error: 'Tuple element index {1} is out of bounds for accessing an element of tuple with type "{2}".' format: { rawIndex asString . tupleType asString } at: node
	].

	resultType := tupleType elements at: index + 1.
	referenceAddressSpace ifNotNil: [
		resultType := (resultType withDecorations: resultDecorations) refFor: referenceAddressSpace
	].

	result type: resultType.
	^ result
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
		type := self compilationTarget createNamedType: result name ofKind: typeKindClass inModule: scope module.
		type addFlags: node flags.
		owner addChild: type.
		type name isMbndAnonymousSymbol ifFalse: [ 
			owner setLocalSymbol: type name value: type.
		].
	].
	type category ifNil: [ type category: node category ].
	result binding: type.

	type enqueueDelayedSemanticAnalysis.
	result type: type type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitTypeDefinitionNode: node ofKind: typeKindClass [
	| result definitionScope |
	result := node copy.
	result declaration: (self analyzeNodeIfNeeded: result declaration ensurePartOfDefinitionFlagIsMarked).

	"Evaluate the supertype"
	node superTypeNode ifNotNil: [ :superTypeNode |
		superTypeNode isMbndType ifTrue: [
			result binding setSupertypeFromDefinition: superTypeNode
		] ifFalse: [ 
			result binding addPendingDefinitionFragment: (MbndPendingDefinitionSupertype new
				type: result binding;
				module: module;
				node: superTypeNode;
				scope: scope;
				yourself)
		].
	] ifNil: [
		typeKindClass == MbndGCClassType ifTrue: [ 
			result binding addPendingDefinitionFragment: (MbndPendingDefinitionEnsureDefaultSupertype new
				type: result binding;
				module: module;
				scope: scope;
				yourself).
		]
	].

	node usedTraits ifNotNil: [
		result binding addPendingDefinitionFragment: (MbndPendingDefinitionUsedTraits new
			type: result binding;
			node: result usedTraits;
			module: module;
			scope: scope;
			yourself).
	].

	node poolDictionaries ifNotNil: [
		result binding addPendingDefinitionFragment: (MbndPendingDefinitionPoolDictionaries new
			type: result binding;
			node: result poolDictionaries;
			module: module;
			scope: scope;
			yourself).
	].

	"Set the defined flag"
	result binding markAsDefined.

	"Create a new lexical scope for the definition body."	
	definitionScope := ((result binding programEntityScope parent: scope) newLexicalScopeAt: result).
	
	"Analyze the definition body."
	result body ifNotNil: [
		result binding addPendingDefinitionFragment: (MbndPendingDefinitionBody new
			module: module;
			node: result body;
			scope: definitionScope;
			yourself).
	].
	
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
MbndAstSemanticAnalyzer >> visitVariantBoxCreateNode: node [
	| result expectedValueType |
	result := node copy
		variantType: (self evaluateTypeExpression: node variantType);
		boxedValue: (self analyzeNodeIfNeeded: node boxedValue);
		yourself.

	result variantType isVariantUnionType ifFalse: [ 
		self error: 'Variant creation node requires a variant type to be creted.' at: result 
	].
		
	result typeSelector isInteger ifFalse: [
		result typeSelector: (self evaluateTypeExpression: result typeSelector).
		result typeSelector: (result variantType getTypeSelectorFor: result typeSelector).
		result typeSelector isInteger ifFalse: [
			self error: 'Variant creation has an invalid type specified.' at: result 
		]
	].

	expectedValueType := result variantType typeWithSelector: result typeSelector.
	result boxedValue: (self addImplicitCastFor: result boxedValue to: expectedValueType).

	result type: result variantType tempRef.

	result variantType hasTrivialFinalization ifFalse: [ 
		self addNodeWithImplicitFinalization: result
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitVariantTypeSelectorExtractionNode: node [
	| result |
	result := node copy
		variant: (self analyzeNodeIfNeeded: node variant);
		yourself.
	result variant type withoutReferences withoutTopDecorations isVariantUnionType ifFalse: [
		self error: 'Expected a variant union type for extracting a type selector.' at: result.
	].

	result type: self compilationTarget uint8Type.
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitVariantUnboxingAssignmentReferenceNode: node [
	| result |
	result := self visitVariantUnboxingNode: node.
	(result type isReferenceType or: [ result type isTemporaryReferenceType ]) ifFalse: [ 
		self error: 'Cannot create an assignment component reference for a variant that is not a reference.' at: result. 
	].

	result type baseType isConstantType ifTrue: [ 
		self error: 'Cannot create an assignment component reference for a const referenced variant.' at: node. 
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitVariantUnboxingNode: node [
	| result variantType resultType referenceType |
	result := node copy
		variant: (self analyzeNodeIfNeeded: node variant);
		yourself.
	
	variantType := result variant type withoutReferences withoutTopDecorations.
	self assert: variantType isVariantUnionType.
	
	result typeSelector isInteger ifFalse: [ 
		| selector |
		result typeSelector: (self evaluateTypeExpression: result typeSelector).
		selector := variantType getTypeSelectorFor: result typeSelector.
		selector ifNil: [
			self error: 'Cannot extract value of type {1} of variant type {2}.'format: { result typeSelector asString .variantType asString } at: result
		].
	
		result typeSelector: selector
	].

	resultType := variantType typeWithSelector: result typeSelector.
	self assert: resultType isNotNil.
	
	referenceType := result variant type.
	referenceType isReferenceType ifTrue: [ 
		resultType := (resultType withDecorations: referenceType baseType decorations) refFor: referenceType addressSpace
	].
	referenceType isTemporaryReferenceType ifTrue: [ 
		resultType := (resultType withDecorations: referenceType baseType decorations) tempRefFor: referenceType addressSpace
	].

	result type: resultType.
	^ result
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
	
	(result elements allSatisfy: [ :each | each isLiteralValueNode ]) ifTrue: [
		| literalSlots |
		literalSlots := Array streamContents: [ :out |
			result elements do: [ :each |
				each type isPrimitiveVectorType ifTrue: [ 
					out nextPutAll: each evaluateMbndValue unwrapMbndValue slots
				] ifFalse: [ 
					out nextPut: each evaluateMbndValue unwrapMbndValue
				]
			]
		].
	
		^ (MbndVectorTypeInstanceValue new
			type: result type;
			slots: literalSlots;
			yourself) asLiteralValueNode
				position: result;
				yourself
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
		yourself.
	vectorType := result vector type withoutReferences withoutTopDecorations.
	self assert: vectorType isPrimitiveVectorType.
	(result vector type isReferenceType and: [ result vector type baseType isConstantType ]) ifTrue: [
		result vector: (self addImplicitCastFor: result vector to: vectorType)
	].

	result values: (node values collect: [:value |
		self ensureConcreteValue: (self analyzeNodeIfNeeded: value).
	]).
	
	^ result
		type: result vector type;
		yourself

]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitWhileLoopNode: node [
	| result condition booleanType |
	result := node copy.
	condition := self analyzeNodeIfNeeded: result condition.
	booleanType := condition type isGarbageCollectedType
		ifTrue: [ self compilationTarget dynamicObjectType ]
		ifFalse: [ self compilationTarget booleanType ].
	result
		condition: (self addImplicitCastFor: condition to: booleanType);
		type: self compilationTarget voidType.
	
	self withContinueAndBreakOwnerNode: node do: [ 
		result action: (result action ifNotNil: [:action | self analyzeNodeIfNeeded: action]).
	].

	result	 continueAction: (result continueAction ifNotNil: [:action | self analyzeNodeIfNeeded: action]).
	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> visitZeroExtensionCastNode: node [
	| result |
	result := self visitSpecificCastNode: node.
	(result expression isLiteralValueNode and: [ result expression value isInteger and: [ result expression value >= 0]]) ifTrue: [ 
		^ node expression copy
			position: result;
			type: result type;
			yourself
	].

	^ result
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> vistVAListEndExpressionNode: node [
	^ node copy
		valist: (self analyzeNodeIfNeeded: node valist);
		type: self compilationTarget voidType;
		yourself
]

{ #category : #visiting }
MbndAstSemanticAnalyzer >> vistVAListStartExpressionNode: node [
	^ node copy
		valist: (self analyzeNodeIfNeeded: node valist);
		type: self compilationTarget voidType;
		yourself
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

{ #category : #visiting }
MbndAstSemanticAnalyzer >> withExceptionScope: cleanUpScope do: aBlock [
	| oldCleanUpScope |
	oldCleanUpScope := currentCleanUpScope.
	currentCleanUpScope := cleanUpScope.
	
	aBlock ensure: [ currentCleanUpScope := oldCleanUpScope ]
]
