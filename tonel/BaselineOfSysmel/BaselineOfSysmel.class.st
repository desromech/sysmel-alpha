Class {
	#name : #BaselineOfSysmel,
	#superclass : #BaselineOf,
	#category : #BaselineOfSysmel
}

{ #category : #baselines }
BaselineOfSysmel >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: 'PetitParser2Core' with: [
				spec
					repository: 'github://kursjan/petitparser2' ].
		spec baseline: 'Slovim' with: [
				spec
					repository: 'github://ronsaldo/slovim/tonel' ].
		spec baseline: 'Phanide' with: [
				spec
					repository: 'github://ronsaldo/phanide/tonel' ].

		spec
			package: 'Sysmel-Parser' with: [
				spec requires: #(PetitParser2Core 'Sysmel-Metamodel')
			].
		spec
			package: 'Sysmel-ImageFormat' with: [
				spec requires: #(Slovim)
			].
		spec
			package: 'Sysmel-Metamodel' with: [
				spec requires: #('Slovim' 'Sysmel-ImageFormat')
			].
		spec
			package: 'Sysmel-Tests' with: [
				spec requires: #('Sysmel-Parser' 'Sysmel-Metamodel')
			].
		spec
			package: 'Sysmel-Phanide' with: [
				spec requires: #('Sysmel-Parser' 'Sysmel-Metamodel' 'Phanide')
			].
	].
]
