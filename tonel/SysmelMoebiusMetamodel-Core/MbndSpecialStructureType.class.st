Class {
	#name : #MbndSpecialStructureType,
	#superclass : #MbndStructureType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSpecialStructureType class >> typeName [
	^ #_SpecialStructureType
]

{ #category : #visiting }
MbndSpecialStructureType >> accept: aVisitor [
	^ aVisitor visitSpecialStructureType: self
]

{ #category : #initialization }
MbndSpecialStructureType >> addFields [
	self subclassResponsibility
]

{ #category : #converting }
MbndSpecialStructureType >> asImmutableValueType [
	self isPOD ifTrue: [ ^ self ].
	^ super asImmutableValueType
]

{ #category : #initialization }
MbndSpecialStructureType >> initializeNonTraitType [
	super initializeNonTraitType.
	self isTrait ifFalse: [ 
		self addFields.
		self markAsDefined.
		(self compilationEnvironment currentModule ifNil: [ self assert: self isArraySliceType. definitionModule ]) 			enqueueProgramEntityWithDelayedSemanticAnalysis: self
	].

]

{ #category : #testing }
MbndSpecialStructureType >> isModuleSpecificType [
	^ false
]

{ #category : #testing }
MbndSpecialStructureType >> isNonTrivial [
	^ self isTrivial not
]

{ #category : #testing }
MbndSpecialStructureType >> isSpecialStructureType [
	^ true
]

{ #category : #testing }
MbndSpecialStructureType >> isTrivial [
	^ self hasTrivialInitialization and:
	[ self hasTrivialFinalization and:
	[ self hasTrivialInitializationCopyingFrom and:
	[ self hasTrivialInstanceFinalization and:
	[ self hasTrivialBasicInitialization ]]]]
]

{ #category : #'as yet unclassified' }
MbndSpecialStructureType >> unmangledSpecialStructureName [
	^ 'special.' , self asString
]
