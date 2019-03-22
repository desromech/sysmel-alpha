Trait {
	#name : #TMbndMacro,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#category : #'MoebiusBandMetamodel-Core-Macro'
}

{ #category : #errors }
TMbndMacro >> error: anErrorString at: aSourcePosition [
	<compileTime>
	^ MbndSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		signal
]

{ #category : #'as yet unclassified' }
TMbndMacro >> expandMessageNode: node with: analyzer [
	self explicitRequirement
]
