Class {
	#name : #MbndAbstractIntrinsicMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#instVars : [
		'intrinsicName'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #accessing }
MbndAbstractIntrinsicMethod >> intrinsicName [
	^ intrinsicName
]

{ #category : #accessing }
MbndAbstractIntrinsicMethod >> intrinsicName: anObject [
	intrinsicName := anObject
]
