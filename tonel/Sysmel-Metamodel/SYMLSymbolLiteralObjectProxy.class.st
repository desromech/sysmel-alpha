Class {
	#name : #SYMLSymbolLiteralObjectProxy,
	#superclass : #SYMLLiteralObjectProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLSymbolLiteralObjectProxy >> generateObjectInstance [
	^ type compilationTarget objectModel createSymbolObjectInstance: proxiedObject

]
