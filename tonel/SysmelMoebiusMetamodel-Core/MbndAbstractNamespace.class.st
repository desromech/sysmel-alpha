Class {
	#name : #MbndAbstractNamespace,
	#superclass : #Object,
	#traits : 'TMbndNamespace',
	#classTraits : 'TMbndNamespace classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #serialization }
MbndAbstractNamespace class >> messagePackTypeName [
	^ nil
]

{ #category : #converting }
MbndAbstractNamespace >> fillProgramEntityInfoInstance: programEntityInfoInstance [
	self fillProgramEntityCommonInfoInstance: programEntityInfoInstance.
	programEntityInfoInstance setField: #localSymbolTable ifExistsWith: [ self localSymbolTableInstanceObject ]
]

{ #category : #serialization }
MbndAbstractNamespace >> messagePackTypeName [
	^ self class messagePackTypeName
]

{ #category : #enumerating }
MbndAbstractNamespace >> postMaterializeSetupParent: newParent withModule: newModule [
	self parent: newParent; module: newModule.
	self childrenDo: [ :child |
		child postMaterializeSetupParent: self withModule: newModule
	].
]

{ #category : #'as yet unclassified' }
MbndAbstractNamespace >> programEntityInformationDataClass [
	^ self compilationTarget namespaceInformationClass
]
