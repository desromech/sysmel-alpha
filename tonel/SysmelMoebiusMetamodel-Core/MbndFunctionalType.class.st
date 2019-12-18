Class {
	#name : #MbndFunctionalType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionalType class >> typeName [
	^ #_FunctionalType
]

{ #category : #initialization }
MbndFunctionalType >> addInstanceMacros [
	self class == MbndFunctionalType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self onMacroSelector: #applyWithArguments: do: [ :node :builder |
		(builder call: node receiver arguments: node arguments first)
			position: node
	]
]

{ #category : #'as yet unclassified' }
MbndFunctionalType >> analyzeFunctionCallNode: node with: analyzer [
	self subclassResponsibility
]

{ #category : #testing }
MbndFunctionalType >> isFunctionalType [
	<compileTime>
	^ true
]
