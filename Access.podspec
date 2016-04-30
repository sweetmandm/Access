Pod::Spec.new do |s|

  s.name         = "Access"
  s.version      = "0.0.2"
  s.summary      = "Helpers and tools for UIAccessibility"

  s.description  = <<-DESC
  Building accessible apps is important! The goal of this project is to 
  collect a small suite of tools to make it easier to create an excellent 
  experience for users.
  DESC

  s.homepage = "http://github.com/sweetmandm/Access"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "David Sweetman" => "david@davidsweetman.com" }

  s.platform = :ios, "8.0"

  s.source = { :git => "https://github.com/sweetmandm/Access.git", :tag => "0.0.2" }

  s.source_files = "Access/**/*.{h,swift}"

  s.public_header_files = "Access/Access.h"

end
