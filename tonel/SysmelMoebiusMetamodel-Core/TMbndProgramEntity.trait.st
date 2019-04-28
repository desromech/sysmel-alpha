Trait {
	#name : #TMbndProgramEntity,
	#traits : 'TMbndObject + TMbndSymbolBinding + TMbndAbstractMacroMethodContainer + TMbndAbstractMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndObject classTrait + TMbndSymbolBinding classTrait + TMbndAbstractMacroMethodContainer classTrait + TMbndAbstractMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #adding }
TMbndProgramEntity >> addChild: aChild [
	self error: 'Cannot have child program entities here.'
]

{ #category : #testing }
TMbndProgramEntity >> canHaveNamespaces [
	^ false
]

{ #category : #accessing }
TMbndProgramEntity >> children [ 
	^ #()
]

{ #category : #accessing }
TMbndProgramEntity >> compilationTarget [
	^ self module compilationTarget
]

{ #category : #'semantic analysis' }
TMbndProgramEntity >> enqueueDelayedSemanticAnalysis [
	self module enqueueProgramEntityWithDelayedSemanticAnalysis: self
]

{ #category : #'semantic analysis' }
TMbndProgramEntity >> ensureSemanticAnalysis [
]

{ #category : #accessing }
TMbndProgramEntity >> fullName [
	^ self name
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
