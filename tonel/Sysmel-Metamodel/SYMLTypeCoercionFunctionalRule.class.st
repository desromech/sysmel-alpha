Class {
	#name : #SYMLTypeCoercionFunctionalRule,
	#superclass : #SYMLTypeCoercionRule,
	#instVars : [
		'action',
		'compilationTarget'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #accessing }
SYMLTypeCoercionFunctionalRule >> action [
	^ action
]

{ #category : #accessing }
SYMLTypeCoercionFunctionalRule >> action: anObject [
	action := anObject
]

{ #category : #accessing }
SYMLTypeCoercionFunctionalRule >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLTypeCoercionFunctionalRule >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #'as yet unclassified' }
SYMLTypeCoercionFunctionalRule >> doCoercionOf: left node: leftNode with: right node: rightNode [
	action numArgs = 4 ifTrue: [ 
		^ action valueWithReceiver: self arguments: { left . leftNode . right . rightNode }
	].
	^ action valueWithReceiver: self arguments: { left . right }
]

{ #category : #converting }
SYMLTypeCoercionFunctionalRule >> reversed [
	action numArgs = 4 ifTrue: [ 
		^ super reversed
		action: [:l :ln :r :rn | action valueWithReceiver: self arguments: {r . rn . l . ln}] asSysmelCompileTimeFunction;
		yourself
	].

	^ super reversed
		action: [:l :r | action valueWithReceiver: self arguments: {r . l}] asSysmelCompileTimeFunction;
		yourself
]
