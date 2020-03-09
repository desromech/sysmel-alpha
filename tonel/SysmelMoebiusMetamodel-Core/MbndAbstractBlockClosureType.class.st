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
