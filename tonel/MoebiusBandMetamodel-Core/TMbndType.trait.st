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
		'macroMethodDict'
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
TMbndType >> definitionModule [
	^ definitionModule
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
