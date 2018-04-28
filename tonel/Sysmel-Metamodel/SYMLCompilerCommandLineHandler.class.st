Class {
	#name : #SYMLCompilerCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Sysmel-Metamodel-FrontEnd'
}

{ #category : #accessing }
SYMLCompilerCommandLineHandler class >> commandName [
	" Overwrite this method to provide a short name for this command handler.
	You may pass the commandName as first argument to the image to select this handler"
	^ #sysmelc
]

{ #category : #activation }
SYMLCompilerCommandLineHandler >> activate [
	| architecture outputFileName withDebugInformation writeObject optimizationLevel arguments argumentIndex compilationCommands arg skipCount target compiler emitLLVM writeMode noLanguageKernel noStandardLibrary |
	self activateHelp
		ifTrue: [  ^ self ].
		
	architecture := #x86.
	outputFileName := nil.
	withDebugInformation := false.
	writeMode := #executable.
	emitLLVM := false.
	noLanguageKernel := false.
	noStandardLibrary := false.
	
	optimizationLevel := 0.
	
	arguments := self arguments.
	argumentIndex := 1.
	
	compilationCommands := OrderedCollection new.
	
	[argumentIndex <= arguments size] whileTrue: [
		arg := arguments at: argumentIndex.
		skipCount := 1.
		
		arg = '-m32' ifTrue: [ 
			architecture := #x86.
		].
		arg = '-m64' ifTrue: [  
			architecture := #x86.
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
			optimizationLevel := 0
		].
		arg = '-O1' ifTrue: [ 
			optimizationLevel := 1
		].
		arg = '-O2' ifTrue: [ 
			optimizationLevel := 2
		].
	
		arg = '-nolangkernel' ifTrue: [ 
			noLanguageKernel := true.
		].
		arg = '-nostdlib' ifTrue: [ 
			noStandardLibrary := true.
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
					FileStream stdout nextPutAll: (comp evaluateSource: evalSource) value printString; lf.
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

	target := SYMLCompilationTarget perform: ((emitLLVM ifTrue: [ 'llvm_' ] ifFalse: ['']) , architecture) asSymbol.
	withDebugInformation ifTrue: [
		target withDebugInformation
	].

	compiler := SYMLModule compilationTarget: target.
	compiler optimizationLevel: optimizationLevel.
	
	noLanguageKernel ifFalse: [ 
		compiler evaluateFileNamed: 'lib/kernel/kernel.sysmel'
	].
	noStandardLibrary ifFalse: [
		compiler evaluateFileNamed: 'lib/stdlib/stdlib.sysmel'
	].

	[
		compilationCommands do: [ :cmd | cmd cull: compiler ].
	] on: SYMLError do: [ :err |
		stderr nextPutAll: err description; lf.
		^ Exit new status: 1; signal
	].
	
	outputFileName ifNotNil: [
		compiler writeMode: writeMode ToFileNamed: outputFileName
	].

	self exitSuccess.
]
