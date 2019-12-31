Class {
	#name : #MbndAbstractFlagMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndAbstractFlagMetaBuilder >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector |
	node selector isLiteralSymbolValueNode ifTrue: [ 
		selector := node selector value.
		self validOwnerProgramEntity publicMetaBuilderFactories at: selector ifPresent: [ :metaBuilderFactory |
			^ self delegateToMetaBuilder: (metaBuilderFactory metaBuilderClass new
				addFlags: flags;
				yourself)
		].
	
		(analyzer scope lookupSymbolRecursively: selector ifAbsent: [ nil ]) ifNotNil: [ :binding |
			binding isMetaBuilderFactory ifTrue: [ 
				^ self delegateToMetaBuilder: (binding metaBuilderClass new
					addFlags: flags;
					yourself)
			].
		].
	].

	^ super analyzeUnexpandedMessageSendNode: node with: analyzer
]
