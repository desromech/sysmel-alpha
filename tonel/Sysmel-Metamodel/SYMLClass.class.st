Class {
	#name : #SYMLClass,
	#superclass : #SYMLStructure,
	#instVars : [
		'superclass',
		'class',
		'allFieldsCache'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'semantic analysis' }
SYMLClass >> allFields [
	^ allFieldsCache ifNil: [ allFieldsCache :=
		(superclass ifNil: [ #() ] ifNotNil: [ superclass allFields ]) , fields ]
]

{ #category : #'semantic analysis' }
SYMLClass >> buildConcreteSSAType [
	superclass ifNotNil: [ superclass ensureConcreteSSAType ].
	^ super buildConcreteSSAType
]

{ #category : #testing }
SYMLClass >> isSameOrSuperclassOf: anotherClass [
	^ self == anotherClass or: [ self isSuperclassOf: anotherClass ]
]

{ #category : #testing }
SYMLClass >> isSubclassOf: anotherClass [
	superclass == anotherClass ifTrue: [ ^ true ].
	superclass ifNil: [ ^ false ].
	^ superclass isSubclassOf: anotherClass
]

{ #category : #testing }
SYMLClass >> isSuperclassOf: anotherClass [
	^ anotherClass isSubclassOf: self
]

{ #category : #testing }
SYMLClass >> isSysmelClass [
	^ true
]

{ #category : #testing }
SYMLClass >> isSysmelKindOf: anotherType [
	(super isSysmelKindOf: anotherType) ifTrue: [ ^ true ].
	^ self isSubclassOf: anotherType
]

{ #category : #printing }
SYMLClass >> printOn: aStream [
	aStream nextPutAll: 'class '; nextPutAll: self printingName
]

{ #category : #accessing }
SYMLClass >> superclass [
	<compileTime>
	^ superclass
]

{ #category : #accessing }
SYMLClass >> superclass: newSuperclass [
	<compileTime>
	newSuperclass isSysmelClass ifFalse: [ self error: 'Expected a class' ].
	(self isSameOrSuperclassOf: newSuperclass) ifTrue: [ self error: 'Creating circular hierarchy' ].
	superclass := newSuperclass.
	self invalidateFlattenedTraits
]

{ #category : #'as yet unclassified' }
SYMLClass >> typeKindBaseTrait [
	^ self compilationTarget classTypeTrait
]
