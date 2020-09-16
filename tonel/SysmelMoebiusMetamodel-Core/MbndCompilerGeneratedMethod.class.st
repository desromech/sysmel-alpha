Class {
	#name : #MbndCompilerGeneratedMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #testing }
MbndCompilerGeneratedMethod >> classBindingLiteral [
	self flag: 'TODO: Support nested method'.
	^ parent globalBindingAssociation
]

{ #category : #serialization }
MbndCompilerGeneratedMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#module . module encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> hasProgramEntityReflectiveNode [
	^ true
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> isCompilerGeneratedMethod [
	^ true
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> isDefinition [
	^ true
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> isMessageMethod [
	^ true
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> isTrivialMethod [
	^ true
]

{ #category : #serialization }
MbndCompilerGeneratedMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	module := encodedFields at: #module.
]

{ #category : #accessing }
MbndCompilerGeneratedMethod >> module [
	^ module
]

{ #category : #accessing }
MbndCompilerGeneratedMethod >> module: anObject [
	module := anObject
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> requiresCompiledMethodMetadata [
	self module hasGarbageCollectionSupport ifFalse: [ ^ false ].
	(parent isMbndType and: [parent isGarbageCollectedType]) ifTrue: [ ^ true ].
	(parent isAbstractSpecificMethod and: [parent requiresCompiledMethodMetadata]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
MbndCompilerGeneratedMethod >> selectorRequiredLiteral [
	self flag: 'Create the MethodAdditionalState for the pragmas'.
	^ self typedSelector
]
