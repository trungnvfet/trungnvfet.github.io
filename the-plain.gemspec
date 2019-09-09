Gem::Specification.new do |spec|
	spec.name          = "trungnvfet.github.io"
	spec.version       = "4.0.0"
	spec.authors       = ["Nguyen Van Trung"]
	spec.email         = ["trungnvfet@outlook.com"]

	spec.summary       = "A minimalist Jekyll theme"
	spec.homepage      = "https://github.com/trungnvfet/trungnvfet.github.io"
	spec.license       = "MIT"

	spec.metadata["plugin_type"] = "theme"

	spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|(LICENSE|README)((\.(txt|md|markdown)|$)))!i) }

	spec.add_runtime_dependency "jekyll", ">= 3.8", "< 5.0"

	spec.add_development_dependency "bundler", "~> 2.0.2"
	spec.add_development_dependency "rake", "~> 12.0"
end

