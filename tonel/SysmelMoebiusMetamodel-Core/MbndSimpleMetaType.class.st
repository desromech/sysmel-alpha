Class {
	#name : #MbndSimpleMetaType,
	#superclass : #MbndBasicType,
	#instVars : [
		'instanceType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSimpleMetaType class >> typeName [
	^ #_SimpleMetaType
]

{ #category : #'semantic analysis' }
MbndSimpleMetaType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| arguments selector result |
	node selector isLiteralSymbolValueNode ifTrue: [
		selector := node selector value.
		(self class lookupSelector: selector) ifNotNil: [ :method |
			(method hasPragmaNamed: #compileTime) ifTrue: [
				arguments := node arguments collect: [ :arg | (analyzer evaluateCompileTimeExpression: arg) unwrapMbndValue ].
				result := self perform: selector withArguments: arguments.
				^ analyzer visitNode: (result asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
			]
		]
	].

	^ super analyzeUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
MbndSimpleMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #'testing methods' }
MbndSimpleMetaType >> isMetaType [
	^ true
]

{ #category : #accessing }
MbndSimpleMetaType >> printOn: aStream [
	instanceType ifNil: [ ^ super printOn: aStream ].
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'.
]
