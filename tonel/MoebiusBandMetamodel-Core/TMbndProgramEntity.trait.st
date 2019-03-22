Trait {
	#name : #TMbndProgramEntity,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#category : #'MoebiusBandMetamodel-Core-ProgramEntity'
}

{ #category : #'macro expansion' }
TMbndProgramEntity >> lookupMacroSelector: aSelector [
	^ nil
]

{ #category : #accessing }
TMbndProgramEntity >> module [
	self explicitRequirement
]

{ #category : #accessing }
TMbndProgramEntity >> name [
	^ self explicitRequirement
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScope [
	^ self programEntityScopeClass new programEntity: self
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScopeClass [
	^ MbndProgramEntityScope
]
