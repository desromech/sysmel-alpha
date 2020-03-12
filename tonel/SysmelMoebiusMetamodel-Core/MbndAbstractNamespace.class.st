Class {
	#name : #MbndAbstractNamespace,
	#superclass : #Object,
	#traits : 'TMbndNamespace',
	#classTraits : 'TMbndNamespace classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #converting }
MbndAbstractNamespace >> fillProgramEntityInfoInstance: programEntityInfoInstance [
	self fillProgramEntityCommonInfoInstance: programEntityInfoInstance.
	programEntityInfoInstance setField: #localSymbolTable ifExistsWith: [ self localSymbolTableInstanceObject ]
]

{ #category : #'as yet unclassified' }
MbndAbstractNamespace >> programEntityInformationDataClass [
	^ self compilationTarget namespaceInformationClass
]
