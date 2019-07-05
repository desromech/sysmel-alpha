Class {
	#name : #MbndPointerType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPointerType class >> typeName [
	^ #_PointerType
]

{ #category : #visiting }
MbndPointerType >> accept: aVisitor [
	^ aVisitor visitPointerType: self
]

{ #category : #initialization }
MbndPointerType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndPointerArithmeticOperationCoercionMacro new)
]

{ #category : #initialization }
MbndPointerType >> addComparison: selector intrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicPointerComparisonMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self compilationTarget booleanType
]

{ #category : #initialization }
MbndPointerType >> addComparisonIntrinsics [
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

{ #category : #adding }
MbndPointerType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self isTrait ifFalse: [
		self
			addExplicitConversionRule: MbndPointerExplicitVoidReinterpretTypeConversionRule new;
			addImplicitConversionRule: MbndPointerImplicitVoidReinterpretTypeConversionRule new.
	].

]

{ #category : #initialization }
MbndPointerType >> addInstanceMacros [
	self class == MbndPointerType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelectors: #(value _) do: [ :node :builder |
			(builder pointerAsReference: node receiver)
				position: node
		];
		onMacroSelector: #value: do: [ :node :builder |
			| ref |
			ref := (builder pointerAsReference: node receiver)
				position: node;
				yourself.
			(builder reference: ref assignValue: node arguments first)
				position: node
		];
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder pointer: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder pointer: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		];
		onMacroSelector: #+ do: [ :node :builder |
			self halt
		];
		onMacroSelector: #- do: [ :node :builder |
			self halt
		].
]

{ #category : #converting }
MbndPointerType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType |
	undecoratedTargetType := targetType withoutTopDecorations.
	
	undecoratedTargetType isPointerType ifTrue: [
		^ analyzer visitNode: (MbndAstPointerReinterpretCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	(undecoratedTargetType isPrimitiveIntegerType and: [ undecoratedTargetType instanceSize = self instanceSize ]) ifTrue: [
		^ analyzer visitNode: (MbndAstPointerToIntegerCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #converting }
MbndPointerType >> asCVariadicTypeRequiredAt: position [
	^ self
]

{ #category : #converting }
MbndPointerType >> asPointerType [
	^ self
]

{ #category : #converting }
MbndPointerType >> asReferenceType [
	^ baseType refFor: addressSpace
]

{ #category : #'default values' }
MbndPointerType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #initialization }
MbndPointerType >> initialize [
	super initialize.
	self addComparisonIntrinsics
]

{ #category : #'testing methods' }
MbndPointerType >> isPointerType [
	^ true
]

{ #category : #printing }
MbndPointerType >> printOn: aStream [
	baseType printOn: aStream.
	aStream nextPutAll: ' pointer'
]

{ #category : #'type composition' }
MbndPointerType >> withoutDecorations [
	^ baseType withoutDecorations pointerFor: addressSpace
]
