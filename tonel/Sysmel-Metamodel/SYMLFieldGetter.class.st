Class {
	#name : #SYMLFieldGetter,
	#superclass : #SYMLFieldAccessor,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLFieldGetter >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver |
	receiver := message receiver evaluateInEnvironment: anEnvironment.
	self halt
]

{ #category : #'macro compilation' }
SYMLFieldGetter >> generateMessage: messageNode ssaCodeWith: builder [
	| receiverValue |
	receiverValue := messageNode receiver generateSSACodeWith: builder.
	^ field ssaReferenceForReceiverValue: receiverValue builder: builder
]

{ #category : #'macro compilation' }
SYMLFieldGetter >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| receiver receiverType |
	receiver := message receiver semanticAnalysisInEnvironment: environment.
	receiverType := (receiver evaluateTypeInEnvironment: environment) cleanType.

	^ message copy
		receiver: receiver;
		metaMethod: self;
		coercionType: receiverType;
		valueType: (receiverType isPointerOrReferenceType ifTrue: [ field referenceType ] ifFalse: [field type]);
		yourself
]
