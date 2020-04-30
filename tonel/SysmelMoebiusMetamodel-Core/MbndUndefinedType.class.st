Class {
	#name : #MbndUndefinedType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUndefinedType class >> typeName [
	^ #_UndefinedType
]

{ #category : #visiting }
MbndUndefinedType >> accept: aVisitor [
	^ aVisitor visitUndefinedType: self
]

{ #category : #adding }
MbndUndefinedType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndPointerArithmeticOperationCoercionMacro new)
]

{ #category : #adding }
MbndUndefinedType >> addComparison: selector intrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicPointerComparisonMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self compilationTarget booleanType
]

{ #category : #adding }
MbndUndefinedType >> addComparisonIntrinsics [
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
MbndUndefinedType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	
	self
		addConversionTo: self compilationTarget voidType rule: MbndConcretizeUndefinedTypeConversionRule;
		addConversionRule: (MbndConcretizeUndefinedTypeConversionRule when: [:source :target |
			target withoutTopDecorations isPointerType or: [ target isGarbageCollectedType ]
	])

]

{ #category : #converting }
MbndUndefinedType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget voidType pointer
]

{ #category : #'default values' }
MbndUndefinedType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #adding }
MbndUndefinedType >> initialize [
	super initialize.
	self addComparisonIntrinsics
]

{ #category : #sizes }
MbndUndefinedType >> instanceAlignment [
	<compileTime>
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndUndefinedType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #testing }
MbndUndefinedType >> isTrait [
	^ false
]

{ #category : #'testing methods' }
MbndUndefinedType >> isUndefinedType [
	^ true
]
