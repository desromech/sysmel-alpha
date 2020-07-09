Class {
	#name : #MbndPrivateAccessingMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#instVars : [
		'aggregateNode',
		'aggregateType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #accessing }
MbndPrivateAccessingMetaBuilder >> aggregateNode [
	^ aggregateNode
]

{ #category : #accessing }
MbndPrivateAccessingMetaBuilder >> aggregateNode: anObject [
	aggregateNode := anObject
]

{ #category : #accessing }
MbndPrivateAccessingMetaBuilder >> aggregateType [
	^ aggregateType
]

{ #category : #accessing }
MbndPrivateAccessingMetaBuilder >> aggregateType: anObject [
	aggregateType := anObject
]

{ #category : #'as yet unclassified' }
MbndPrivateAccessingMetaBuilder >> analyzeField: field getter: node with: analyzer [
	| receiverType |
	receiverType := aggregateNode type withoutTopDecorations.
	receiverType isReferenceLikeValueType ifTrue: [
		^ analyzer visitNode: (MbndAstGetFieldReferenceNode new
			position: node;
			aggregate: aggregateNode;
			field: field;
			yourself)
	].
	
	^ analyzer visitNode: (MbndAstGetFieldValueNode new
		position: node;
		aggregate: aggregateNode;
		field: field;
		yourself)
]

{ #category : #'as yet unclassified' }
MbndPrivateAccessingMetaBuilder >> analyzeField: field setter: node with: analyzer [
	self assert: node arguments size = 1.
	^ analyzer visitNode: (MbndAstSetFieldValueNode new
		position: node;
		aggregate: aggregateNode;
		field: field;
		newValue: node arguments first;
		yourself)
]

{ #category : #'semantic analysis' }
MbndPrivateAccessingMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector selectorArity fieldName field |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		selectorArity := selector numArgs.
		selectorArity <= 1 ifTrue: [ 
			fieldName := selectorArity = 0 ifTrue: [ selector ] ifFalse: [ selector allButLast asSymbol ].
			field := aggregateType findFirstFieldNamed: fieldName.
			field ifNotNil: [
				selectorArity = 0 ifTrue: [
					^ self analyzeField: field getter: node with: analyzer
				].
				selectorArity = 0 ifTrue: [ 
					^ self analyzeField: field setter: node with: analyzer
				].
			].
		].
	].

	^ super analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndPrivateAccessingMetaBuilder >> concretizeNodeAt: node withAnalyzer: analyzer [
	^ aggregateNode
]
