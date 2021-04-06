(#(windows uwp osx) includes: self platform name) ifTrue: [
    self externalLibrary: 'freetype' buildWith: [:builder |
        builder
            sourceDirectory: 'freetype-2.10.4';
            useSeparateBuildDirectory;
            useCMakeReleaseMode;
            configureWithCMakeFlags: '-D BUILD_SHARED_LIBS=YES';
            buildWithCMake;
            installWithCMake
    ].
].

self platform name selectCase: {
    #linux -> [
        self importLibrary: 'freetype' fromDebianPackage: 'libfreetype6-dev'.
    ].
    [true] -> []
}.
