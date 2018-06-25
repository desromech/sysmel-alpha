Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #'as yet unclassified' }
SYMLMethod >> abstractFunctionKind [
	^ #method
]

{ #category : #testing }
SYMLMethod >> isExternC [
	<compileTime>
	^ false
]

{ #category : #testing }
SYMLMethod >> isMethod [
	^ true
]
