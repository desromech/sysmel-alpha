Class {
	#name : #MbndFunctionAnalysisScope,
	#superclass : #MbndFunctionScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #'macro expansion' }
MbndFunctionAnalysisScope >> lookupSymbol: aSymbol [
	(super lookupSymbol: aSymbol) ifNotNil: [ :result | ^ result ].
	^ programEntity lookupBoundReceiverSymbol: aSymbol
]
