Class {
	#name : #MbndAbstractIntrinsicMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#instVars : [
		'intrinsicName'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAbstractIntrinsicMethod >> encodeFieldsForMessagePackWith: graphEncoder [
	^ (super encodeFieldsForMessagePackWith: graphEncoder) , {
		#intrinsicName . intrinsicName.
	}
]

{ #category : #accessing }
MbndAbstractIntrinsicMethod >> intrinsicName [
	^ intrinsicName
]

{ #category : #accessing }
MbndAbstractIntrinsicMethod >> intrinsicName: anObject [
	intrinsicName := anObject
]

{ #category : #testing }
MbndAbstractIntrinsicMethod >> isModuleSpecializedProgramEntity [
	^ true
]

{ #category : #serialization }
MbndAbstractIntrinsicMethod >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	intrinsicName := encodedFields at: #intrinsicName.
]
