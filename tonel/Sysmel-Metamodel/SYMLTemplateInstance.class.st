Class {
	#name : #SYMLTemplateInstance,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'children',
		'arguments',
		'mangledName',
		'mangledArguments'
	],
	#classVars : [
		'SpecialMetaSymbols'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLTemplateInstance >> addedChild: aChild [
	children add: aChild
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

{ #category : #'code generation' }
SYMLTemplateInstance >> semanticAnalysis [
	children do: #semanticAnalysis
]
