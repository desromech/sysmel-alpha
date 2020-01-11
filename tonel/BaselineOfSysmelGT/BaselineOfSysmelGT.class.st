Class {
	#name : #BaselineOfSysmelGT,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmelGT
}

{ #category : #baselines }
BaselineOfSysmelGT >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'SysmelPhanideCore' with: [
				spec
					repository: 'github://ronsaldo/sysmel/tonel' ].
		spec baseline: #'PhanideGT' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].
	].
]
