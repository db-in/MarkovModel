Pod::Spec.new do |s|
  s.name = "MarkovModel"
  s.version = "1.0.2"
  s.summary = "Micro Feature"
  s.description = <<-DESC
                       MarkovModel is a Swift framework that uses the power of Markov Model to process and calculate states in a known system.
                       DESC
  s.homepage = "http://blog.db-in.com/"
  s.documentation_url = "https://db-in.github.io/MarkovModel/"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = 'Diney Bomfim'
  s.source = { :git => "https://github.com/db-in/MarkovModel.git", :tag => s.version, :submodules => true }
  s.swift_version = '4.1'

  s.requires_arc = true
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.public_header_files = 'MarkovModel/**/*.h'
  s.source_files = 'MarkovModel/**/*.{h,m,swift}'
  s.exclude_files = 'MarkovModel/**/Info.plist'

  s.ios.frameworks = 'Foundation'

end
