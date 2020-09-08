Class {
	#name : #MbndRGEnvironmentBackend,
	#superclass : #RGEnvironmentBackend,
	#instVars : [
		'compilationEnvironment',
		'targetModule',
		'loadingEnvironment',
		'targetDirectory'
	],
	#category : #'SysmelCalypso-RingBackend'
}

{ #category : #environment }
MbndRGEnvironmentBackend >> addBehavior: anRGBehavior to: anRGEnvironment [
	| result |
	result := super addBehavior: anRGBehavior to: anRGEnvironment.
	anRGBehavior package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].
	self saveBehaviorToTonel: anRGBehavior.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> addExtensionMethod: anRGMethod to: aRGPackage [
	| result |
	result := super addExtensionMethod: anRGMethod to: aRGPackage.
	aRGPackage package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].
	self savePackageExtensionsToTone: aRGPackage.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> addLocalMethod: anRGMethod to: anRGBehavior [
	| result |
	result := super addLocalMethod: anRGMethod to: anRGBehavior.
	loadingEnvironment ifTrue: [ ^ result ].
	self saveBehaviorToTonel: anRGMethod parent.
	^ result
	
]

{ #category : #environment }
MbndRGEnvironmentBackend >> addPackage: aRGPackage to: anRGEnvironment [
	| result packageDirectory |
	result := super addPackage: aRGPackage to: anRGEnvironment.
	aRGPackage package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].

	packageDirectory := targetDirectory / aRGPackage name.
	packageDirectory exists ifFalse: [
		packageDirectory ensureCreateDirectory.
		packageDirectory / 'package.st' writeStreamDo: [ :out |
			out truncate; nextPutAll: 'Package { #name : '; nextPutAll: aRGPackage name asSymbol printString; nextPutAll: ' }'; lf.
		].
	].

	^ result
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> compilationEnvironment: anObject [
	compilationEnvironment := anObject
]

{ #category : #environment }
MbndRGEnvironmentBackend >> deleteBehaviorFromTonel: behavior [
	| className classTargetDirectory |
	behavior package name = #unresolved ifTrue: [ ^ self ].
	className := behavior instanceSide name.
	className ifNil: [ ^ self ].
	(behavior package name beginsWith: '[Import]') ifTrue: [ ^ self ].
	
	classTargetDirectory := targetDirectory / behavior package name.
	(classTargetDirectory / (behavior name , '.class.st')) ensureDelete.
	(classTargetDirectory / (behavior name , '.trait.st')) ensureDelete.
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> loadingEnvironment [
	^ loadingEnvironment
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> loadingEnvironment: anObject [
	loadingEnvironment := anObject
]

{ #category : #environment }
MbndRGEnvironmentBackend >> notSupportedOperation [
	self error: 'Unsupported operation'
]

{ #category : #environment }
MbndRGEnvironmentBackend >> removeBehavior: anRGBehavior from: anRGEnvironment [
	| result |
	result := super removeBehavior: anRGBehavior from: anRGEnvironment.
	anRGBehavior package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].
	self deleteBehaviorFromTonel: anRGBehavior.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> removeExtensionMethod: anRGMethod from: aRGPackage [
	| result |
	result := super removeExtensionMethod: anRGMethod from: aRGPackage.
	aRGPackage package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].
	self savePackageExtensionsToTone: aRGPackage.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> removeLocalMethod: anRGMethod from: anRGBehavior [
	| result |
	result := super removeLocalMethod: anRGMethod from: anRGBehavior.
	loadingEnvironment ifTrue: [ ^ result ].
	self saveBehaviorToTonel: anRGMethod parent.
	^ result
	
]

{ #category : #environment }
MbndRGEnvironmentBackend >> removePackage: anRGPackage from: anRGEnvironment [
	| result packageDirectory |
	result := super removePackage: anRGPackage from: anRGEnvironment.
	loadingEnvironment ifTrue: [ ^ result ].
	anRGPackage name = #unresolved ifTrue: [ ^ result ].

	packageDirectory := targetDirectory / anRGPackage name.
	packageDirectory exists ifTrue: [
		(packageDirectory / 'package.st') ensureDelete.
		packageDirectory hasChildren ifFalse: [ packageDirectory delete ]
	].

	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> saveBehaviorToTonel: behavior [
	| className behaviors definitions classTargetDirectory |
	behavior package name = #unresolved ifTrue: [ ^ self ].
	className := behavior instanceSide name.
	className ifNil: [ ^ self ].
	(behavior package name beginsWith: '[Import]') ifTrue: [ ^ self ].
	
	behaviors := {behavior instanceSide . behavior classSide}.
	definitions := OrderedCollection new.
	definitions
		add: behavior instanceSide asMCDefinition;
		addAll: (behaviors flatCollect: [:eachBehavior | 
			(eachBehavior localMethods reject: [:each | (each  parent instanceSide package = each package) not])
			collect: [ :method | method asMCDefinition] ]).
	classTargetDirectory := targetDirectory / behavior package name.
	classTargetDirectory ensureCreateDirectory.
	
	(TonelWriter on: classTargetDirectory) writePartialSnapshot: (MCSnapshot fromDefinitions: definitions).
]

{ #category : #environment }
MbndRGEnvironmentBackend >> savePackageExtensionsToTone: package [
	| definitions packageTargetDirectory |
	package name = #unresolved ifTrue: [ ^ self ].
	(package name beginsWith: '[Import]') ifTrue: [ ^ self ].
	
	definitions := OrderedCollection new.
	definitions
		addAll: (package extensionMethods collect: [:each | each asMCDefinition]).

	packageTargetDirectory := targetDirectory / package name.
	packageTargetDirectory ensureCreateDirectory.
	packageTargetDirectory children do: [ :each |
		(each basename endsWith: '.extension.st') ifTrue: [ each delete ]
	].
	
	(TonelWriter on: packageTargetDirectory) writePartialSnapshot: (MCSnapshot fromDefinitions: definitions).
]

{ #category : #environment }
MbndRGEnvironmentBackend >> setCommentFor: anRGBehavior to: anRGComment [
	| result |
	result := super setCommentFor: anRGBehavior to: anRGComment.
	anRGBehavior package name = #unresolved ifTrue: [ ^ result ].
	loadingEnvironment ifTrue: [ ^ result ].
	self saveBehaviorToTonel: anRGBehavior.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> setPackageFor: anRGBehavior to: anRGPackage [
	| result |
	result := super setPackageFor: anRGBehavior to: anRGPackage.
	loadingEnvironment ifTrue: [ ^ result ].
	self saveBehaviorToTonel: anRGBehavior.
	^ result
]

{ #category : #environment }
MbndRGEnvironmentBackend >> setSourceCodeFor: anRGMethod to: anObject [
	| result |
	result := super setSourceCodeFor: anRGMethod to: anObject.
	loadingEnvironment ifTrue: [ ^ result ].
	anRGMethod isExtension ifTrue: [
		anRGMethod package name = #unresolved ifFalse: [ 
			self savePackageExtensionsToTone: anRGMethod package.
		].
	] ifFalse: [ 
		self saveBehaviorToTonel: anRGMethod parent.
	].
	^ result
	
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetDirectory [
	^ targetDirectory
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetDirectory: anObject [
	targetDirectory := anObject
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetModule [
	^ targetModule
]

{ #category : #accessing }
MbndRGEnvironmentBackend >> targetModule: anObject [
	targetModule := anObject
]