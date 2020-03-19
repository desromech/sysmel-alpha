Class {
	#name : #MbndDerivedType,
	#superclass : #MbndNativeType,
	#instVars : [
		'baseType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDerivedType class >> typeName [
	^ #_DerivedType
]

{ #category : #accessing }
MbndDerivedType >> baseType [
	<compileTime>
	^ baseType
]

{ #category : #accessing }
MbndDerivedType >> baseType: anObject [
	baseType := anObject
]

{ #category : #serialization }
MbndDerivedType >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ (super encodeLazyFieldsForMessagePackWith: graphEncoder) , {
		#baseType . baseType encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #initialization }
MbndDerivedType >> initialize [
	super initialize.
]

{ #category : #'testing methods' }
MbndDerivedType >> isDerivedType [
	^ true
]

{ #category : #serialization }
MbndDerivedType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.
	
	baseType := encodedFields at: #baseType.
]
