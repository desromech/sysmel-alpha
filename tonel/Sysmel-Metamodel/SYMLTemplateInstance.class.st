Class {
	#name : #SYMLTemplateInstance,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'children',
		'arguments',
		'mangledName',
		'mangledArguments',
		'recursiveValue'
	],
	#classVars : [
		'SpecialMetaSymbols'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLTemplateInstance >> addedChild: aChild [
	children add: aChild.
	(recursiveValue isNotNil and: [recursiveValue isRecursiveValue]) ifTrue: [ 
		recursiveValue becomeForward: aChild.
		recursiveValue := nil
	]
]

{ #category : #accessing }
SYMLTemplateInstance >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLTemplateInstance >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLTemplateInstance >> children [
	^ children
]

{ #category : #'code generation' }
SYMLTemplateInstance >> generateSSACode [
	children do: #generateSSACode
]

{ #category : #initialization }
SYMLTemplateInstance >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #testing }
SYMLTemplateInstance >> isInstanceOfTemplate: template [
	^ parent == template
]

{ #category : #testing }
SYMLTemplateInstance >> isTemplateInstance [
	^ true
]

{ #category : #accessing }
SYMLTemplateInstance >> mangledArguments [
	^ mangledArguments ifNil: [ mangledArguments := ByteString streamContents: [:out |
			arguments do: [ :arg |
				out nextPutAll: arg sysmelMangledValue
			]
		]
	]
]

{ #category : #accessing }
SYMLTemplateInstance >> mangledName [
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			nextPut: $I;
			print: self mangledArguments size;
			nextPutAll: self mangledArguments.
		]
	]
]

{ #category : #accessing }
SYMLTemplateInstance >> recursiveValue [
	^ recursiveValue
]

{ #category : #accessing }
SYMLTemplateInstance >> recursiveValue: anObject [
	recursiveValue := anObject
]

{ #category : #'code generation' }
SYMLTemplateInstance >> semanticAnalysis [
	children do: #semanticAnalysis
]
