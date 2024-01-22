class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--enable-shared",
                                "--without-ensurepip",
                                "--disable-test-modules"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--enable-shared",
                                "--with-system-expat",
                                "--with-system-ffi",
                                "--enable-optimizations",
                                "--disable-test-modules"],
                                buildDirectoryPath)
        end
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

        if !option("Pass1")
            makeLink("python3","#{Ism.settings.rootPath}usr/bin/python",:symbolicLink)
        end
    end

end
