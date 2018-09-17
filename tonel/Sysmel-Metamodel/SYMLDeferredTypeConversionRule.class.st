Class {
	#name : #SYMLDeferredTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#traits : 'TSYMLInterpretedCompilationObject',
	#classTraits : 'TSYMLInterpretedCompilationObject classTrait',
	#instVars : [
		'evaluation',
		'codeGeneration',
		'coercionCost'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> codeGeneration [
	^ codeGeneration
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> codeGeneration: anObject [
	codeGeneration := anObject
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> coercionCost [
	^ coercionCost ifNil: [ coercionCost := 1 ] 
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> coercionCost: aCoercionCost [
	coercionCost := aCoercionCost
]

{ #category : #'as yet unclassified' }
SYMLDeferredTypeConversionRule >> convertSSAValue: rawValue to: targetType with: builder at: messageNode [
	^ codeGeneration cull: rawValue cull: targetType cull: builder cull: messageNode
]

{ #category : #'as yet unclassified' }
SYMLDeferredTypeConversionRule >> convertValue: value into: targetType at: coercionPosition [
	^ evaluation cull: value cull: targetType cull: coercionPosition
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> evaluation [
	^ evaluation
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> evaluation: anObject [
	evaluation := anObject
]
