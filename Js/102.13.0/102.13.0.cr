class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "obj"
        super

    end
    
    def configure
        super

        runFile(file:       "../js/src/configure.in",
                arguments:  "--prefix=/usr          \
                            --with-intl-api         \
                            --with-system-zlib      \
                            --with-system-icu       \
                            --disable-jemalloc      \
                            --disable-debug-symbols \
                            --enable-readline",
                path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

    def install
        super

    end

    def clean
        super

        deleteFile("#{Ism.settings.rootPath}usr/lib/libjs_static.ajs")
    end

end
