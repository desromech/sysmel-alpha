Trait {
	#name : #TMbndMacro,
	#traits : 'TMbndProgramEntity - {#hasPublicVisibility} + TMbndFlagContainer + TMbndEntityWithVisibility',
	#classTraits : 'TMbndProgramEntity classTrait + TMbndFlagContainer classTrait + TMbndEntityWithVisibility classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
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

{ #category : #testing }
TMbndMacro >> isFallbackMacro [
	^ false
]
