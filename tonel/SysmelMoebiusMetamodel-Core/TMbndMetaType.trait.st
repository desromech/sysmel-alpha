Trait {
	#name : #TMbndMetaType,
	#instVars : [
		'constructorGroup',
		'instanceType',
		'potentialConstructorMethods'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #adding }
TMbndMetaType >> addCustomConstructorMethod: method [
	constructorGroup ifNil: [
		constructorGroup := MbndConstructorGroup new
			module: method module;
			yourself.
		self addChild: constructorGroup.
	].

	constructorGroup addOverloadedEntity: method
]

{ #category : #initialization }
TMbndMetaType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self addConversionTo: self compilationTarget astNodeType rule: MbndWrapInLiteralValueNodeTypeConversionRule
]

{ #category : #adding }
TMbndMetaType >> checkPotentialConstructors [
	potentialConstructorMethods ifNil: [ ^ self ].
	[ potentialConstructorMethods isNotEmpty ] whileTrue: [
		| toCheck |
		toCheck := potentialConstructorMethods asArray.
		potentialConstructorMethods removeAll.
		toCheck do: [:each | 
			each isCustomConstructor ifTrue: [
				self addCustomConstructorMethod: each
			]
		]
	]
]

{ #category : #accessing }
TMbndMetaType >> constructorGroup [
	"We need to ensure that all of the constructors are in the group."
	self
		evaluateAllPendingDefinitionFragments;
		checkPotentialConstructors.

	^ constructorGroup
]

{ #category : #sizes }
TMbndMetaType >> instanceAlignment [
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
TMbndMetaType >> instanceSize [
	^ self compilationTarget pointerSize
]

{ #category : #accessing }
TMbndMetaType >> instanceType [
	<compileTime>
	^ instanceType
]

{ #category : #'as yet unclassified' }
TMbndMetaType >> instanceTypeForExceptionCatch [
	^ instanceType ifNil: [ self ]
]

{ #category : #'testing methods' }
TMbndMetaType >> isMetaType [
	^ true
]

{ #category : #testing }
TMbndMetaType >> isStrictMetaType [
	^ instanceType isNotNil
]

{ #category : #'as yet unclassified' }
TMbndMetaType >> lookupPoolDictionarySymbol: aSymbol [
	(super lookupPoolDictionarySymbol: aSymbol) ifNotNil: [ :found | ^ found ].
	^ instanceType ifNotNil: [ instanceType lookupPoolDictionarySymbol: aSymbol ]
]

{ #category : #printing }
TMbndMetaType >> qualifiedNameForParent [
	self isStrictMetaType ifTrue: [ 
		^ instanceType qualifiedNameForParent , ' type'
	].

	^ super qualifiedNameForParent
]

{ #category : #adding }
TMbndMetaType >> recordPotentialConstructorMethod: potentialConstructor [
	(potentialConstructorMethods ifNil: [ potentialConstructorMethods := OrderedCollection new ]) add: potentialConstructor
]
