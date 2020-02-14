Class {
	#name : #MbndCoreAssets,
	#superclass : #Object,
	#classVars : [
		'MbndCoreAssetsLocation',
		'Session'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Directories'
}

{ #category : #'as yet unclassified' }
MbndCoreAssets class >> findCoreAssets [
	| location testElement |
	location := Smalltalk imageDirectory.
	testElement := 'lib/kernel/kernel.sysmel' asFileReference.
	(location resolve: testElement) exists ifFalse: [
		location := IceLibgitRepository repositoriesLocation asFileReference / #'ronsaldo' / #sysmel
	].

	(location resolve: testElement) exists ifFalse: [
		location := FileSystem workingDirectory / 'core-assets'
	].
	
	(location resolve: testElement) exists ifFalse: [
		self error: 'Failed to find the Sysmel moebius core assets.'
	].

	^ location
]

{ #category : #accessing }
MbndCoreAssets class >> location [
	Session ~~ Smalltalk session ifTrue: [ 
		MbndCoreAssetsLocation := self findCoreAssets.
		Session := Smalltalk session
	].
	^ MbndCoreAssetsLocation
]
