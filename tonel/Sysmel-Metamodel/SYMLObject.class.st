Class {
	#name : #SYMLObject,
	#superclass : #Object,
	#category : #Sysmel-Metamodel-Program
}

{ #category : #converting }
SYMLObject >> convertNodeForSequenceElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #converting }
SYMLObject >> convertNodeForTupleElement: aNode inEnvironment: anEnvironment [
	^ aNode
]

{ #category : #errors }
SYMLObject >> error: anErrorString at: aSourcePosition [
	^ SYMLSemanticError new
		messageText: anErrorString;
		sourcePosition: aSourcePosition;
		environment: self;
		signal
]

{ #category : #errors }
SYMLObject >> error: anErrorString format: formatArguments [
	^ self error: (anErrorString format: formatArguments)
]

{ #category : #errors }
SYMLObject >> error: anErrorString format: formatArguments at: aSourcePosition [
	^ self error: (anErrorString format: formatArguments) at: aSourcePosition
]
