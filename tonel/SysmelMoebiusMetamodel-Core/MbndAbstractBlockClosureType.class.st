Class {
	#name : #MbndAbstractBlockClosureType,
	#superclass : #MbndFunctionalType,
	#instVars : [
		'functionType',
		'functionTypeWithClosureParameter'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractBlockClosureType class >> typeName [
	^ #_AbstractBlockClosureType
]

{ #category : #adding }
MbndAbstractBlockClosureType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndPointerArithmeticOperationCoercionMacro new)
]

{ #category : #adding }
MbndAbstractBlockClosureType >> addComparison: selector intrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicPointerComparisonMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self compilationTarget booleanType
]

{ #category : #adding }
MbndAbstractBlockClosureType >> addComparisonIntrinsics [
	self
		addComparison: #= intrinsic: #eq;
		addComparison: #== intrinsic: #eq;
		addComparison: #~= intrinsic: #ne;
		addComparison: #~~ intrinsic: #ne;
		
		addComparison: #< intrinsic: #lt;
		addComparison: #<= intrinsic: #le;
		addComparison: #> intrinsic: #gt;
		addComparison: #>= intrinsic: #ge
]

{ #category : #initialization }
MbndAbstractBlockClosureType >> addInstanceMacros [
	self class == MbndAbstractBlockClosureType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelector: #on:do: do: [ :node :builder |
			(builder exceptionLexicalScope: (builder macroInlineBlock: node receiver)
				catchExpressions: {
					(builder exceptionCatch: node arguments first doing: node arguments second)
						position: node
				} cleanUpActions: #())
				position: node
		];
		onMacroSelector: #ensure: do: [ :node :builder |
			(builder exceptionLexicalScope: (builder macroInlineBlock: node receiver)
					catchExpressions: #() cleanUpActions: { (builder macroInlineBlock: node arguments first) })
				position: node
		].
]

{ #category : #'as yet unclassified' }
MbndAbstractBlockClosureType >> analyzeFunctionCallNode: node with: analyzer [
	^ functionType analyzeFunctionCallNode: node with: analyzer
]

{ #category : #converting }
MbndAbstractBlockClosureType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType |
	undecoratedTargetType := targetType withoutTopDecorations.
	
	undecoratedTargetType isPointerLikeValueType ifTrue: [
		^ analyzer visitNode: (MbndAstPointerReinterpretCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> argumentTypes [
	<compileTime>
	^ functionType argumentTypes
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> closureKind [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndAbstractBlockClosureType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionType [
	<compileTime>
	^ functionType
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionType: anObject [
	functionType := anObject
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> functionTypeWithClosureParameter [
	^ functionTypeWithClosureParameter ifNil: [ functionTypeWithClosureParameter := functionType prependArguments: { self } ]
]

{ #category : #initialization }
MbndAbstractBlockClosureType >> initialize [
	super initialize.
	self addComparisonIntrinsics
]

{ #category : #sizes }
MbndAbstractBlockClosureType >> instanceAlignment [
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndAbstractBlockClosureType >> instanceSize [
	^ self compilationTarget pointerSize
]

{ #category : #'testing methods' }
MbndAbstractBlockClosureType >> isBlockClosureType [
	^ true
]

{ #category : #'testing methods' }
MbndAbstractBlockClosureType >> isPointerLikeValueType [
	^ true
]

{ #category : #accessing }
MbndAbstractBlockClosureType >> returnType [
	<compileTime>
	^ functionType returnType
]
