CUR_DIR = $(CURDIR)

env.testing:
	echo 'BASE_URL="http://0.0.0.0:8080"' > .env.testing
	echo 'BASE_PATH="$(CUR_DIR)/"' >> .env.testing
	
test: env.testing
	swift test --enable-test-discovery
