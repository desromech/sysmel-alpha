Class {
	#name : #MbndAbstractScope,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'parent'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndAbstractScope class >> empty [
	^ self new
]

{ #category : #accessing }
MbndAbstractScope class >> parent: aParent [
	^ self new parent: aParent
]

{ #category : #accessing }
MbndAbstractScope >> compilationTarget [
	^ parent compilationTarget
]

{ #category : #accessing }
MbndAbstractScope >> defaultArgumentType [
	^ parent ifNotNil: [ parent defaultArgumentType ]
]

{ #category : #accessing }
MbndAbstractScope >> defaultReturnType [
	^ parent ifNotNil: [ parent defaultReturnType ]
]

{ #category : #accessing }
MbndAbstractScope >> definitionPosition [
	^ nil
]

{ #category : #testing }
MbndAbstractScope >> isCompilationEvaluationScope [
	parent ifNotNil: [ ^ parent isCompilationEvaluationScope ].
	^ true
]

{ #category : #testing }
MbndAbstractScope >> isInFunctionScope [
	parent ifNotNil: [ ^ parent isInFunctionScope ].
	^ false
]

{ #category : #testing }
MbndAbstractScope >> isLexicalScope [
	^ false
]

{ #category : #testing }
MbndAbstractScope >> isProgramEntityScope [
	^ false
]

{ #category : #storage }
MbndAbstractScope >> lookBindingStorageRecursively: binding [
	^ parent ifNotNil: [ parent lookBindingStorageRecursively: binding ]
]

{ #category : #'as yet unclassified' }
MbndAbstractScope >> lookupFunctionProgramEntity [
	^ parent ifNotNil: [ parent lookupFunctionProgramEntity ]
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupMacroSelector: selector [
	^ parent ifNotNil: [ parent lookupMacroSelector: selector ]
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupOverloadedSelector: selector [
	^ parent ifNotNil: [ parent lookupOverloadedSelector: selector ]
]

{ #category : #'as yet unclassified' }
MbndAbstractScope >> lookupProgramEntityForNewDefinitions [
	^ parent ifNotNil: [ parent lookupProgramEntityForNewDefinitions ]
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupSymbol: aSymbol [
	^ nil
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupSymbolOnUsedSymbols: symbol [
	^ nil
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupSymbolRecursively: aSymbol ifAbsent: aBlock [
	(self lookupSymbol: aSymbol) ifNotNil: [ :result | ^ result ].
	(self lookupSymbolOnUsedSymbols: aSymbol) ifNotNil: [ :usedSymbol | ^ usedSymbol ].
	parent ifNil: [
		^ aBlock value
	] ifNotNil: [
		^ parent lookupSymbolRecursively: aSymbol ifAbsent: aBlock
	]
]

{ #category : #'instance creation' }
MbndAbstractScope >> newLexicalScope [
	^ MbndLexicalScope parent: self
]

{ #category : #'instance creation' }
MbndAbstractScope >> newLexicalScopeAt: definitionPosition [
	^ (MbndLexicalScope parent: self)
		definitionPosition: definitionPosition;
		yourself
]

{ #category : #'instance creation' }
MbndAbstractScope >> newReturnContextScope [
	^ MbndReturnContextScope parent: self
]

{ #category : #accessing }
MbndAbstractScope >> nonLocalReturnType [
	^ parent ifNotNil: #nonLocalReturnType
]

{ #category : #accessing }
MbndAbstractScope >> nonLocalReturnTypeProgramEntity [
	^ parent ifNotNil: #nonLocalReturnTypeProgramEntity
]

{ #category : #accessing }
MbndAbstractScope >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractScope >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
MbndAbstractScope >> returnContextScope [
	^ parent ifNotNil: #returnContextScope
]

{ #category : #accessing }
MbndAbstractScope >> returnType [
	^ parent ifNotNil: #returnType
]

{ #category : #accessing }
MbndAbstractScope >> returnTypeProgramEntity [
	^ parent ifNotNil: #returnTypeProgramEntity
]

{ #category : #'as yet unclassified' }
MbndAbstractScope >> workingDirectory [
	^ parent
		ifNil: [ FileSystem workingDirectory ]
		ifNotNil: [ parent workingDirectory ]
]
