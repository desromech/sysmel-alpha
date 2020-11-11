Class {
	#name : #MbndWBTSysmelModuleCompilationBuildAction,
	#superclass : #WBTBuildAction,
	#category : #'SysmelMoebiusMetamodel-Core-WBT'
}

{ #category : #execution }
MbndWBTSysmelModuleCompilationBuildAction >> execute [
	parentTarget semanticAnalyzedCompilationEnvironment
		finishAndEmitModuleInOutputDirectory: parentTarget package validBuildObjectDirectory
			cacheDirectory: parentTarget package validBuildSysmelCacheDirectory.
	parentTarget writeDepsToCache.
	^ true
]
