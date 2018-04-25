Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#category : #'Sysmel-Metamodel-Program'
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
