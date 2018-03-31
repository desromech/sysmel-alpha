Class {
	#name : #SYMLProgramEntity,
	#superclass : #SYMLObject,
	#instVars : [
		'flags',
		'parent'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #'adding notifications' }
SYMLProgramEntity >> addedFunction: aFunction [
	aFunction parent: self
]

{ #category : #'adding notifications' }
SYMLProgramEntity >> addedFunctionGroup: aFunctionGroup [
]

{ #category : #converting }
SYMLProgramEntity >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: self type inEnvironment: anEnvironment
]

{ #category : #'object building' }
SYMLProgramEntity >> createFieldVariableBinding: fieldVariableBuilder [
	self error: 'Cannot define field {1} at this place.' format: { fieldVariableBuilder name }
]

{ #category : #'object building' }
SYMLProgramEntity >> createLocalVariableBinding: localVariableBuilder [
	self error: 'Cannot define local variable {1} at this place.' format: { localVariableBuilder name }
]

{ #category : #'meta evaluation' }
SYMLProgramEntity >> evaluateReferenceAt: position [
	self error: 'Cannot evaluate reference to ' , self class name
]

{ #category : #'meta evaluation' }
SYMLProgramEntity >> evaluateTypeAt: position [
	self error: 'Cannot evaluate type for ' , self class name
]

{ #category : #accessing }
SYMLProgramEntity >> flags [
	^ flags
]

{ #category : #accessing }
SYMLProgramEntity >> flags: anObject [
	flags := anObject
]

{ #category : #'semantic analysis' }
SYMLProgramEntity >> generateSSACode [
]

{ #category : #'meta evaluation' }
SYMLProgramEntity >> generateSSAReferenceWith: builder [
	self error: 'Cannot generate program entity ssa reference.'
]

{ #category : #testing }
SYMLProgramEntity >> hasFlag: aFlag [
	^ flags includes: aFlag
]

{ #category : #initialization }
SYMLProgramEntity >> initialize [
	super initialize.
	flags := #().
]

{ #category : #testing }
SYMLProgramEntity >> isFunction [
	^ false
]

{ #category : #testing }
SYMLProgramEntity >> isFunctionGroup [
	^ false
]

{ #category : #testing }
SYMLProgramEntity >> isMethod [
	^ false
]

{ #category : #testing }
SYMLProgramEntity >> isNamespace [
	^ false
]

{ #category : #testing }
SYMLProgramEntity >> isStructure [
	^ false
]

{ #category : #'semantic analysis' }
SYMLProgramEntity >> mangledName [
	self subclassResponsibility

]

{ #category : #accessing }
SYMLProgramEntity >> parent [
	^ parent
]

{ #category : #accessing }
SYMLProgramEntity >> parent: anObject [
	parent := anObject
]

{ #category : #'name mangling' }
SYMLProgramEntity >> parentMangledName [
	^ parent ifNil: [ '_S' ] ifNotNil: [ parent mangledName ]
]

{ #category : #'semantic analysis' }
SYMLProgramEntity >> semanticAnalysis [
]

{ #category : #testing }
SYMLProgramEntity >> setFlag: aFlag [
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]
