Class {
	#name : #MbndAbstractNamedMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#instVars : [
		'name'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndAbstractNamedMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector |
	name ifNil: [ 
		node selector isLiteralSymbolValueNode ifTrue: [
			selector := node selector value.
			(selector numArgs == 0) ifTrue: [
				name := selector.
				^ node receiver
			]
		]
	].
	
	^ super analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #accessing }
MbndAbstractNamedMetaBuilder >> name [
	^ name
]

{ #category : #accessing }
MbndAbstractNamedMetaBuilder >> name: anObject [
	^ name := anObject
]
