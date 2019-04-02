Trait {
	#name : #TMbndProgramEntity,
	#traits : 'TMbndObject + TMbndSymbolBinding',
	#classTraits : 'TMbndObject classTrait + TMbndSymbolBinding classTrait',
	#category : #'MoebiusBandMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndProgramEntity >> compilationTarget [
	^ self module compilationTarget
]

{ #category : #'macro expansion' }
TMbndProgramEntity >> lookupMacroSelector: aSelector [
	^ nil
]

{ #category : #'macro expansion' }
TMbndProgramEntity >> lookupSymbol: aSymbol [
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
