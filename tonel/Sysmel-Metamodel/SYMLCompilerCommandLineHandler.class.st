"
Sysmel Compiler

sysmelc [options] <Input files>+
================================================================================
== Compiler options
================================================================================
-o <output file> 
-m[32,64,vulkan]                 Target machine architecture.
-[no]emit-llvm                   Use LLVM for code generation.
-g                               Emit debugging information.
-S                               Emit assembly code.
-c                               Emit object code.
-O[0|1|2|3]                      Optimization level.
-nostdlib                        Do not include the standard library.
-nolibc                          Do not user libc.
-nortti                          Do not emit runtime type information.
-freestanding                    Freestanding mode. For OS Kernel development.
-eval                            Eval sysmel script.

"
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
	| architecture outputFileName withDebugInformation arguments argumentIndex compilationCommands arg skipCount target compiler emitLLVM writeMode gpu compilationOptions |
	self activateHelp
		ifTrue: [  ^ self ].
		
	architecture := #x86.
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
		
		arg = '-m32' ifTrue: [ 
			architecture := #x86.
		].
		arg = '-m64' ifTrue: [  
			architecture := #x86.
		].
		arg = '-mvulkan' ifTrue: [  
			architecture := #spirv_logical64.
			gpu := true.
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
					Stdio stdout nextPutAll: (comp evaluateSource: evalSource) value printString; lf.
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

	target := SYMLCompilationTarget perform: ((emitLLVM ifTrue: [ 'llvm_' ] ifFalse: ['']) , architecture) asSymbol.
	withDebugInformation ifTrue: [
		target withDebugInformation
	].

	compiler := SYMLModule compilationTarget: target.
	compilationOptions do: [ :option |
		option value: compiler.
	].

	gpu ifTrue: [ 
		compiler evaluateFileNamedOnce: Smalltalk imageDirectory  / 'lib' / 'gpu.sysmel'
	] ifFalse: [ 
		compiler evaluateFileNamedOnce: Smalltalk imageDirectory  / 'lib' / 'kernel' / 'kernel.sysmel'. 
	].
	
	[
		compilationCommands do: [ :cmd | cmd cull: compiler ].

		outputFileName ifNotNil: [
			compiler writeMode: writeMode ToFileNamed: outputFileName
		].
	] on: SYMLError do: [ :err |
		stderr nextPutAll: err description; lf.
		outputFileName asFileReference exists ifTrue: [ outputFileName asFileReference delete ].
		"err debug."
		^ Exit new status: 1; signal
	].
	

	self exitSuccess.
]
