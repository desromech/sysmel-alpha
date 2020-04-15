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

{ #category : #initialization }
MbndSerializationGraphEncoder >> encodeExternalProgramEntityReferenceFor: programEntity [
	| encodedParent |
	self assert: programEntity module isNotNil.
	programEntity module == targetModule ifTrue: [ ^ nil ].
	encodedObjects at: programEntity ifPresent: [ :existent | ^ existent ].
	
	(programEntity isMbndType and: [programEntity isStrictMetaType]) ifTrue: [ 
		| instanceType |
		self assert: programEntity instanceType isNotNil.
		instanceType := programEntity instanceType encodeGraphForMessagePackWith: self.
		^ self encodeObject: programEntity type: #ReferenceMetaType earlyFields: instanceType fields: []
	].
	
	programEntity parent ifNil: [
		self assert: programEntity isNamespace.
		^ self encodeObject: programEntity type: #ReferenceGlobalNamespace
			earlyFields: (programEntity module encodeGraphForMessagePackWith: self)
			fields: []
	].

	encodedParent := programEntity parent encodeGraphForMessagePackWith: self.
	encodedObjects at: programEntity ifPresent: [ :existent | ^ existent ].

	programEntity isTemplateInstance ifTrue: [
		
		^ self encodeObject: programEntity type: #ReferenceTemplateInstance earlyFields: {
			encodedParent .
				programEntity instanceArguments collect: [ :each |
					each evaluatedValue unwrapMbndValue encodeGraphForMessagePackWith: self
				]} fields: []
	].

	(programEntity parent isTemplateInstance and: [programEntity parent mainChild == programEntity ]) ifTrue: [
		^ self encodeObject: programEntity type: #ReferenceMainChild earlyFields: encodedParent fields: []
	].

	self assert: programEntity hasAnonymousName not.
	^ self encodeObject: programEntity type: #ReferenceNamedChild earlyFields: {encodedParent . programEntity class messagePackTypeName . programEntity name encodeGraphForMessagePackWith: self } fields: []

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
	programEntity isNeverExported ifTrue: [ ^ false ].
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
