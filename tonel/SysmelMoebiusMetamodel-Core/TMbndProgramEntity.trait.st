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

{ #category : #testing }
TMbndProgramEntity >> isCompileTimeConstant [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isMethod [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isNamespace [
	^ false
]

{ #category : #testing }
TMbndProgramEntity >> isVariable [
	^ false
]

{ #category : #accessing }
TMbndProgramEntity >> module [
	self explicitRequirement
]

{ #category : #accessing }
TMbndProgramEntity >> name [
	^ self explicitRequirement
]

{ #category : #accessing }
TMbndProgramEntity >> parent [
	^ nil
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScope [
	^ self programEntityScopeClass new programEntity: self
]

{ #category : #scope }
TMbndProgramEntity >> programEntityScopeClass [
	^ MbndProgramEntityScope
]
