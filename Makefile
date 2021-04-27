CUR_DIR = $(CURDIR)

run:
	swift run Feather

env:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/"' >> .env.development
	
env.testing:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/"' >> .env.testing
	
clean:
	rm -rf ./Resources/ ./Public/

test: env.testing
	swift test --enable-test-discovery

install:
	swift package update
	swift build -c release
	install .build/Release/Feather ./feather #./usr/local/bin/feather

uninstall:
	rm Public/css/frontend.min.css
	rm ./feather
