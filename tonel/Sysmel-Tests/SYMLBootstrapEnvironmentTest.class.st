"
A SYMLModuleTest is a test class for testing the behavior of SYMLModule
"
Class {
	#name : #SYMLBootstrapEnvironmentTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'target'
	],
	#category : #'Sysmel-Tests'
}

{ #category : #initialization }
SYMLBootstrapEnvironmentTest >> setUp [
	module := SYMLModule for: SYMLCompilationTarget x86_64.
	target := module compilationTarget.
	module evaluateFileNamedOnce: 'lib/kernel/bootstrap/bootstrap.sysmel'
]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testDefineFunction [
	| function |
	function := module evaluateSource: 'function main () -> Void := {}'.
	
	self assert: function type isCompilerObjectType
]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralCharacter [
	| value |
	value := module evaluateSource: '''H'''.
	self assert: value value equals: $H asInteger.
	self assert: value type equals: target literalCharacterType.

]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralFloat [
	| value |
	value := module evaluateSource: '1.0'.
	self assert: value value equals: 1.0.
	self assert: value type equals: target literalFloatType.

]

{ #category : #'literal arithmetic' }
SYMLBootstrapEnvironmentTest >> testLiteralFloatAddition [
	| value |
	value := module evaluateSource: '1.0+2.0'.
	self assert: value value equals: 3.0.
	self assert: value type equals: target literalFloatType.

]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralHexInteger [
	| value |
	value := module evaluateSource: '16r20'.
	self assert: value value equals: 32.
	self assert: value type equals: target literalIntegerType.

]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralInteger [
	| value |
	value := module evaluateSource: '1'.
	self assert: value value equals: 1.
	self assert: value type equals: target literalIntegerType.

]

{ #category : #'literal arithmetic' }
SYMLBootstrapEnvironmentTest >> testLiteralIntegerAddition [
	| value |
	value := module evaluateSource: '1+2'.
	self assert: value value equals: 3.
	self assert: value type equals: target literalIntegerType.

]

{ #category : #'literal arithmetic' }
SYMLBootstrapEnvironmentTest >> testLiteralIntegerFloatAddition [
	| value |
	value := module evaluateSource: '1+2.0'.
	self assert: value value equals: 3.0.
	self assert: value type equals: target literalFloatType.

]

{ #category : #'literal arithmetic' }
SYMLBootstrapEnvironmentTest >> testLiteralIntegerFloatAddition2 [
	| value |
	value := module evaluateSource: '1.0+2'.
	self assert: value value equals: 3.0.
	self assert: value type equals: target literalFloatType.

]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralString [
	| value |
	value := module evaluateSource: '"Hello World"'.
	self assert: value value equals: 'Hello World'.
	self assert: value type equals: target literalStringType.

]

{ #category : #'literal arithmetic' }
SYMLBootstrapEnvironmentTest >> testLiteralStringConcatenation [
	| value |
	value := module evaluateSource: '"Hello " -- "World"'.
	self assert: value value equals: 'Hello World'.
	self assert: value type equals: target literalStringType.

]

{ #category : #literals }
SYMLBootstrapEnvironmentTest >> testLiteralSymbol [
	| value |
	value := module evaluateSource: '#symbol'.
	self assert: value value equals: #symbol.
	self assert: value type equals: target literalSymbolType.

]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testNewExternCFunction [
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main externC () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunctionalPatternGroup.
	self assert: group alternatives first macroFunction equals: functionBuilder value.
]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testNewFunction [
	| functionBuilder group |
	functionBuilder := module evaluateSource: 'function main () -> Void'.
	group := module globalNamespace lookSymbol: #main.
	self assert: group isFunctionalPatternGroup.
	self assert: group alternatives first macroFunction equals: functionBuilder value.
]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testRedeclareExternCFunction [
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main externC () -> Void'.
	redeclaration := module evaluateSource: 'function main externC () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.
]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testRedeclareFunction [
	| declaration redeclaration |
	declaration := module evaluateSource: 'function main () -> Void'.
	redeclaration := module evaluateSource: 'function main () -> Void'.
	
	self assert: redeclaration value function equals: declaration value function.
]

{ #category : #tests }
SYMLBootstrapEnvironmentTest >> testTypeReference [
	| value |
	value := module evaluateSource: 'Void'.
	self assert: value type isMetaType.
	self assert: value value equals: target voidType.
]
