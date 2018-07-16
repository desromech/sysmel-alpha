Class {
	#name : #SYMLReceiverFieldVariable,
	#superclass : #SYMLAbstractVariable,
	#instVars : [
		'receiver',
		'field'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #'as yet unclassified' }
SYMLReceiverFieldVariable >> evaluateBoundIdentifierToMe: identifier inEnvironment: anEnvironment [
	| receiverValue |
	receiverValue := receiver evaluateBindingInEnvironment: anEnvironment.
	^ receiverValue type evaluateReceiver: receiverValue value field: field withType: identifier type at: identifier position
]

{ #category : #'meta evaluation' }
SYMLReceiverFieldVariable >> evaluateReceiverTypeInEnvironment: environment [
	^ receiver type
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> field [
	^ field
]

{ #category : #accessing }
SYMLReceiverFieldVariable >> field: anObject [
	field := anObject
]

{ #category : #'code generation' }
SYMLReceiverFieldVariable >> generateReceiverSSACodeWith: builder [
	^ receiver generateSSAReferenceWith: builder
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
