Class {
	#name : #MbndFieldBoundWithReceiver,
	#superclass : #MbndImplicitReceiverBoundSymbol,
	#instVars : [
		'field'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
MbndFieldBoundWithReceiver >> analyzeReferenceNode: referenceNode with: analyzer [
	| receiverReference getterClass getterNode result |
	receiverReference := receiver analyzeReferenceNode: referenceNode with: analyzer.
	getterClass := (receiverReference type withoutTopDecorations isReferenceLikeValueType and: [ field bits isNil ])
		ifTrue: [ MbndAstGetFieldReferenceNode ]
		ifFalse: [ MbndAstGetFieldValueNode ].
		
	getterNode := getterClass new
		position: referenceNode;
		aggregate: receiverReference;
		field: field;
		yourself.

	result := analyzer visitNode: getterNode.
	(referenceNode shouldBeAccessedAsDynamicObject and: [ field valueType isGarbageCollectedType ]) ifTrue: [
		| dynamicObjectType |
		dynamicObjectType := analyzer compilationTarget dynamicObjectType.
		result type withoutReferences withoutTopDecorations ~~ dynamicObjectType ifTrue: [ 
			result type isReferenceType ifTrue: [
				result := (analyzer astBuilder reinterpretCast: result to: (dynamicObjectType refFor: result type addressSpace))
					position: referenceNode.
			] ifFalse: [ 
				result := (analyzer astBuilder implicitCast: result to: dynamicObjectType)
					position: referenceNode.
			].
			result := analyzer visitNode: result.
		]
	].
	^ result
]

{ #category : #accessing }
MbndFieldBoundWithReceiver >> field [
	^ field
]

{ #category : #accessing }
MbndFieldBoundWithReceiver >> field: anObject [
	field := anObject
]
