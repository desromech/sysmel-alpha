Class {
	#name : #SYMLAbstractFunctionOrMacro,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'as yet unclassified' }
SYMLAbstractFunctionOrMacro >> createReceiverTypeForParent [

]

{ #category : #testing }
SYMLAbstractFunctionOrMacro >> isTemplateFunctionInstance [
	^ false
]

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> parent: aParent [
	super parent: aParent.
	aParent ifNotNil: [ self createReceiverTypeForParent ].
]

{ #category : #accessing }
SYMLAbstractFunctionOrMacro >> receiver [
	^ nil
]
