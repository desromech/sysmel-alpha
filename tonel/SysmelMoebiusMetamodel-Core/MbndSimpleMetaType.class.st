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

{ #category : #visiting }
MbndSimpleMetaType >> accept: aVisitor [
	^ aVisitor visitSimpleMetaType: self
]

{ #category : #initialization }
MbndSimpleMetaType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self addConversionTo: self compilationTarget astNodeType rule: MbndWrapInLiteralValueNodeTypeConversionRule
]

{ #category : #'semantic analysis' }
MbndSimpleMetaType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| arguments selector result receiverValue |
	(node receiver isLiteralValueNode and:
	[ node selector isLiteralSymbolValueNode ]) ifTrue: [
		selector := node selector value.
		receiverValue := node receiver value.
		(receiverValue class lookupSelector: selector) ifNotNil: [ :method |
			(method hasPragmaNamed: #compileTime) ifTrue: [
				arguments := node arguments collect: [ :arg | (analyzer evaluateCompileTimeExpression: arg) unwrapMbndValue ].
				result := receiverValue perform: selector withArguments: arguments.
				^ analyzer visitNode: (result asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
			]
		]
	].

	^ super analyzeUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndSimpleMetaType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	| selector receiverValue |
	(node receiver isLiteralValueNode and:
	[ node selector isLiteralSymbolValueNode ]) ifTrue: [
		selector := node selector value.
		receiverValue := node receiver value.
		(instanceType lookupPublicMetaBuilderFactoryNamed: selector withAnalyzer: analyzer) ifNotNil: [ :factory |
			^ factory analyzeReferenceNode: node ownerProgramEntity: receiverValue with: analyzer
		].
	].

	^ super analyzeUnboundUnexpandedMessageSendNode: node with: analyzer
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
