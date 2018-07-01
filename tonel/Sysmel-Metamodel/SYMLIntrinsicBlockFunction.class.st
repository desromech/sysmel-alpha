Class {
	#name : #SYMLIntrinsicBlockFunction,
	#superclass : #SYMLIntrinsicFunction,
	#instVars : [
		'block'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #accessing }
SYMLIntrinsicBlockFunction >> block [
	^ block
]

{ #category : #accessing }
SYMLIntrinsicBlockFunction >> block: anObject [
	block := anObject
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicBlockFunction >> generateSSACallWithArguments: argumentValues returnType: returnType  builder: builder at: position [
	^ block cull: argumentValues cull: returnType cull: builder cull: position
]
