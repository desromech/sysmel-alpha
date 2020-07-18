Class {
	#name : #MbndVAListType,
	#superclass : #MbndAggregateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndVAListType class >> typeName [
	^ #VAList
]

{ #category : #visiting }
MbndVAListType >> accept: aVisitor [
	^ aVisitor visitVAListType: self
]

{ #category : #initialization }
MbndVAListType >> addInstanceMacros [
	self class == MbndVAListType ifFalse: [ ^ self ].
	self
		onMacroSelector: #start do: [ :node :builder |
			(builder valistStart: node receiver)
				position: node ];
		onMacroSelector: #end do: [ :node :builder |
			(builder valistEnd: node receiver)
				position: node
		]; 
		yourself
]

{ #category : #'default values' }
MbndVAListType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #'testing methods' }
MbndVAListType >> generateBasicNewValueForNode: node with: builder andWith: analyzer [
	^ builder temporaryVariableOfType: self
]

{ #category : #'testing methods' }
MbndVAListType >> isTrait [
	^ false
]
