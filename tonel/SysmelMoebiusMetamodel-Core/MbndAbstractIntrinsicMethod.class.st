Class {
	#name : #MbndAbstractIntrinsicMethod,
	#superclass : #MbndAbstractSpecificMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #accessing }
MbndAbstractIntrinsicMethod >> intrinsicName [
	^ intrinsicName
]

{ #category : #testing }
MbndAbstractIntrinsicMethod >> isModuleSpecializedProgramEntity [
	^ true
]
