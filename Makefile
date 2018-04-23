defn_dir=.build
defn_files=$(defn_dir)/dai-core.k

defn: $(defn_files)


.build/%.k: %.md
	mkdir -p $(defn_dir)
	@echo "==  tangle: $@"
	pandoc --from markdown --to tangle.lua --metadata=code:k $< > $@

build: defn
	kompile .build/dai-core.k --debug --main-module DAI-CORE --syntax-module DAI-CORE
