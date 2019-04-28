Class {
	#name : #MbndCompilerObjectType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndCompilerObjectType class >> typeName [
	^ #_CompilerObjectType
]

{ #category : #'semantic analysis' }
MbndCompilerObjectType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| receiver arguments result selector |
	node selector isLiteralSymbolValueNode ifFalse: [
		self error: 'Constant selectors are required for messages to compiler objects.' at: node
	].

	self assert: node receiver isNotNil.
	
	node hasOnlyLiterals ifFalse: [ 
		self halt
	].

	receiver := (analyzer evaluateCompileTimeExpression: node receiver) unwrapMbndValue.
	arguments := node arguments collect: [ (analyzer evaluateCompileTimeExpression: node receiver) unwrapMbndValue. ].
	selector := node selector value.
	(receiver class lookupSelector: selector) ifNil: [ 
		self error: 'Cannot send message {1} to compiler object {2}.' format: {selector printString . receiver printString} at: node
	].

	result := receiver perform: selector value withArguments: arguments.
	^ analyzer visitNode: (result asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
]

{ #category : #testing }
MbndCompilerObjectType >> isCompilerObjectType [
	^ true
]
