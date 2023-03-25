class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/firefox-78.13.0","#{workDirectoryPath(false)}/firefox-78.13.0esr.source")
    end

    def prepare
        @buildDirectory = true
        @buildDirectoryName = "obj"
        super
    end
    
    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--with-intl-api",
                            "--with-system-zlib",
                            "--with-system-icu",
                            "--disable-jemalloc",
                            "--disable-debug-symbols",
                            "--enable-readline"],
                            buildDirectoryPath,
                            "js/src",
                            {"CC" => "gcc",
                             "CXX" => "g++"})
    end
    
    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

    def install
        super

    end

    def clean
        super

        deleteFile("#{Ism.settings.rootPath}usr/lib/libjs_static.ajs")
    end

end
