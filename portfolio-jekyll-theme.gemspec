# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "fotis-portfolio"
  spec.version       = "0.0.1"
  spec.authors       = ["Fotis Tsokos"]
  spec.email         = ["fotisdtsokos@gmail.com"]

  spec.summary       = "My awesome portfolio website"
  spec.homepage      = "https://github.com/chocof/chocof.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|CHANGELOG)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.6"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.3"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.6"

end
