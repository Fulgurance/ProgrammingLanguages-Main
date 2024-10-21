class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr  \
                                        --enable-shared \
                                        --without-ensurepip",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr      \
                                        --enable-shared     \
                                        --with-system-expat \
                                        --with-system-ffi   \
                                        --enable-optimizations",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if !option("Pass1")
            makeLink(   target: "python3",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/python",
                        type:   :symbolicLink)

            makeLink(   target: "pip3",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/pip",
                        type:   :symbolicLink)
        end
    end

end
