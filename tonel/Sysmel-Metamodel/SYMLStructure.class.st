Class {
	#name : #SYMLStructure,
	#superclass : #SYMLProgramEntity,
	#traits : 'TSYMLType',
	#classTraits : 'TSYMLType classTrait',
	#instVars : [
		'name',
		'module',
		'symbols'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #'meta methods' }
SYMLStructure >> assignValue: aDefinition [
	<compileTime>
	
	| scope |
	aDefinition type isAPSGNode ifFalse: [
		name ifNotNil: [ 
			self error: 'Expected an APSG/AST node for definition of structure {1}.' format: {name}
		] ifNil: [
			self error: 'Expected an APSG/AST node for definition of structure.'
		]
	].

	scope := (SYMLStructureScope parent: aDefinition environment)
		structure: self;
		yourself.
	aDefinition value analyzeAndEvaluateInEnvironment: scope.
	^ self asSysmelValueInEnvironment: aDefinition environment
]

{ #category : #'semantic analysis' }
SYMLStructure >> generateSSACode [
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	symbols := Dictionary new.
	
]

{ #category : #'symbol lookup' }
SYMLStructure >> lookSymbol: identifier [
	^ symbols at: identifier
]

{ #category : #variables }
SYMLStructure >> lookSymbol: identifier ifPresent: aBlock [
	^ symbols at: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLStructure >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #accessing }
SYMLStructure >> mangledName [
	^ self parentMangledName , name size asString , name

]

{ #category : #accessing }
SYMLStructure >> module [
	^ module
]

{ #category : #accessing }
SYMLStructure >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLStructure >> name [
	^ name
]

{ #category : #accessing }
SYMLStructure >> name: anObject [
	name := anObject
]

{ #category : #'semantic analysis' }
SYMLStructure >> semanticAnalysis [
	
]

{ #category : #accessing }
SYMLStructure >> target [
	^ module compilationTarget
]
