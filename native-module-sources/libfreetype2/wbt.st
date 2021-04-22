(#(windows uwp osx) includes: self platform name) ifTrue: [
    self externalLibrary: 'freetype' buildWith: [:builder |
        builder
            sourceDirectory: 'freetype-2.10.4';
            useSeparateBuildDirectory;
            useCMakeReleaseMode;
            configureWithCMakeFlags: #(
                '-D CMAKE_DISABLE_FIND_PACKAGE_HarfBuzz=YES'
                '-D CMAKE_DISABLE_FIND_PACKAGE_PNG=YES'
                '-D CMAKE_DISABLE_FIND_PACKAGE_ZLIB=YES'
                '-D CMAKE_DISABLE_FIND_PACKAGE_BZIP2=YES'
                '-D CMAKE_DISABLE_FIND_PACKAGE_BROTLI=YES'
                '-D BUILD_SHARED_LIBS=YES'
                );
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
