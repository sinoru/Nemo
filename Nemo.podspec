Pod::Spec.new do |s|
  s.name         = "Nemo"
  s.version      = "0.9.2"
  s.summary      = "Photos Menu Framework for iOS"

  s.description  = <<-DESC
                   Nemo is a photos picker menu framework for iOS
                   DESC

  s.homepage     = "https://github.com/sinoru/Nemo"

  s.license      = { :type => "BSD", :file => "LICENSE" }

  s.author       = { "Jaehong Kang" => "sinoru@me.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/sinoru/Nemo.git", :tag => s.version.to_s }

  s.source_files  = "Nemo/*.{h,m,swift}", "Nemo/**/*.{h,m,swift}"
  s.exclude_files = "NemoExample"

  s.public_header_files = "Nemo/Nemo.h"

  s.resources = "Nemo/en.lproj", "Nemo/ja.lproj", "Nemo/ko.lproj"

  s.frameworks = "UIKit", "Photos"

  s.requires_arc = true
end
