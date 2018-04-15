defn_dir=.build
defn_files=$(defn_dir)/dai-core.k $(defn_dir)/dai.k

defn: $(defn_files)


.build/%.k: %.md
	mkdir -p $(defn_dir)
	@echo "==  tangle: $@"
	pandoc --from markdown --to tangle.lua --metadata=code:k $< > $@

build: defn
	kompile .build/dai.k --debug --main-module DAI --syntax-module DAI
