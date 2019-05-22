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
			selector := self sanitizeBuilderSelector: node selector value.
			(selector isSymbol and: [selector numArgs == 0]) ifTrue: [
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

{ #category : #'semantic analysis' }
MbndAbstractNamedMetaBuilder >> sanitizeBuilderSelector: selector [
	selector = #class ifTrue: [ ^ #nativeClass ].
	^ selector
]
