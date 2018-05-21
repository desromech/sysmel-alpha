Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#category : #'Sysmel-Metamodel-Function'
}

{ #category : #testing }
SYMLMethod >> isExternC [
	<compileTime>
	^ false
]

{ #category : #testing }
SYMLMethod >> isMethod [
	^ true
]
