Class {
	#name : #SYMLReceiverFieldVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'receiver',
		'field'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #accessing }
SYMLReceiverFieldVariable >> field [
	^ field
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> field: anObject [
	field := anObject
]

{ #category : #'code generation' }
SYMLReceiverFieldVariable >> generateSSAReferenceWith: builder [
	| receiverValue |
	receiverValue := receiver generateSSAReferenceWith: builder.
	^ field ssaReferenceForReceiverValue: receiverValue builder: builder
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> receiver: anObject [
	receiver := anObject
]

{ #category : #'as yet unclassified' }
SYMLReceiverFieldVariable >> referenceType [
	<compileTime>
	^ field referenceType
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> type [
	<compileTime>
	^ field type
]
