Class {
	#name : #MbndConcreteFunctionMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndConcreteFunctionMethod class >> messagePackTypeName [
	^ #ConcreteFunctionMethod
]

{ #category : #visiting }
MbndConcreteFunctionMethod >> accept: aVisitor [
	^ aVisitor visitConcreteFunctionMethod: self
]

{ #category : #testing }
MbndConcreteFunctionMethod >> hasProgramEntityReflectiveNode [
	^ self isDefinition
]

{ #category : #testing }
MbndConcreteFunctionMethod >> isFunctionMethod [
	^ true
]

{ #category : #'as yet unclassified' }
MbndConcreteFunctionMethod >> programEntityInformationDataClass [
	^ self compilationTarget functionInformationClass
]

{ #category : #'as yet unclassified' }
MbndConcreteFunctionMethod >> vtableEntryKind [
	^ #function
]
