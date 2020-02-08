Class {
	#name : #MbndDynamicMethodWrapper,
	#superclass : #MbndCompilerGeneratedMethod,
	#instVars : [
		'wrappedMethod'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndDynamicMethodWrapper >> accept: aVisitor [
	^ aVisitor visitDynamicMethodWrapper: self
]

{ #category : #accessing }
MbndDynamicMethodWrapper >> wrappedMethod [
	^ wrappedMethod
]

{ #category : #accessing }
MbndDynamicMethodWrapper >> wrappedMethod: anObject [
	wrappedMethod := anObject
]
