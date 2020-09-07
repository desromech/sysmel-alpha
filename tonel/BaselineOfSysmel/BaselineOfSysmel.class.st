Class {
	#name : #BaselineOfSysmel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmel
}

{ #category : #baselines }
BaselineOfSysmel >> baseline: spec [
	<baseline>

	| conditionalDeps |
	spec for: #common do: [
		"Omit pp2 from the baseline to avoid Metacello conflicts when loading in GToolkit."
		conditionalDeps := #().
		Smalltalk globals at: #SmaCCParser ifAbsent: [ 
			conditionalDeps := { #'SmaCC' }.
			spec baseline: #'SmaCC' with: [
					spec
						repository: 'github://SmaCCRefactoring/SmaCC';
						loads: #(#'Runtime') ].
		].
		spec baseline: #'Slovim' with: [
				spec
					repository: 'github://ronsaldo/slovim/tonel' ].
		spec baseline: #'AbstractGPU' with: [
				spec
					repository: 'github://ronsaldo/abstract-gpu/tonel' ].
		spec baseline: #'WBT' with: [
				spec
					repository: 'github://ronsaldo/wbt/tonel' ].
		spec
			package: #'SysmelMoebiusMetamodel-Core' with: [
				spec requires: #(#Slovim #WBT)
			].
		spec
			package: #'SysmelMoebiusMetamodel-Core-Tests' with: [
				spec requires: #(#'SysmelMoebiusMetamodel-Core')
			].
		spec
			package: #'SysmelLanguage-Sysmel' with: [
				spec requires: conditionalDeps , #(#'SysmelMoebiusMetamodel-Core')
			].
		spec
			package: #'SysmelLanguage-Sysmel-Tests' with: [
				spec requires: #(#'SysmelLanguage-Sysmel')
			].
		spec
			package: #'SysmelLanguage-Pharo' with: [
				spec requires: #(#'SysmelMoebiusMetamodel-Core')
			].
		spec
			package: #'SysmelLanguage-Pharo-Tests' with: [
				spec requires: #(#'SysmelLanguage-Pharo')
			].

		spec
			package: #'SysmelMoebiusCodeGenerator-Slovim' with: [
				spec requires: #(#Slovim #'SysmelMoebiusMetamodel-Core')
			].
		spec
			package: #'SysmelMoebiusCodeGenerator-Slovim-Tests' with: [
				spec requires: #(#'SysmelMoebiusCodeGenerator-Slovim' #'SysmelLanguage-Sysmel')
			].

		spec
			package: #'SysmelGPUBlocks-Core' with: [
				spec requires: #(#'SysmelMoebiusCodeGenerator-Slovim' #'SysmelLanguage-Pharo')
			].
		spec
			package: #'SysmelGPUBlocks-Core-Tests' with: [
				spec requires: #(#'SysmelGPUBlocks-Core')
			].

		spec
			package: #'SysmelGPUBlocks-AbstractGPU' with: [
				spec requires: #(#'SysmelGPUBlocks-Core' #'AbstractGPU')
			].
		spec
			package: #'SysmelGPUBlocks-AbstractGPU-Tests' with: [
				spec requires: #(#'SysmelGPUBlocks-Core-Tests')
			].
		spec
			package: #'SysmelCalypso' with: [
				spec requires: #(#'SysmelMoebiusMetamodel-Core' #'SysmelLanguage-Pharo')
			].

	].
]
