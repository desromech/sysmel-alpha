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
	| architecture outputFileName withDebugInformation arguments argumentIndex compilationCommands arg skipCount target compiler emitLLVM writeMode gpu compilationOptions targetVendor targetOS targetAttributes |
	self activateHelp
		ifTrue: [  ^ self ].
		
	architecture := Smalltalk wordSize = 4 ifTrue: [#x86] ifFalse: [#x86_64].
	targetVendor := nil.
	targetOS := nil.
	targetAttributes := nil.
	outputFileName := nil.
	withDebugInformation := false.
	writeMode := #executable.
	emitLLVM := true.
	gpu := false.
	
	arguments := self arguments.
	argumentIndex := 1.
	
	compilationOptions := OrderedCollection new.
	compilationCommands := OrderedCollection new.
	
	[argumentIndex <= arguments size] whileTrue: [
		arg := arguments at: argumentIndex.
		skipCount := 1.
		
		(arg = '-m32' or: [arg = '-mx86']) ifTrue: [ 
			architecture := #x86.
		].
		(arg = '-m32' or: [arg = '-mx86_64']) ifTrue: [  
			architecture := #x86.
		].
		arg = '-mvulkan' ifTrue: [  
			architecture := #spirv_logical64.
			emitLLVM := false.
			gpu := true.
		].
		arg = '-mvendor' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mvendor' ].
			targetVendor := arguments at: argumentIndex + 1.
			skipCount := 2
		].
		arg = '-mos' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mos' ].
			targetOS := arguments at: argumentIndex + 1.
			skipCount := 2
		].
		arg = '-mattr' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mattr' ].
			targetAttributes := arguments at: argumentIndex + 1.
			skipCount := 2
		].

		arg = '-noemit-llvm' ifTrue: [  
			emitLLVM := false.
		].
		arg = '-emit-llvm' ifTrue: [  
			emitLLVM := true.
		].
	
		arg = '-g' ifTrue: [  
			withDebugInformation := true.
		].
		arg = '-S' ifTrue: [
			writeMode := #assembly.
		].
		arg = '-c' ifTrue: [ 
			writeMode := #object
		].
		arg = '-O0' ifTrue: [
			compilationOptions add: [ :c | c optimizationLevel: 0 ]
		].
		arg = '-O1' ifTrue: [
			compilationOptions add: [ :c | c optimizationLevel: 1 ]
		].
		arg = '-O2' ifTrue: [
			compilationOptions add: [ :c | c optimizationLevel: 2 ]
		].
	
		arg = '-nostdlib' ifTrue: [ 
			compilationOptions add: [ :c | c noStandardLibrary ].
		].

		arg = '-nolibc' ifTrue: [
			compilationOptions add: [ :c | c noLibC ].
		].

		arg = '-nortti' ifTrue: [
			compilationOptions add: [ :c | c noRTTI ].
		].

		arg = '-freestanding' ifTrue: [
			compilationOptions add: [ :c | c freestanding ].
		].

		arg = '-o' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -o' ].
			outputFileName := arguments at: argumentIndex + 1.
			skipCount := 2
		].
	
		arg = '-eval' ifTrue: [
			| evalSource |
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -eval' ].
			evalSource := arguments at: argumentIndex + 1.
			evalSource = '-' ifTrue: [
				self flag: 'TODO: Implement this case'
			] ifFalse: [
				compilationCommands add: [ :comp |
					Stdio stdout nextPutAll: (comp evaluateLanguage: #sysmel source: evalSource) unwrapMbndValue printString; lf.
				].
			].
			skipCount := 2
		].
	
		(arg beginsWith: '-') ifFalse: [
			|fileName|
			fileName := arg.
			compilationCommands add: [ :comp | comp evaluateFileNamed: fileName ].
		].

		argumentIndex := argumentIndex + skipCount
	].

	compilationCommands ifEmpty: [ ^ self help ].

	target := MbndSlovimCompilationTarget perform: ((emitLLVM ifTrue: [ 'llvm_' ] ifFalse: ['']) , architecture) asSymbol.
	targetOS ifNotNil: [ target operatingSystemName: targetOS asSymbol ].
	targetVendor ifNotNil: [ target systemVendor: targetVendor asSymbol].
	targetAttributes ifNotNil: [ target machineAttributes: targetAttributes ].
	
	withDebugInformation ifTrue: [
		target withDebugInformation
	].

	compiler := MbndStandaloneModule compilationTarget: target.
	compilationOptions do: [ :option |
		option value: compiler.
	].

	gpu ifTrue: [ 
		compiler evaluateFileNamedOnce: Smalltalk imageDirectory  / 'lib' / 'gpu.sysmel'
	] ifFalse: [ 
		compiler evaluateFileNamedOnce: Smalltalk imageDirectory  / 'lib' / 'kernel' / 'kernel.sysmel'. 
	].
	
	[
		[ 
			compilationCommands do: [ :cmd | cmd cull: compiler ].

			outputFileName ifNotNil: [
				compiler writeMode: writeMode toFileNamed: outputFileName
			].
		] on: MbndCompilationWarning do: [ :warning |
			stderr nextPutAll: warning description; lf.
			warning resume
		]
	] on: MbndCompilationError do: [ :err |
		Smalltalk isInteractive ifTrue: [ err debug ].
		stderr nextPutAll: err description; lf.
		outputFileName asFileReference exists ifTrue: [ outputFileName asFileReference delete ].
		"err debug."
		^ Exit new status: 1; signal
	].
	

	self exitSuccess.
]
