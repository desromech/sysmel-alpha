Class {
	#name : #SYMLAPSGBuilder,
	#superclass : #SYMLObject,
	#instVars : [
		'environment'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'builder methods' }
SYMLAPSGBuilder >> associationKey: key value: value [
	<compileTime>
	^ SYMLAPSGTuple new elements: { key . value }
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> chain: receiver messages: messages [
	<compileTime>
	^ SYMLAPSGMessageChain new receiver: receiver; messages: messages
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> contructDictionaryWith: associations [
	<compileTime>
	^ SYMLAPSGDictionaryConstruction new associations: associations
]

{ #category : #accessing }
SYMLAPSGBuilder >> environment [
	^ environment
]

{ #category : #accessing }
SYMLAPSGBuilder >> environment: anObject [
	environment := anObject
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> identifier: aValue [
	<compileTime>
	^ SYMLAPSGIdentifier new value: aValue
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> inlineAssemblyArch: architecture language: language sourceCode: sourceCode [
	<compileTime>
	^ SYMLAPSGInlineAssembly new
		architecture: architecture;
		language: language;
		sourceCode: sourceCode;
		yourself
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> language: aLanguageName source: sourceCode [
	<compileTime>
	^ SYMLAPSGLanguageSource new language: aLanguageName; sourceCode: sourceCode; yourself
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> lexicalScope: node [
	^ SYMLAPSGLexicalScopeNode new node: node
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> literal: aValue [
	<compileTime>
	^ SYMLAPSGLiteral new value: aValue
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> literal: aValue typeSelector: typeSelector [
	<compileTime>
	| literalType |
	literalType := environment compilationTarget perform: typeSelector.
	^ literalType
		ifNil: [ SYMLAPSGLiteralWithLazyType new value: aValue; typeSelector: typeSelector; environment: environment ]
		ifNotNil: [ SYMLAPSGLiteral new value: (aValue sysmelValueWithType: literalType inEnvironment: environment) ]
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> literalString: stringLiteral position: aPosition [
	<compileTime>
	^ self literal: stringLiteral typeSelector: #literalStringType
]

{ #category : #'as yet unclassified' }
SYMLAPSGBuilder >> pragmaSelector: selector arguments: arguments [
	<compileTime>
	^ SYMLAPSGPragma new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> pragmas: aCollectionOfPragmas sequence: aCollectionOfNodes [
	<compileTime>
	^ SYMLAPSGSequence new
		pragmas: aCollectionOfPragmas;
		elements: aCollectionOfNodes;
		yourself
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> quasiQuote: aNode [
	<compileTime>
	^ SYMLAPSGQuasiQuote new node: aNode
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> quasiUnquote: aNode [
	<compileTime>
	^ SYMLAPSGQuasiUnquote new node: aNode
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> quote: aNode [
	<compileTime>
	^ SYMLAPSGQuote new node: aNode
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> send: selector to: aReceiver withArguments: arguments [
	<compileTime>
	<compileTime>
	^ SYMLAPSGMessageSend new
		selector: selector;
		receiver: aReceiver;
		arguments: arguments;
		yourself
		
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> sequence: aCollectionOfNodes [
	<compileTime>
	^ SYMLAPSGSequence new elements: aCollectionOfNodes
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> splice: aNode [
	<compileTime>
	^ SYMLAPSGSplice new node: aNode
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> tuple: aCollectionOfNodes [
	<compileTime>
	^ SYMLAPSGTuple new elements: aCollectionOfNodes
]
