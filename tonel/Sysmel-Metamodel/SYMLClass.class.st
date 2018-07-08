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

{ #category : #initialization }
SYMLClass >> addDefaultConversionRules [
]

{ #category : #'semantic analysis' }
SYMLClass >> allFields [
	^ allFieldsCache ifNil: [ allFieldsCache :=
		(superclass ifNil: [ #() ] ifNotNil: [ superclass allFields ]) , fields ]
]

{ #category : #'semantic analysis' }
SYMLClass >> buildConcreteStructureSSAType [
	superclass ifNotNil: [ superclass ensureConcreteStructureSSAType ].
	^ super buildConcreteStructureSSAType
]

{ #category : #initialization }
SYMLClass >> initialize [
	super initialize.
	self addDefaultConversionRules
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

{ #category : #accessing }
SYMLClass >> mangledName [
	| escapedName |
	^ ByteString streamContents: [ :out |
		escapedName := self validName sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $C;
			print: escapedName size;
			nextPutAll: escapedName.
	]
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
	superclass == newSuperclass ifTrue: [ ^ self ].
	newSuperclass isSysmelClass ifFalse: [ self error: 'Expected a class' ].
	(self isSameOrSuperclassOf: newSuperclass) ifTrue: [ self error: 'Creating circular hierarchy' ].
	superclass := newSuperclass.
	
	self isMetaType ifFalse: [ 
		self invalidateFlattenedTraits.
		newSuperclass ifNotNil: [ 
			metaClassClass ifNil: [
				self metaClassClass: newSuperclass metaClassClass
			].

			metaType ifNotNil: [
				metaType superclass: newSuperclass type
			].
		].
	].


]

{ #category : #accessing }
SYMLClass >> supertype [
	^ superclass
]

{ #category : #'as yet unclassified' }
SYMLClass >> typeKindBaseTrait [
	^ self compilationTarget classTypeTrait
]
