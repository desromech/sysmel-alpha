Class {
	#name : #MbndGlobalVariable,
	#superclass : #MbndAbstractVariable,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'initialValueKind',
		'currentValue',
		'type',
		'initialValueFunclet',
		'constructionPriority'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndGlobalVariable >> accept: aVisitor [
	^ aVisitor visitGlobalVariable: self
]

{ #category : #'compile time evaluation' }
MbndGlobalVariable >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	valueType = referenceType ifTrue: [ ^ self currentValue ].
	type = referenceType ifTrue: [ ^ MbndValue value: self type: referenceType ].
	evaluator error: 'Invalid compile time variable reference.' at: node
]

{ #category : #accessing }
MbndGlobalVariable >> constructionPriority [
	^ constructionPriority
]

{ #category : #accessing }
MbndGlobalVariable >> constructionPriority: anObject [
	constructionPriority := anObject
]

{ #category : #accessing }
MbndGlobalVariable >> currentRawValue [
	^ currentValue
]

{ #category : #accessing }
MbndGlobalVariable >> currentValue [
	self validateCurrentValue.
	(self hasFlag: #notInCompileTime) ifTrue: [ 
		self errorNotInCompileTime: 'Cannot evaluate value of global variable {1} in compile time.' format: { name asPrettySymbolName } at: definitionNode
	].
	^ currentValue
]

{ #category : #accessing }
MbndGlobalVariable >> currentValue: anObject [
	self validateCurrentValue.
	currentValue := anObject
]

{ #category : #'semantic analysis' }
MbndGlobalVariable >> ensureSemanticAnalysis [
	super ensureSemanticAnalysis.
	self validateCurrentValue
]

{ #category : #testing }
MbndGlobalVariable >> hasValidCurrentValue [
	^ self hasFlag: #validCurrentValue
]

{ #category : #testing }
MbndGlobalVariable >> hasValidCurrentValue: aBoolean [
	self setFlag: #validCurrentValue value: aBoolean
]

{ #category : #accessing }
MbndGlobalVariable >> initialValueFunclet [
	^ initialValueFunclet
]

{ #category : #accessing }
MbndGlobalVariable >> initialValueFunclet: anObject [
	initialValueFunclet := anObject
]

{ #category : #accessing }
MbndGlobalVariable >> initialValueKind [
	^ initialValueKind
]

{ #category : #accessing }
MbndGlobalVariable >> initialValueKind: anObject [
	initialValueKind := anObject
]

{ #category : #testing }
MbndGlobalVariable >> isGlobalVariable [
	^ true
]

{ #category : #testing }
MbndGlobalVariable >> isStatic [
	^ self hasFlag: #static
]

{ #category : #testing }
MbndGlobalVariable >> isThreadLocal [
	^ self hasFlag: #threadLocal
]

{ #category : #testing }
MbndGlobalVariable >> needsConstructor [
	(self hasFlag: #notInCompileTime) ifTrue: [ ^ true ].
	initialValueKind = #evaluated ifTrue: [ ^ false ].
	initialValueKind = #default ifTrue: [ ^ valueType hasTrivialInitialization not ].
	initialValueKind = #copy ifTrue: [ ^ valueType hasTrivialInitializationCopyingFrom not ].
	^ false
]

{ #category : #testing }
MbndGlobalVariable >> needsDestructor [
	^ valueType hasTrivialFinalization not
]

{ #category : #accessing }
MbndGlobalVariable >> type [
	^ type
]

{ #category : #accessing }
MbndGlobalVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
MbndGlobalVariable >> validateCurrentValue [
	self hasValidCurrentValue ifTrue: [ ^ self ].
	"Do not allow circular values."
	(self hasFlag: #evaluatingInitialValue) ifTrue: [ self errorNotInCompileTime: 'Cannot evaluate global variable value in compile time.' at: definitionNode ].

	self addFlag: #evaluatingInitialValue.
	initialValueFunclet ifNil: [ 
		currentValue := valueType defaultValueAt: definitionNode.
		self initialValueKind: #default.
	] ifNotNil: [
		initialValueFunclet
			parent: self;
			setArguments: #() returnType: valueType.
		[
			currentValue := initialValueFunclet evaluateWithReceiver: nil arguments: #() at: definitionNode.
			self initialValueKind: #evaluated.
		] on: MbndNotInCompileTimeError do: [ :e |
			currentValue := valueType defaultValueAt: definitionNode.
			self addFlag: #notInCompileTime.
			self initialValueKind: #copy.
		].
	].
	self removeFlag: #evaluatingInitialValue.

	self hasValidCurrentValue: true.
	
]

{ #category : #evaluating }
MbndGlobalVariable >> value [
	^ self currentValue
]

{ #category : #accessing }
MbndGlobalVariable >> value: aValue [
	self currentValue: aValue
]
