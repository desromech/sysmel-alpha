Class {
	#name : #MbndAbstractMetaType,
	#superclass : #MbndBasicType,
	#instVars : [
		'instanceType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractMetaType class >> typeName [
	^ #Type
]

{ #category : #initialization }
MbndAbstractMetaType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self addConversionTo: self compilationTarget astNodeType rule: MbndWrapInLiteralValueNodeTypeConversionRule
]

{ #category : #'semantic analysis' }
MbndAbstractMetaType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
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
MbndAbstractMetaType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
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
MbndAbstractMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
MbndAbstractMetaType >> instanceType: anObject [
	instanceType := anObject.
	name := nil.
]

{ #category : #'testing methods' }
MbndAbstractMetaType >> isMetaType [
	^ true
]
