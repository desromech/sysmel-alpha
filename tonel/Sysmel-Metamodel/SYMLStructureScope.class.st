Class {
	#name : #SYMLStructureScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'structure',
		'symbols'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #accessing }
SYMLStructureScope >> fillWithMetaBuilders [
	| builder |
	SYMLStructureMetaBuilders allSubclassesDo: [ :sc |
		builder := sc new compilationTarget: self compilationTarget.
		symbols at: builder name put: builder
	]

]

{ #category : #accessing }
SYMLStructureScope >> findProgramEntityDefinitionScopeFrom: startingPoint [
	^ self
]

{ #category : #testing }
SYMLStructureScope >> hasSupportForOverloadedFunctions [
	^ true
]

{ #category : #initialization }
SYMLStructureScope >> initialize [
	super initialize.
	symbols := Dictionary new.
]

{ #category : #variables }
SYMLStructureScope >> lookSymbol: identifier ifPresent: aBlock [
	symbols at: identifier ifPresent: [ :symbol |
		^ aBlock value: symbol
	].

	^ structure lookSymbol: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLStructureScope >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	symbols at: identifier ifPresent: [ :symbol |
		^ ifPresentBlock value: symbol
	].

	^ structure lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #'as yet unclassified' }
SYMLStructureScope >> programEntity [
	^ structure
]

{ #category : #accessing }
SYMLStructureScope >> structure [
	^ structure
]

{ #category : #accessing }
SYMLStructureScope >> structure: anObject [
	structure := anObject.
	self fillWithMetaBuilders.
]
