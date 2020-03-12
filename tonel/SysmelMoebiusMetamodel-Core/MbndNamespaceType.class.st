Class {
	#name : #MbndNamespaceType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndNamespaceType class >> typeName [
	^ #_NamespaceType
]

{ #category : #visiting }
MbndNamespaceType >> accept: aVisitor [
	^ aVisitor visitNamespaceType: self
]

{ #category : #'semantic analysis' }
MbndNamespaceType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| namespaceEntity method |
	node receiver isLiteralValueNode ifTrue: [ 
		node selector isLiteralSymbolValueNode ifTrue: [ 
			namespaceEntity := node receiver value.
			self assert: namespaceEntity isNamespace.
		
			"Check for an overloaded method."
			method := namespaceEntity lookupOverloadedSelector: node selector value.
			method ifNotNil: [
				^ method analyzeExpandedMessageSendNode: node with: analyzer
			].
		
			self error: 'Cannot find member named {1} in namespace {2}.' format: {node selector printValueString . namespaceEntity fullName} at: node
		].
	].

	^ super analyzeUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndNamespaceType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	| namespaceEntity macroMethod |
	(node receiver isLiteralValueNode and: [node selector isLiteralSymbolValueNode]) ifTrue: [ 
		namespaceEntity := node receiver value.
		self assert: namespaceEntity isNamespace.
		
		macroMethod := namespaceEntity lookupMacroSelector: node selector value.
		macroMethod ifNotNil: [
			^ macroMethod expandMessageNode: node with: analyzer
		].
	].

	^ super analyzeUnboundUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'testing methods' }
MbndNamespaceType >> isNamespaceType [
	^ true
]

{ #category : #testing }
MbndNamespaceType >> isTrait [
	^ false
]
