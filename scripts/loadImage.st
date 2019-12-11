Metacello new
  baseline: 'Sysmel';
  repository: 'gitlocal://tonel';
  load.

"Save the image"
(Smalltalk saveAs: 'sysmel')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
