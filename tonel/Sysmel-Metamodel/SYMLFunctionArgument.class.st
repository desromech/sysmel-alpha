Class {
	#name : #SYMLFunctionArgument,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'type',
		'ssaValue',
		'node'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #'meta evaluation' }
SYMLFunctionArgument >> evaluateTypeAt: position [
	^ type
]

{ #category : #'meta evaluation' }
SYMLFunctionArgument >> generateSSAReferenceWith: builder [
	self assert: ssaValue isNotNil.
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionArgument >> name [
	^ name
]

{ #category : #accessing }
SYMLFunctionArgument >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLFunctionArgument >> node [
	^ node
]

{ #category : #accessing }
SYMLFunctionArgument >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SYMLFunctionArgument >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
SYMLFunctionArgument >> ssaValue: anObject [
	ssaValue := anObject
]

{ #category : #accessing }
SYMLFunctionArgument >> type [
	^ type
]

{ #category : #accessing }
SYMLFunctionArgument >> type: anObject [
	type := anObject
]
