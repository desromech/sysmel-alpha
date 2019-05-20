Trait {
	#name : #TMbndAbstractProgramEntity,
	#traits : 'TMbndObject + TMbndSymbolBinding',
	#classTraits : 'TMbndObject classTrait + TMbndSymbolBinding classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #visiting }
TMbndAbstractProgramEntity >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #adding }
TMbndAbstractProgramEntity >> addChild: aChild [
	self error: 'Cannot have child program entities here.'
]

{ #category : #testing }
TMbndAbstractProgramEntity >> canHaveNamespaces [
	^ false
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> children [ 
	^ #()
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> compilationTarget [
	^ self module compilationTarget
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> fullName [
	^ self name
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompileTimeConstant [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMethod [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isNamespace [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isVariable [
	^ false
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> parent [
	^ nil
]
