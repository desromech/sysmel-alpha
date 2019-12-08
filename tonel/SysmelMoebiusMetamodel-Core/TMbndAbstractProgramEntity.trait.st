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

{ #category : #adding }
TMbndAbstractProgramEntity >> addPrivateChild: aChild [
	aChild parent: self
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
TMbndAbstractProgramEntity >> hasPublicVisibility [
	^ true
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompileTimeConstant [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isCompileTimeVariable [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isMbndProgramEntity [
	^ true
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
TMbndAbstractProgramEntity >> isTemplate [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isTemplateInstance [
	^ false
]

{ #category : #testing }
TMbndAbstractProgramEntity >> isVariable [
	^ false
]

{ #category : #'as yet unclassified' }
TMbndAbstractProgramEntity >> markCompileTimeEvaluationImpossibility [
]

{ #category : #accessing }
TMbndAbstractProgramEntity >> parent [
	^ nil
]

{ #category : #'meta builder factories' }
TMbndAbstractProgramEntity >> publicMetaBuilderFactories [
	^ Dictionary new
]
