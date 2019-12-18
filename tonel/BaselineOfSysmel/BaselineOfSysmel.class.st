Class {
	#name : #BaselineOfSysmel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmel
}

{ #category : #baselines }
BaselineOfSysmel >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'PetitParser2Core' with: [
				spec
					repository: 'github://kursjan/petitparser2' ].
		spec baseline: #'Slovim' with: [
				spec
					repository: 'github://ronsaldo/slovim/tonel' ].
		spec baseline: #'Phanide' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
		spec baseline: #'AbstractGPU' with: [
				spec
					repository: 'github://ronsaldo/abstract-gpu/tonel' ].
		spec
			package: #'SysmelMoebiusMetamodel-Core' with: [
				spec requires: #(#Slovim #PetitParser2Core)
			].
		spec
			package: #'SysmelMoebiusMetamodel-Core-Tests' with: [
				spec requires: #(#'SysmelMoebiusMetamodel-Core')
			].
		spec
			package: #'SysmelLanguage-Sysmel' with: [
				spec requires: #(#PetitParser2Core #'SysmelMoebiusMetamodel-Core')
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
			package: 'SysmelLanguage-SysmelPhanide' with: [
				spec requires: #('SysmelLanguage-Sysmel' 'Phanide')
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
	].
]
