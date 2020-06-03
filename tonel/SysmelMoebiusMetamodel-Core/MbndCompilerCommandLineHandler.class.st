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
	| architecture outputDirectory withDebugInformation arguments argumentIndex compilationCommands arg skipCount target compiler emitLLVM writeMode gpu compilationOptions targetVendor targetOS targetAttributes linkerArguments useLLVM targetCPU targetFPU |
	self activateHelp
		ifTrue: [  ^ self ].
		
	architecture := Smalltalk wordSize = 4 ifTrue: [#x86] ifFalse: [#x86_64].
	targetCPU := nil.
	targetFPU := nil.
	targetVendor := nil.
	targetOS := nil.
	targetAttributes := nil.
	outputDirectory := nil.
	withDebugInformation := false.
	writeMode := #executable.
	useLLVM := true.
	emitLLVM := false.
	gpu := false.
	
	arguments := self arguments.
	argumentIndex := 1.
	
	compilationOptions := OrderedCollection new.
	compilationCommands := OrderedCollection new.
	linkerArguments := OrderedCollection new.
	
	[argumentIndex <= arguments size] whileTrue: [
		arg := arguments at: argumentIndex.
		skipCount := 1.
		
		(arg = '-m32' or: [arg = '-mx86']) ifTrue: [ 
			architecture := #x86.
		].
		(arg = '-m64' or: [arg = '-mx86_64']) ifTrue: [  
			architecture := #x86_64.
		].
		arg = '-mwasm' ifTrue: [  
			architecture := #webAssembly.
		].
		arg = '-mwasm32' ifTrue: [  
			architecture := #webAssembly32.
		].
		arg = '-mwasm64' ifTrue: [  
			architecture := #webAssembly64.
		].
		(#('-marm' '-marmv5' '-marmv6' '-marmv6m' '-marmv7' '-marmv7a' '-marmv7m') includes: arg) ifTrue: [  
			architecture := (arg allButFirst: 2) asSymbol.
		].
		arg = '-mvulkan' ifTrue: [  
			architecture := #spirv_vulkan.
			useLLVM := false.
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
		arg = '-mcpu' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mcpu' ].
			targetCPU := arguments at: argumentIndex + 1.
			skipCount := 2
		].
		arg = '-mfpu' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mfpu' ].
			targetFPU := arguments at: argumentIndex + 1.
			skipCount := 2
		].

		arg = '-mattr' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -mattr' ].
			targetAttributes := arguments at: argumentIndex + 1.
			skipCount := 2
		].

		arg = '-no-use-llvm' ifTrue: [  
			useLLVM := false.
		].
		arg = '-use-llvm' ifTrue: [  
			useLLVM := true.
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
			writeMode := emitLLVM ifTrue: [#llvm_assembly] ifFalse: [#assembly].
		].
		arg = '-c' ifTrue: [ 
			writeMode := #object
		].
		arg = '-shared' ifTrue: [ 
			writeMode := #shared
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
	
		arg = '-no-stdlib' ifTrue: [ 
			compilationOptions add: [ :c | c noStandardLibrary ].
		].

		arg = '-no-libc' ifTrue: [
			compilationOptions add: [ :c | c noLibC ].
		].

		arg = '-no-rtti' ifTrue: [
			compilationOptions add: [ :c | c noRTTI ].
		].

		arg = '-no-gc' ifTrue: [
			compilationOptions add: [ :c | c noGC ].
		].

		arg = '-no-exceptions' ifTrue: [
			compilationOptions add: [ :c | c noExceptions ].
		].

		arg = '-monolithic' ifTrue: [
			compilationOptions add: [ :c | c monolithic ].
		].

		arg = '-freestanding' ifTrue: [
			compilationOptions add: [ :c | c freestanding ].
		].

		(#(-fpic -fPIC) includes: arg) ifTrue: [
			compilationOptions add: [ :c | c withPositionIndependentCode ].
		].

		arg = '-o' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -o' ].
			outputDirectory := arguments at: argumentIndex + 1.
			skipCount := 2
		].

		arg = '-module-sources' ifTrue: [
			| moduleSourceDirectory |
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -module-name' ].
			moduleSourceDirectory := (arguments at: argumentIndex + 1) asSymbol.
			compilationOptions add: [ :c | c addModuleSourceLocation: moduleSourceDirectory ].
			skipCount := 2
		].
	
		arg = '-module-name' ifTrue: [
			| moduleName |
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -module-name' ].
			moduleName := (arguments at: argumentIndex + 1) asSymbol.
			compilationOptions add: [ :c | c beginModule: moduleName ].
			skipCount := 2
		].
	
		arg = '-oes' ifTrue: [
			| embeddedShaderCopyOutputFile |
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -oes' ].
			embeddedShaderCopyOutputFile := arguments at: argumentIndex + 1.
			compilationCommands add: [ :comp | comp evaluateFileNamedOnce: embeddedShaderCopyOutputFile ].
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
	
		((arg beginsWith: '-l') or: [(arg beginsWith: '-L') or: [arg beginsWith: '-Wl']]) ifTrue: [ 
			linkerArguments add: arg
		].
	
		(arg beginsWith: '-') ifFalse: [
			|fileName|
			fileName := arg.
			compilationCommands add: [ :comp | comp evaluateFileNamedOnce: fileName ].
		].

		argumentIndex := argumentIndex + skipCount
	].

	compilationCommands ifEmpty: [ ^ self help ].

	target := MbndSlovimCompilationTarget perform: ((useLLVM ifTrue: [ 'llvm_' ] ifFalse: ['']) , architecture) asSymbol.
	targetOS ifNotNil: [ target operatingSystemName: targetOS asSymbol ].
	targetVendor ifNotNil: [ target systemVendor: targetVendor asSymbol].
	targetAttributes ifNotNil: [ target machineAttributes: targetAttributes ].
	
	withDebugInformation ifTrue: [
		target withDebugInformation
	].

	compiler := MbndCompilationEnvironment compilationTarget: target.
	compiler outputDirectory: outputDirectory.
	compilationOptions do: [ :option |
		option value: compiler.
	].

	compiler addLinkerArguments: linkerArguments.
	compiler outputMode: writeMode.

	compiler loadRuntimeCoreLibrary.
	[
		[ 
			compilationCommands do: [ :cmd | cmd cull: compiler ].
			compiler finishAndEmitModule
		] on: MbndCompilationWarning do: [ :warning |
			stderr nextPutAll: warning description; lf.
			warning resume
		]
	] on: MbndCompilationError do: [ :err |
		Smalltalk isInteractive ifTrue: [ err debug ].
		stderr nextPutAll: err description; lf.
		"err debug."
		^ Exit new status: 1; signal
	].
	

	self exitSuccess.
]
