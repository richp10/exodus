# Makefile for building libidn.dll for jabber projects
#
# Depends on having a pre-built libidn someplace.
# Use mingw/msys to build this DLL. 

IDN_DIR=../../libidn-0.5.6

CUR_DIR=`pwd`

LIB_DIR=${IDN_DIR}/lib
LIB_IDN=${LIB_DIR}/.libs/libidn.a

IDN_OBJECTS=${LIB_DIR}/idn-free.o\
	${LIB_DIR}/idna.o\
	${LIB_DIR}/nfkc.o\
	${LIB_DIR}/pr29.o\
	${LIB_DIR}/profiles.o\
	${LIB_DIR}/punycode.o\
	${LIB_DIR}/rfc3454.o\
	${LIB_DIR}/strerror-idna.o\
	${LIB_DIR}/strerror-pr29.o\
	${LIB_DIR}/strerror-punycode.o\
	${LIB_DIR}/strerror-stringprep.o\
	${LIB_DIR}/strerror-tld.o\
	${LIB_DIR}/stringprep.o\
	${LIB_DIR}/tld.o\
	${LIB_DIR}/tlds.o\
	${LIB_DIR}/toutf8.o\
	${LIB_DIR}/version.o

CFLAGS+=-c -I${LIB_DIR}
OBJECTS=jabber.o

all: ${LIB_IDN} ${OBJECTS}
	dllwrap --dllname=libidn.dll --export-all-symbols\
	${IDN_OBJECTS} ${OBJECTS}

${LIB_IDN}: 
	cd ${IDN_DIR} && ./configure && make clean && make

clean: 
	rm -rf *.dll
	rm -rf *.o