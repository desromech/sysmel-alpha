Class {
	#name : #MbndCompilerGeneratedMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'module'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

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
