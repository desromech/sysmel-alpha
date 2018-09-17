Class {
	#name : #SYMLAbstractClass,
	#superclass : #SYMLStructure,
	#instVars : [
		'superclass',
		'class',
		'allFieldsCache'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #initialization }
SYMLAbstractClass >> addDefaultConversionRules [
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> allFields [
	^ allFieldsCache ifNil: [ allFieldsCache :=
		(superclass ifNil: [ #() ] ifNotNil: [ superclass allFields ]) , fields ]
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> buildConcreteStructureSSAType [
	superclass ifNotNil: [ superclass ensureConcreteStructureSSAType ].
	^ super buildConcreteStructureSSAType
]

{ #category : #initialization }
SYMLAbstractClass >> initialize [
	super initialize.
	self addDefaultConversionRules
]

{ #category : #testing }
SYMLAbstractClass >> instanceType [
	self assert: self isMetaType.
	
]

{ #category : #testing }
SYMLAbstractClass >> isMetaType [
	^ self cachedNullary: #isMetaType fallbackWith: [ false ]
]

{ #category : #testing }
SYMLAbstractClass >> isSameOrSuperclassOf: anotherClass [
	^ self == anotherClass or: [ self isSuperclassOf: anotherClass ]
]

{ #category : #testing }
SYMLAbstractClass >> isSubclassOf: anotherClass [
	superclass == anotherClass ifTrue: [ ^ true ].
	superclass ifNil: [ ^ false ].
	^ superclass isSubclassOf: anotherClass
]

{ #category : #testing }
SYMLAbstractClass >> isSuperclassOf: anotherClass [
	^ anotherClass isSubclassOf: self
]

{ #category : #testing }
SYMLAbstractClass >> isSysmelClass [
	^ true
]

{ #category : #'symbol lookup' }
SYMLAbstractClass >> lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock [
	<compileTime>
	super lookReceiver: receiver symbol: symbol ifPresent: [:binding | ^ ifPresentBlock value: binding].
	superclass ifNotNil: [ ^ superclass lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock ].
	^ nil
]

{ #category : #accessing }
SYMLAbstractClass >> mangledName [
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
SYMLAbstractClass >> printOn: aStream [
	aStream nextPutAll: 'class '; nextPutAll: self printingName
]

{ #category : #accessing }
SYMLAbstractClass >> superclass [
	<compileTime>
	^ superclass
]

{ #category : #accessing }
SYMLAbstractClass >> superclass: newSuperclass [
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
SYMLAbstractClass >> supertype [
	^ superclass
]
