# default target: build if necessary and run tests
test: install-cleo
	go test -v ./...

# only necessary if you need to re-generate the c-go bindings
# Note: deletes all previously generated c-go bindings and
# any build
re-generate: clean_generated
	c-for-go --ccincl leopard.yml

# init leopard submodule and build C library
# install library to $INSTALL_DIR (defaults to /usr/local/lib)
INSTALL_DIR ?= D:\mingw-w64\mingw64\lib
build-cleo:
	git submodule update --init --recursive
	cd leopard/build && cmake ../leopard -D"CMAKE_MAKE_PROGRAM:PATH=D:/mingw-w64/mingw64/bin/make.exe"
	cd leopard/build && make

install-cleo: build-cleo
	cp leopard/build/liblibleopard.a $(INSTALL_DIR)/

# clean generated files and build artifacts
clean_generated:
	rm -f leopard/cgo_helpers.go leopard/cgo_helpers.h leopard/cgo_helpers.c
	rm -f leopard/const.go leopard/doc.go leopard/types.go
	rm -f leopard/leopard.go

clean_build:
	rm -rf leopard/build

uninstall-cleo:
	rm $(INSTALL_DIR)/liblibleopard.a