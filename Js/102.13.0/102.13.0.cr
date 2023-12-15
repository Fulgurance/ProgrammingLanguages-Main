class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "obj"
        super

    end
    
    def configure
        super

        runScript(  "../js/src/configure.in",
                    [   "--prefix=/usr",
                        "--with-intl-api",
                        "--with-system-zlib",
                        "--with-system-icu",
                        "--disable-jemalloc",
                        "--disable-debug-symbols",
                        "--enable-readline"],
                        buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

    def install
        super

    end

    def clean
        super

        deleteFile("#{Ism.settings.rootPath}usr/lib/libjs_static.ajs")
    end

end
