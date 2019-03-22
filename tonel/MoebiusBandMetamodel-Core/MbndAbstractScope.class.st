Class {
	#name : #MbndAbstractScope,
	#superclass : #Object,
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

{ #category : #'instance creation' }
MbndAbstractScope >> newLexicalScope [
	^ MbndLexicalScope parent: self
]

{ #category : #accessing }
MbndAbstractScope >> parent [
	^ parent
]

{ #category : #accessing }
MbndAbstractScope >> parent: anObject [
	parent := anObject
]
