Class {
	#name : #MbndAggregateMoveAssignmentMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateMoveAssignmentMethod class >> messagePackTypeName [
	^ #AggregateMoveAssignmentMethod
]

{ #category : #visiting }
MbndAggregateMoveAssignmentMethod >> accept: aVisitor [
	^ aVisitor visitAggregateMoveAssignmentMethod: self
]
