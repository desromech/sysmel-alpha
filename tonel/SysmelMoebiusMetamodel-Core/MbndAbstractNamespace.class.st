Class {
	#name : #MbndAbstractNamespace,
	#superclass : #Object,
	#traits : 'TMbndNamespace',
	#classTraits : 'TMbndNamespace classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #accessing }
MbndAbstractNamespace >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]
