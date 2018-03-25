"
A SYMLModuleTest is a test class for testing the behavior of SYMLModule
"
Class {
	#name : #SYMLModuleTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'target'
	],
	#category : #Sysmel-Tests
}

{ #category : #initialization }
SYMLModuleTest >> setUp [
	module := SYMLModule for: SYMLCompilationTarget x86_64.
	target := module compilationTarget.
	
]

{ #category : #tests }
SYMLModuleTest >> testDefineFunction [
	| function |
	function := module evaluateSource: 'function main () -> Void := {}'.
	
	self assert: function type isReferenceType.
	self assert: function type referenced isFunctionType.
	self assert: function value definition isSYMLAPSGNode.
]

{ #category : #tests }
SYMLModuleTest >> testLiteralInteger [
	| value |
	value := module evaluateSource: '1'.
	self assert: value value equals: 1.
	self assert: value type equals: target literalIntegerType.

]

{ #category : #tests }
SYMLModuleTest >> testNewExternCFunction [
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main externC () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunction.
	self assert: group equals: functionBuilder value function.
]

{ #category : #tests }
SYMLModuleTest >> testNewFunction [
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunctionGroup.
	self assert: group functions first equals: functionBuilder value function.
]

{ #category : #tests }
SYMLModuleTest >> testRedeclareExternCFunction [
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main externC () -> Void'.
	redeclaration := module evaluateSource: 'function main externC () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.
]

{ #category : #tests }
SYMLModuleTest >> testRedeclareFunction [
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main () -> Void'.
	redeclaration := module evaluateSource: 'function main () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.
]

{ #category : #tests }
SYMLModuleTest >> testTypeReference [
	| value |
	value := module evaluateSource: 'Void'.
	self assert: value type isMetaType.
	self assert: value value equals: target voidType.
]
