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

{ #category : #'as yet unclassified' }
SYMLClass >> createMetaTypeFor: instanceType basingOf: oldMetaType [
	| newMetaType |
	newMetaType := SYMLMetaclassInstance new
			module: module;
			definitionEnvironment: definitionEnvironment;
			instanceType: instanceType;
			type: self;
			superclass: (self superclass ifNotNil: [:st | st type]);
			yourself.
	metaType initializeFromOldMetaType: oldMetaType.
	^ newMetaType
]

{ #category : #testing }
SYMLClass >> instanceType [
	self assert: self isMetaType.
	
]

{ #category : #testing }
SYMLClass >> isMetaType [
	^ self cachedNullary: #isMetaType fallbackWith: [ false ]
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
	self invalidateFlattenedTraits.
	newSuperclass ifNotNil: [ 
		metaClassClass ifNil: [
			self metaClassClass: newSuperclass metaClassClass
		].

		metaType ifNotNil: [
			metaType superclass: newSuperclass type
		].
	].


]

{ #category : #accessing }
SYMLClass >> supertype [
	^ superclass
]
