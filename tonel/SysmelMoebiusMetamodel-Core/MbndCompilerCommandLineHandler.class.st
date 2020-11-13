"
sysmelc - Sysmel Command Line Compiler Frontend
sysmelc <options> [sysmel source to evaluate]*
Valid options:

"
Class {
	#name : #MbndCompilerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'SysmelMoebiusMetamodel-Core-Front-End'
}

{ #category : #accessing }
MbndCompilerCommandLineHandler class >> commandName [
	" Overwrite this method to provide a short name for this command handler.
	You may pass the commandName as first argument to the image to select this handler"
	^ #sysmelc
]

{ #category : #activation }
MbndCompilerCommandLineHandler >> activate [
	| buildEnvironment sysmelSources programName |
	self activateHelp
		ifTrue: [  ^ self ].
		
	buildEnvironment := WBTBuildEnvironment forCurrentPlatformWithClang.

	(self hasOption: 'debug') ifTrue: [ buildEnvironment setDebugBuildMode ].
	(self hasOption: 'release') ifTrue: [ buildEnvironment setReleaseBuildMode ].
	(self hasOption: 'release-with-debug-info') ifTrue: [ buildEnvironment setReleaseWithDebugInfoBuildMode ].
	(self hasOption: 'minsize') ifTrue: [ buildEnvironment setMinSizeBuildMode ].
	self optionAt: 'o' ifPresent: [:outDir | buildEnvironment buildDirectory: outDir ].
	
	buildEnvironment setSysmelSettingsWith: [ :settings |
		(self hasOption: 'no-rtti') ifTrue: [ settings noRTTI ].
	].

	sysmelSources := commandLine allFilesWithExtension: '.sysmel'.
	sysmelSources ifEmpty: [ ^ self exitSuccess ].
	
	programName := sysmelSources first asFileReference basenameWithoutExtension.
	buildEnvironment buildMainPackageWith: [ :packageScript |
		packageScript program: programName with: [ :prog |
			prog sources: sysmelSources
		]
	].
	self exitSuccess.
]
