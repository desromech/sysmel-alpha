Class {
	#name : #SYMLDeferredTypeConversionRule,
	#superclass : #SYMLTypeConversionRule,
	#traits : 'TSYMLInterpretedCompilationObject',
	#classTraits : 'TSYMLInterpretedCompilationObject classTrait',
	#instVars : [
		'evaluation',
		'codeGeneration'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> codeGeneration [
	^ codeGeneration
]

{ #category : #accessing }
SYMLDeferredTypeConversionRule >> codeGeneration: anObject [
	codeGeneration := anObject
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
