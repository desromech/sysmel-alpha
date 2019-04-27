Trait {
	#name : #TMbndProgramEntity,
	#traits : 'TMbndObject + TMbndSymbolBinding + TMbndAbstractMacroMethodContainer + TMbndAbstractMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndObject classTrait + TMbndSymbolBinding classTrait + TMbndAbstractMacroMethodContainer classTrait + TMbndAbstractMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
TMbndProgramEntity >> compilationTarget [
	^ self module compilationTarget
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
