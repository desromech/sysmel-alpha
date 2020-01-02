Class {
	#name : #MbndAbstractMacro,
	#superclass : #Object,
	#traits : 'TMbndMacro',
	#classTraits : 'TMbndMacro classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndAbstractMacro >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]
