cd "${SPRING_DIR}"

if [ ! ${LOCAL_BUILD} ]; then
    rm -rf "${BUILD_DIR}"
fi
mkdir -p "${BUILD_DIR}/bin-dir"

EXTRA_CMAKE_ARGS=()
if [ "${PLATFORM}" == "linux-64" ]; then
    WORKDIR=${LIBS_DIR}
    LIBDIR=$WORKDIR/lib
    INCLUDEDIR=$WORKDIR/include

    EXTRA_CMAKE_ARGS+=(
        -DPREFER_STATIC_LIBS:BOOL=1
        -DCMAKE_USE_RELATIVE_PATHS:BOOL=1
        -DBINDIR:PATH=./
        -DLIBDIR:PATH=./
        -DDATADIR:PATH=./
        -DMANDIR:PATH=share/man
        -DDOCDIR:PATH=doc
        -DOGG_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DOGG_LIBRARY=${LIBDIR}/libogg.a
        -DMINIZIP_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DMINIZIP_LIBRARY=${LIBDIR}/libminizip.a
        -DLZMA_LIBRARY=${LIBDIR}/liblzma.a
        -DLIBUUID_LIBRARY=${LIBDIR}/libuuid.a
        -DVORBIS_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DVORBISENC_LIBRARY=${LIBDIR}/libvorbisenc.a
        -DVORBISFILE_LIBRARY=${LIBDIR}/libvorbisfile.a
        -DVORBIS_LIBRARY=${LIBDIR}/libvorbis.a
        -DIL_IL_HEADER:PATH=${INCLUDEDIR}/IL/il.h
        -DIL_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DIL_IL_LIBRARY:PATH=${LIBDIR}/libIL.a
        -DIL_LIBRARIES:PATH=${LIBDIR}/libIL.a
        -DILU_LIBRARIES:PATH=${LIBDIR}/libILU.a
        -DGIF_LIBRARY:PATH=${LIBDIR}/libgif.a
        -DGIF_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DPNG_PNG_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DPNG_LIBRARY_RELEASE:PATH=${LIBDIR}/libpng.a
        -DJPEG_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DJPEG_LIBRARY:PATH=${LIBDIR}/libjpeg.a
        -DTIFF_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DTIFF_LIBRARY_RELEASE:PATH=${LIBDIR}/libtiff.a
        -DZLIB_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DZLIB_LIBRARY_RELEASE:PATH=${LIBDIR}/libz.a
        -DGLEW_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DGLEW_LIBRARIES:PATH=${LIBDIR}/libGLEW.a
        -DLIBUNWIND_INCLUDE_DIRS:PATH=${INCLUDEDIR}
        -DLIBUNWIND_LIBRARY:PATH=${LIBDIR}/libunwind.a
        -DCURL_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DCURL_LIBRARY:PATH="${LIBDIR}/libcurl.a;${LIBDIR}/libnghttp2.a"
        -DOPENSSL_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DOPENSSL_SSL_LIBRARY:PATH=${LIBDIR}/libssl.a
        -DOPENSSL_CRYPTO_LIBRARY:PATH=${LIBDIR}/libcrypto.a
        -DVORBIS_INCLUDE_DIR:PATH=${INCLUDEDIR}
        -DVORBISENC_LIBRARY:PATH=${LIBDIR}/libvorbisenc.a
        -DVORBISFILE_LIBRARY:PATH=${LIBDIR}/libvorbisfile.a
        -DVORBIS_LIBRARY:PATH=${LIBDIR}/libvorbis.a
    )
elif [ "${PLATFORM}" == "windows-64" ]; then
    EXTRA_CMAKE_ARGS+=(
        -DMINGWLIBS=${LIBS_DIR}
    )
fi

if [ ${ONLY_LEGACY} ]; then
    EXTRA_CMAKE_ARGS+=(
        -DBUILD_spring-headless=FALSE
        -DBUILD_spring-dedicated=FALSE
    )
fi

cd "${BUILD_DIR}"
cmake \
    -DCMAKE_TOOLCHAIN_FILE="/scripts/${PLATFORM}.cmake" \
    -DMARCH_FLAG="${MYARCHTUNE}" \
    -DCMAKE_CXX_FLAGS="${MYCFLAGS}" \
    -DCMAKE_C_FLAGS="${MYCFLAGS}" \
    -DCMAKE_CXX_FLAGS_${MYBUILDTYPE}="${MYBUILDTYPEFLAGS}" \
    -DCMAKE_C_FLAGS_${MYBUILDTYPE}="${MYBUILDTYPEFLAGS}" \
    -DCMAKE_BUILD_TYPE="${MYBUILDTYPE}" \
    -DAI_TYPES=NATIVE \
    -DCMAKE_INSTALL_PREFIX:PATH="${INSTALL_DIR}" \
    -DUSERDOCS_PLAIN=ON \
    -DINSTALL_PORTABLE=ON \
    -DWITH_MAPCOMPILER=OFF \
    -DAI_EXCLUDE_REGEX="^CppTestAI$" \
    "${EXTRA_CMAKE_ARGS[@]}" \
    "${SPRING_DIR}"
