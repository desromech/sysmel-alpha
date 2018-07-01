Class {
	#name : #SYMLIntrinsicBuiltInFunction,
	#superclass : #SYMLIntrinsicFunction,
	#instVars : [
		'builtInName'
	],
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #accessing }
SYMLIntrinsicBuiltInFunction >> builtInName [
	^ builtInName
]

{ #category : #accessing }
SYMLIntrinsicBuiltInFunction >> builtInName: anObject [
	builtInName := anObject
]

{ #category : #'as yet unclassified' }
SYMLIntrinsicBuiltInFunction >> generateSSACallWithArguments: argumentValues returnType: returnType  builder: builder at: position [
	| argumentTypes returnSSAType builtInFunction |
	argumentTypes := argumentValues collect: #type.
	returnSSAType := returnType ssaType.
	builtInFunction := builder builtInFunctionName: builtInName argumentTypes: argumentTypes returnType: returnSSAType.
	^ builder call: builtInFunction arguments: argumentValues
]
