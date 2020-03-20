Class {
	#name : #MbndSerializationGraphEncoder,
	#superclass : #SLVMSerializationGraphEncoder,
	#instVars : [
		'targetModule',
		'typeLazyFields'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Serialization'
}

{ #category : #'as yet unclassified' }
MbndSerializationGraphEncoder >> encodeCompleteSymbolTable: symbolTable [
	symbolTable ifNil: [ ^ #() ].
	
	self assert: symbolTable isDictionary.
	^ Array streamContents: [ :out |
		symbolTable keysAndValuesDo: [ :key :value |
			out nextPut: (key encodeGraphForMessagePackWith: self); nextPut: (value encodeGraphForMessagePackWith: self)
		]
	]
]

{ #category : #'as yet unclassified' }
MbndSerializationGraphEncoder >> encodeProgramEntityList: entityList [
	entityList ifNil: [ ^ #() ].
	
	^ Array streamContents: [ :out |
		entityList do: [ :each |
			(self isProgramEntityExported: each) ifTrue: [
				out nextPut: (each encodeGraphForMessagePackWith: self)
			]
		]
	]
]

{ #category : #'as yet unclassified' }
MbndSerializationGraphEncoder >> encodeSymbolTable: symbolTable [
	symbolTable ifNil: [ ^ #() ].
	
	self assert: symbolTable isDictionary.
	^ Array streamContents: [ :out |
		symbolTable keysAndValuesDo: [ :key :value |
			(self isProgramEntityExported: value) ifTrue: [
				out nextPut: key; nextPut: (value encodeGraphForMessagePackWith: self)
			]
		]
	]
]

{ #category : #initialization }
MbndSerializationGraphEncoder >> initialize [
	super initialize.
	typeLazyFields := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
MbndSerializationGraphEncoder >> isProgramEntityExported: programEntity [
	^ self isExportMode not or: [programEntity hasPublicOrExternalVisibility or: [programEntity isAlwaysExported]]
]

{ #category : #'as yet unclassified' }
MbndSerializationGraphEncoder >> recordType: type lazyFields: lazyFields [
	typeLazyFields add: { type encodeGraphForMessagePackWith: self . lazyFields }
]

{ #category : #accessing }
MbndSerializationGraphEncoder >> targetModule [
	^ targetModule
]

{ #category : #accessing }
MbndSerializationGraphEncoder >> targetModule: anObject [
	targetModule := anObject
]

{ #category : #accessing }
MbndSerializationGraphEncoder >> typeLazyFields [
	^ typeLazyFields
]
