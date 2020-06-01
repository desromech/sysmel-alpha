Class {
	#name : #MbndCompilerObjectType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndCompilerObjectType class >> typeName [
	^ #_CompilerObjectType
]

{ #category : #visiting }
MbndCompilerObjectType >> accept: aVisitor [
	^ aVisitor visitCompilerObjectType: self
]

{ #category : #adding }
MbndCompilerObjectType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self class == MbndCompilerObjectType ifFalse: [ ^ self ].
	self addExplicitConversionTo: self compilationTarget astNodeType rule: MbndWrapInLiteralValueNodeTypeConversionRule.
]

{ #category : #'semantic analysis' }
MbndCompilerObjectType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	| receiver arguments result selector resultType |
	node selector isLiteralSymbolValueNode ifFalse: [
		self error: 'Constant selectors are required for messages to compiler objects.' at: node
	].

	self assert: node receiver isNotNil.
	
	node hasOnlyLiterals ifFalse: [
		resultType := self resultTypeForMessageSendToHost: node selector.
		^ MbndAstExpandedHostMessageSendNode new
			position: node;
			receiver: (analyzer ensureReferencesAreEvaluated: (analyzer analyzeNodeIfNeeded: node receiver));
			selector: node selector;
			arguments: (analyzer analyzeNodesIfNeeded: node arguments);
			type: resultType
	].

	receiver := (analyzer evaluateCompileTimeExpression: node receiver) unwrapMbndValue.
	arguments := node arguments collect: [ :arg | (analyzer evaluateCompileTimeExpression: arg) unwrapMbndValue. ].
	selector := node selector value.
	(receiver class lookupSelector: selector) ifNil: [ 
		self error: 'Cannot send message {1} to compiler object {2}.' format: {selector printString . receiver printString} at: node
	].

	result := receiver perform: selector value withArguments: arguments.
	^ analyzer visitNode: (result asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
]

{ #category : #'as yet unclassified' }
MbndCompilerObjectType >> assistBlockClosureNodeTypeInference: each asArgument: argumentIndex with: analyzer [
	^ each assistTypeInferenceWithDefaultArgumentType: self compilationTarget compilerObjectType
		returnType: self compilationTarget compilerObjectType with: analyzer
]

{ #category : #'default values' }
MbndCompilerObjectType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #sizes }
MbndCompilerObjectType >> instanceAlignment [
	<compileTime>
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndCompilerObjectType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #testing }
MbndCompilerObjectType >> isCompilerObjectType [
	^ true
]

{ #category : #testing }
MbndCompilerObjectType >> isTrait [
	^ false
]

{ #category : #'semantic analysis' }
MbndCompilerObjectType >> resultTypeForMessageSendToHost: selector [
	^ self compilationTarget compilerObjectType
]

{ #category : #'as yet unclassified' }
MbndCompilerObjectType >> underlyingObjectType [
	self compilationTarget dynamicObjectType ifNotNil: [ :dynobjectType | ^ dynobjectType ].
	^ self compilationTarget voidType pointer
]
