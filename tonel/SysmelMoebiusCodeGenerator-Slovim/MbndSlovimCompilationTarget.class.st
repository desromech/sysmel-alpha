Class {
	#name : #MbndSlovimCompilationTarget,
	#superclass : #MbndAbstractConcreteCompilationTarget,
	#instVars : [
		'slvmCompilationTarget',
		'targetName'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86 [
	^ self slvmCompilationTargetNamed: #llvm_x86
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> llvm_x86_64 [
	^ self slvmCompilationTargetNamed: #llvm_x86_64
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> slvmCompilationTargetNamed: slvmTargetName [
	^ self basicNew
		slvmCompilationTargetNamed: slvmTargetName;
		yourself
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget class >> spirv_vulkan [
	^ self slvmCompilationTargetNamed: #spirv_logical64
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

{ #category : #converting }
MbndSlovimCompilationTarget >> asCleanCompilationTarget [
	| cleanTarget |
	cleanTarget := self class slvmCompilationTargetNamed: targetName.
	cleanTarget
		machineAttributes: self machineAttributes;
		operatingSystemName: self operatingSystemName;
		systemVendor: self systemVendor.
	cleanTarget slvmCompilationTarget
		emittingDebugInformation: slvmCompilationTarget emittingDebugInformation.
		
	^ cleanTarget
]

{ #category : #converting }
MbndSlovimCompilationTarget >> asSpirVCompilationTarget [
	^ self slvmCompilationTargetNamed: (self pointerSize = 4
		ifTrue: [#spirv_logical32]
		ifFalse: [#spirv_logical64])
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget >> extensionForModuleOutputMode: mode [
	slvmCompilationTarget isSpirV ifTrue: [
		mode = #executable ifTrue: [ ^ '.spv' ]
	].

	^ super extensionForModuleOutputMode: mode
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

{ #category : #testing }
MbndSlovimCompilationTarget >> isBigEndian [
	^ slvmCompilationTarget isBigEndian
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isFreeBSD [
	^ slvmCompilationTarget isFreeBSD
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isGPU [
	^ slvmCompilationTarget isGPU
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isLinux [
	^ slvmCompilationTarget isLinux
]

{ #category : #testing }
MbndSlovimCompilationTarget >> isLittleEndian [
	^ slvmCompilationTarget isLittleEndian
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isOSX [
	^ slvmCompilationTarget isOSX
]

{ #category : #'platform testing' }
MbndSlovimCompilationTarget >> isWin32 [
	^ slvmCompilationTarget isWin32
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget >> landingPadSelectorRegisterIndex [
	^ slvmCompilationTarget landingPadSelectorRegisterIndex
]

{ #category : #'as yet unclassified' }
MbndSlovimCompilationTarget >> landingPadStructurePointerRegisterIndex [
	^ slvmCompilationTarget landingPadStructurePointerRegisterIndex
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
		yourself).
	self addSysmelLLVMGCPlugin
]

{ #category : #accessing }
MbndSlovimCompilationTarget >> slvmCompilationTargetNamed: theTargetName [
	targetName := theTargetName.
	^ self slvmCompilationTarget: (SLVMCompilationTarget perform: targetName asSymbol)
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
	slvmCompilationTarget withDebugInformation
]

{ #category : #initialization }
MbndSlovimCompilationTarget >> withPositionIndependentCode [
	slvmCompilationTarget withPositionIndependentCode.
]
