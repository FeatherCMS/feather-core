env.testing:
	echo 'FEATHER_WORK_DIR="$(CUR_DIR)/Tests/"' > .env.testing
	echo 'FEATHER_HTTPS=false' >> .env.testing
		
clean.testing:
	rm -rf ./Tests/Resources/ ./Tests/Public/

test: clean.testing env.testing
	swift test

# gem install jazzy
# gem install --user-install ffi -- --enable-libffi-alloc

docs:
	jazzy \
  --clean \
  --author "Tibor Bödecs" \
  --author_url https://twitter.com/tiborbodecs/ \
  --module-version 0.0.1 \
  --module FeatherCore \
  --output docs/
  
