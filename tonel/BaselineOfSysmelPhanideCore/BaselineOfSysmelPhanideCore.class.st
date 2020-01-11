Class {
	#name : #BaselineOfSysmelPhanideCore,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmelPhanideCore
}

{ #category : #baselines }
BaselineOfSysmelPhanideCore >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'Sysmel' with: [
				spec
					repository: 'github://ronsaldo/sysmel/tonel' ].
		spec baseline: #'PhanideCore' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
		spec
			package: 'SysmelLanguage-SysmelPhanide' with: [
				spec requires: #(#'Sysmel' #'PhanideCore')
			].

	].
]
