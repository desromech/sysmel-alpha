Class {
	#name : #BaselineOfSysmelIDE,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmelIDE
}

{ #category : #baselines }
BaselineOfSysmelIDE >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'SysmelPhanideCore' with: [
				spec
					repository: 'github://ronsaldo/sysmel/tonel' ].
		spec baseline: #'Phanide' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
	].
]
