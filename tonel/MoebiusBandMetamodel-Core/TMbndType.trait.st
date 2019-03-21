"
I am a type that implements the following common functionality:
- Access to the definition module.
- Macro method dictionary.
- Macro method lookup.

"
Trait {
	#name : #TMbndType,
	#instVars : [
		'definitionModule',
		'compilationTarget',
		'macroMethodDict',
		'subtypes'
	],
	#traits : 'TMbndAbstractType',
	#classTraits : 'TMbndAbstractType classTrait',
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
TMbndType >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
TMbndType >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #accessing }
TMbndType >> definitionModule: aModule [
	definitionModule := aModule
]

{ #category : #accessing }
TMbndType >> macroMethodDict [
	^ macroMethodDict ifNil: [ macroMethodDict := Dictionary new ]
]

{ #category : #accessing }
TMbndType >> macroMethodDict: aDictionary [
	macroMethodDict := aDictionary
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeAdded: aSubtype [
	^ subtypes := (self subtypes copyWithout: aSubtype) copyWith: aSubtype
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeRemoved: aSubtype [
	^ subtypes := self subtypes copyWithout: aSubtype
]

{ #category : #accessing }
TMbndType >> subtypes [
	^ subtypes ifNil: [ subtypes := #() ]
]
