Gem::Specification.new do |s|
  s.name          = 'chili'
  s.version       = '0.1.0'
  s.date          = '2014-04-15'
  s.summary       = "Chili VPD Service"
  s.description   = "Contains methods to communicate via savon and mapping via happymapper. Also uses Docsplit to split out PDF pages."
  s.authors       = ["Andrew Humbert"]
  s.email         = 'a.humbert@tukaiz.com'
  s.homepage      = 'https://github.com/Tukaiz/chili'

  s.files         = Dir["{lib}/**/*"]

  s.add_dependency "nokogiri", [">= 1.5.0"]
  s.add_dependency "happymapper", ["= 0.4.1"]
  s.add_dependency "nori", ["= 2.4.0"]

  s.add_dependency "savon", ["= 0.7.8"]

  s.add_dependency "docsplit", ["= 0.7.4"]
end