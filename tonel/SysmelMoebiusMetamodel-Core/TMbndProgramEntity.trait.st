Trait {
	#name : #TMbndProgramEntity,
	#traits : 'TMbndAbstractProgramEntity + TMbndAbstractMacroMethodContainer + TMbndAbstractMethodContainer + TMbndAbstractSymbolContainer',
	#classTraits : 'TMbndAbstractProgramEntity classTrait + TMbndAbstractMacroMethodContainer classTrait + TMbndAbstractMethodContainer classTrait + TMbndAbstractSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'semantic analysis' }
TMbndProgramEntity >> enqueueDelayedSemanticAnalysis [
	self module enqueueProgramEntityWithDelayedSemanticAnalysis: self
]

{ #category : #'semantic analysis' }
TMbndProgramEntity >> ensureSemanticAnalysis [
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
