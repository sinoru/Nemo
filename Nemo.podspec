#
#  Nemo.podspec
#  Nemo
#
#  Created by Sinoru on 2015. 8. 11..
#  Copyright © 2015-2017 Sinoru. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#  http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

Pod::Spec.new do |s|
  s.name         = "Nemo"
  s.version      = "1.1.1"
  s.summary      = "Photos Menu Framework for iOS"

  s.description  = <<-DESC
                   Nemo is a photos picker menu framework for iOS
                   DESC

  s.homepage     = "https://github.com/sinoru/Nemo"

  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

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
