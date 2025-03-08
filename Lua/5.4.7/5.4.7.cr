class Target < ISM::Software
    
    def prepare
        super

        luaData = <<-CODE
        V=5.4
        R=5.4.7

        prefix=/usr
        INSTALL_BIN=${prefix}/bin
        INSTALL_INC=${prefix}/include
        INSTALL_LIB=${prefix}/lib
        INSTALL_MAN=${prefix}/share/man/man1
        INSTALL_LMOD=${prefix}/share/lua/${V}
        INSTALL_CMOD=${prefix}/lib/lua/${V}
        exec_prefix=${prefix}
        libdir=${exec_prefix}/lib
        includedir=${prefix}/include

        Name: Lua
        Description: An Extensible Extension Language
        Version: ${R}
        Requires:
        Libs: -L${libdir} -llua -lm -ldl
        Cflags: -I${includedir}
        CODE
        fileWriteData("#{buildDirectoryPath}/lua.pc",luaData)
    end
    
    def build
        super

        makeSource( arguments: "linux",
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} \
                                INSTALL_TOP=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr \
                                INSTALL_DATA=\"cp -d\" \
                                INSTALL_MAN=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/man/man1 \
                                TO_LIB=\"liblua.so liblua.so.5.4 liblua.so.5.4.7\" \
                                install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig")

        copyFile(   "#{buildDirectoryPath}/lua.pc",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig/lua.pc")
    end

end
