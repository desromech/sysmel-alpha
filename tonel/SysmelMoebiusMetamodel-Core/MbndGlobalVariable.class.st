Class {
	#name : #MbndGlobalVariable,
	#superclass : #MbndAbstractVariable,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'initialValueNode',
		'currentValue',
		'type'
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
MbndGlobalVariable >> currentValue [
	self validateCurrentValue.
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
MbndGlobalVariable >> initialValueNode [
	^ initialValueNode
]

{ #category : #accessing }
MbndGlobalVariable >> initialValueNode: anObject [
	initialValueNode := anObject
]

{ #category : #testing }
MbndGlobalVariable >> isGlobalVariable [
	^ true
]

{ #category : #testing }
MbndGlobalVariable >> isStatic [
	^ self hasFlag: #static
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
	initialValueNode ifNil: [ 
		currentValue := valueType defaultValueAt: definitionNode
	] ifNotNil: [
		currentValue := initialValueNode evaluate.
	].

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
