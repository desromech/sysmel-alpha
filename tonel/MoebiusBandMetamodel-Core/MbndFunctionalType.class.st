Class {
	#name : #MbndFunctionalType,
	#superclass : #MbndBasicType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
MbndFunctionalType class >> typeName [
	^ #_FunctionalType
]

{ #category : #initialization }
MbndFunctionalType >> initialize [
	super initialize.
	
	self onMacroSelector: #applyWithArguments: do: [ :node :builder |
		(builder call: node receiver arguments: node arguments first)
			position: node
	]
]
