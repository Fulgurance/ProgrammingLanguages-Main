class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --disable-rpath         \
                                    --enable-shared         \
                                    --without-valgrind      \
                                    --without-baseruby      \
                                    ac_cv_func_qsort_r=no   \
                                    --disable-install-doc   \
                                    --disable-install-rdoc  \
                                    --disable-install-capi",
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

end
