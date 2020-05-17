Class {
	#name : #MbndAggregateCopyAssignmentMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateCopyAssignmentMethod class >> messagePackTypeName [
	^ #AggregateCopyAssignmentMethod
]

{ #category : #visiting }
MbndAggregateCopyAssignmentMethod >> accept: aVisitor [
	^ aVisitor visitAggregateCopyAssignmentMethod: self
]
