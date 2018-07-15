Pod::Spec.new do |s|
  s.name = "MarkovModel"
  s.version = "1.0.0"
  s.summary = "Micro Feature"
  s.description = <<-DESC
                       MarkovModel is resposible for ...
                       DESC
  s.homepage = "https://db-in.com"
  s.documentation_url = "https://github.com/dineybomfim/MarkovModel/Documentation"
  s.license = { :type => "GPU", :file => "LICENSE" }
  s.author = 'Diney Bomfim'
  s.source = { :git => "https://github.com/dineybomfim/MarkovModel.git", :tag => "RELEASE-#{s.version}", :submodules => true }
  s.swift_version = '4.1'

  s.requires_arc = true
  s.ios.deployment_target = '10.0'

  s.public_header_files = 'MarkovModel/**/*.h'
  s.source_files = 'MarkovModel/**/*.{h,m,swift}'
  s.exclude_files = 'MarkovModel/**/Info.plist'

  s.ios.frameworks = 'Foundation'

end
