Class {
	#name : #MbndAbstractSpecificCompilerObjectType,
	#superclass : #MbndCompilerObjectType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndAbstractSpecificCompilerObjectType class >> typeName [
	^ #_AbstractSpecificCompilerObjectType
]

{ #category : #accessing }
MbndAbstractSpecificCompilerObjectType >> behavior [
	self subclassResponsibility
]

{ #category : #'semantic analysis' }
MbndAbstractSpecificCompilerObjectType >> resultTypeForMessageSendToHost: selector [
	| selectorValue returnTypeName |
	selector isLiteralValueNode ifTrue: [ 
		selectorValue := selector value.
		(self behavior lookupSelector: selectorValue) ifNotNil: [ :compiledMethod |
			(compiledMethod pragmaAt: #returnType:) ifNotNil: [ :pragma |
				returnTypeName := pragma arguments first.
				returnTypeName isSymbol ifTrue: [
					^ self compilationTarget getBasicTypeNamed: returnTypeName
				].
			
				self halt
			]
		].
	].

	^ super resultTypeForMessageSendToHost: selector
]
