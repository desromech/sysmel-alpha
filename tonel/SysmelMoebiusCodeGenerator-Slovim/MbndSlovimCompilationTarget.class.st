Class {
	#name : #MbndSlovimCompilationTarget,
	#superclass : #MbndAbstractConcreteCompilationTarget,
	#instVars : [
		'slvmCompilationTarget'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86 [
	^ self slvmCompilationTarget: SLVMLLVMCompilationTarget x86
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86_64 [
	^ self slvmCompilationTarget: SLVMLLVMCompilationTarget x86_64
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> slvmCompilationTarget: slvmTarget [
	^ self basicNew
		slvmCompilationTarget: slvmTarget;
		yourself
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> spirv_vulkan [
	^ self slvmCompilationTarget: SLVMLLVMCompilationTarget spirv_logical64
]

{ #category : #adding }
MbndSlovimCompilationTarget >> addSysmelLLVMGCPlugin [
	| path |
	#(
		'SysmelGCPlugin.so'
		'SysmelGCPlugin.dylib'
		'SysmelGCPlugin.dll'
	) do: [ :pluginName |
		path := Smalltalk imageDirectory / pluginName.
		path exists ifTrue: [
			^ slvmCompilationTarget compilationPlugins: { path fullName }
		]
	]

]

{ #category : #accessing }
MbndSlovimCompilationTarget >> float64Alignment [
	^ slvmCompilationTarget float64 alignment
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> hasNoOperatingSystem [
	^ slvmCompilationTarget isNoOperatingSystem
]

{ #category : #initialization }
MbndSlovimCompilationTarget >> initialize [
	super initialize.
	self initializeTypeSystem.
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> int64Alignment [
	^ slvmCompilationTarget int64 alignment
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isFreeBSD [
	^ slvmCompilationTarget isFreeBSD
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isLinux [
	^ slvmCompilationTarget isLinux
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isOSX [
	^ slvmCompilationTarget isOSX
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isWin32 [
	^ slvmCompilationTarget isWin32
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> machineAttributes [
	^ slvmCompilationTarget machineAttributes
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> machineAttributes: machineAttributes [
	slvmCompilationTarget machineAttributes: machineAttributes
]

{ #category : #'instance creation' }
MbndSlovimCompilationTarget >> newCodeModuleGenerator [
	^ MbndSlovimCodeModuleGenerator new
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> operatingSystemName [
	^ slvmCompilationTarget operatingSystemName
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> operatingSystemName: osName [
	slvmCompilationTarget operatingSystemName: osName
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> pointerAlignment [
	^ slvmCompilationTarget pointerAlignment
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> pointerSize [
	^ slvmCompilationTarget pointerSize
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget [
	^ slvmCompilationTarget
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTarget: anObject [
	slvmCompilationTarget := anObject.
	slvmCompilationTarget objectModel: (MbndSlovimObjectModel new
		managedObjectModel: self managedObjectModel;
		target: slvmCompilationTarget;
		yourself)
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> systemVendor [
	^ slvmCompilationTarget systemVendor
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> systemVendor: vendor [
	slvmCompilationTarget systemVendor: vendor
]

{ #category : #initialization }
MbndSlovimCompilationTarget >> withDebugInformation [
	slvmCompilationTarget withDebugInformation.
	self addSysmelLLVMGCPlugin
]
