class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super

        if option("Clang")
            moveFile("#{workDirectoryPath(false)}/Clang","#{mainWorkDirectoryPath(false)}/tools/clang")
        end

        if option("Compiler-Rt")
            moveFile("#{workDirectoryPath(false)}/Compiler-Rt","#{mainWorkDirectoryPath(false)}/projects/compiler-rt")
        end
    end
    
    def configure
        super

        runCmakeCommand([   "-DCMAKE_INSTALL_PREFIX=/usr",
                            "-DLLVM_ENABLE_FFI=ON",
                            "-DCMAKE_BUILD_TYPE=Release",
                            "-DLLVM_BUILD_LLVM_DYLIB=ON",
                            "-DLLVM_LINK_LLVM_DYLIB=ON",
                            "-DLLVM_ENABLE_RTTI=ON",
                            "-DLLVM_TARGETS_TO_BUILD=\"host;AMDGPU;BPF\"",
                            "-DLLVM_BINUTILS_INCDIR=/usr/include",
                            "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                            "-DCLANG_DEFAULT_PIE_ON_LINUX=ON",
                            "-Wno-dev -G Ninja .."],
                            buildDirectoryPath,
                            {"CC" => "gcc","CXX" => "g++"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin")

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        copyFile("#{buildDirectoryPath(false)}#{Ism.settings.rootPath}/bin/FileCheck","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/FileCheck")
    end

end
