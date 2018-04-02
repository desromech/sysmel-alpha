Class {
	#name : #SYMLAPSGBuilder,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'builder methods' }
SYMLAPSGBuilder >> chain: receiver messages: messages [
	<compileTime>
	^ SYMLAPSGMessageChain new receiver: receiver; messages: messages
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
SYMLAPSGBuilder >> language: aLanguageName source: sourceCode [
	<compileTime>
	^ SYMLAPSGLanguageSource new language: aLanguageName; sourceCode: sourceCode; yourself
]

{ #category : #'builder methods' }
SYMLAPSGBuilder >> literal: aValue [
	<compileTime>
	^ SYMLAPSGLiteral new value: aValue
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
SYMLAPSGBuilder >> tuple: aCollectionOfNodes [
	<compileTime>
	^ SYMLAPSGTuple new elements: aCollectionOfNodes
]
