Class {
	#name : #MbndAbstractGPUAssets,
	#superclass : #Object,
	#classVars : [
		'MbndAbstractGPUAssetsLocation',
		'Session'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Directories'
}

{ #category : #'as yet unclassified' }
MbndAbstractGPUAssets class >> findAssets [
	| location testElement |
	location := Smalltalk imageDirectory.
	testElement := 'bindings/sysmel/module-sources/Bindings.AbstractGPU' asFileReference.
	(location resolve: testElement) exists ifFalse: [
		location := IceLibgitRepository repositoriesLocation asFileReference / #'ronsaldo' / #'abstract-gpu'
	].

	(location resolve: testElement) exists ifFalse: [
		location := FileSystem workingDirectory
	].
	
	(location resolve: testElement) exists ifFalse: [
		self error: 'Failed to find the Sysmel moebius core assets.'
	].

	^ location
]

{ #category : #accessing }
MbndAbstractGPUAssets class >> location [
	Session ~~ Smalltalk session ifTrue: [ 
		MbndAbstractGPUAssetsLocation := self findAssets.
		Session := Smalltalk session
	].
	^ MbndAbstractGPUAssetsLocation
]
