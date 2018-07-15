Class {
	#name : #SYMLGCClassFieldVariable,
	#superclass : #SYMLFieldVariable,
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #accessing }
SYMLGCClassFieldVariable >> type: aType [
	<compileTime>
	type := aType asVariableValueType asGCClassFieldType
]
