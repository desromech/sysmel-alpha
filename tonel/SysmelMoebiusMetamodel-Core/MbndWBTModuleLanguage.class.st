Class {
	#name : #MbndWBTModuleLanguage,
	#superclass : #WBTBatchCompilationBasedLanguage,
	#category : #'SysmelMoebiusMetamodel-Core-WBT'
}

{ #category : #'as yet unclassified' }
MbndWBTModuleLanguage >> createIntermediateObjectFilesFor: sourceFile module: targetModule [
	targetModule sysmelModuleTarget addSourceFile: sourceFile
]
