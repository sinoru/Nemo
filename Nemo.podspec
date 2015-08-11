Pod::Spec.new do |s|
  s.name         = "Nemo"
  s.version      = "0.9"
  s.summary      = "Photos Menu Framework for iOS"

  s.description  = <<-DESC
                   Nemo is a photos picker menu framework for iOS
                   DESC

  s.homepage     = "https://github.com/sinoru/Nemo"

  s.license      = { :type => "BSD", :file => "LICENSE" }

  s.author             = { "Jaehong Kang" => "sinoru@me.com" }

  s.source       = { :git => "https://github.com/sinoru/Nemo.git", :tag => s.version.to_s }

  s.source_files  = "Nemo/*.{h,m,swift}", "Nemo/**/*.{h,m,swift}"
  s.exclude_files = "NemoExample"

  s.public_header_files = "Nemo/Nemo.h"

  s.resources = "Nemo/en.lproj", "Nemo/ja.lproj", "Nemo/ko.lproj"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  s.frameworks = "UIKit", "Photos"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
