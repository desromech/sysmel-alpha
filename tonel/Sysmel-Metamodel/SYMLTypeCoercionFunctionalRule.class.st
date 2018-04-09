Class {
	#name : #SYMLTypeCoercionFunctionalRule,
	#superclass : #SYMLTypeCoercionRule,
	#instVars : [
		'action',
		'compilationTarget'
	],
	#category : #'Sysmel-Metamodel-Program'
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
SYMLTypeCoercionFunctionalRule >> doCoercionOf: left with: right [
	^ action valueWithReceiver: self arguments: { left . right }
]

{ #category : #converting }
SYMLTypeCoercionFunctionalRule >> reversed [
	^ super reversed
		action: [:l :r | action valueWithReceiver: self arguments: {r . l}] asSysmelCompileTimeFunction;
		yourself
]
