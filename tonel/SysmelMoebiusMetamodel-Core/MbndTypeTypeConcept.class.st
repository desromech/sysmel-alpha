Class {
	#name : #MbndTypeTypeConcept,
	#superclass : #MbndTypeConcept,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTypeTypeConcept class >> typeName [
	^ #Type
]

{ #category : #'as yet unclassified' }
MbndTypeTypeConcept >> doesTypeComplyWithConcept: aType [
	^ aType isMetaType or: [ aType isMetaTypeType ]
]
