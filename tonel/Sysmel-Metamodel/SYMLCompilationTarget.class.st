Class {
	#name : #SYMLCompilationTarget,
	#superclass : #Object,
	#classVars : [
		'CurrentImageCompilationTarget'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLCompilationTarget class >> forCurrentImage [
	^ CurrentImageCompilationTarget ifNil: [ CurrentImageCompilationTarget := SYMLSLVMCompilationTarget for: SLVMCompilationTarget forCurrentImage ]
]

{ #category : #construction }
SYMLCompilationTarget class >> x86 [
	^ SYMLSLVMCompilationTarget for: SLVMCompilationTarget x86
]

{ #category : #construction }
SYMLCompilationTarget class >> x86_64 [
	^ SYMLSLVMCompilationTarget for: SLVMCompilationTarget x86_64
]

{ #category : #accessing }
SYMLCompilationTarget >> astNodeType [
	self subclassResponsibility
]

{ #category : #'class initialization' }
SYMLCompilationTarget >> builtInTypes [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLCompilationTarget >> compilerObjectType [
	self subclassResponsibility
]

{ #category : #'primitive types' }
SYMLCompilationTarget >> literalArrayType [
	self subclassResponsibility
]

{ #category : #'primitive types' }
SYMLCompilationTarget >> literalCharacterType [
	self subclassResponsibility
]

{ #category : #'primitive types' }
SYMLCompilationTarget >> literalFloatType [
	self subclassResponsibility
]

{ #category : #'primitive types' }
SYMLCompilationTarget >> literalIntegerType [
	self subclassResponsibility
]
