Class {
	#name : #MbndFunctionalType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionalType class >> typeName [
	^ #_FunctionalType
]

{ #category : #'as yet unclassified' }
MbndFunctionalType >> analyzeFunctionCallNode: node with: analyzer [
	self subclassResponsibility
]

{ #category : #initialization }
MbndFunctionalType >> initialize [
	super initialize.
	
	self onMacroSelector: #applyWithArguments: do: [ :node :builder |
		(builder call: node receiver arguments: node arguments first)
			position: node
	]
]

{ #category : #testing }
MbndFunctionalType >> isFunctionalType [
	^ true
]
