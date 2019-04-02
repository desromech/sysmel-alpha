Class {
	#name : #MbndAbstractScope,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'parent'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
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

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupMacroSelector: selector [
	^ parent ifNotNil: [ parent lookupMacroSelector: selector ]
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupSymbol: aSymbol [
	^ nil
]

{ #category : #'macro expansion' }
MbndAbstractScope >> lookupSymbolRecursively: aSymbol ifAbsent: aBlock [
	(self lookupSymbol: aSymbol) ifNotNil: [ :result | ^ result ].
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
MbndAbstractScope >> newReturnContextScope [
	^ MbndReturnContextScope parent: self
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
