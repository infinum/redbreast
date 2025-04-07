# Redbreast

<p align="center">
    <img src="redbreast.svg" width="300" max-width="50%" alt="Japx"/>
</p>

iOS strong image typing library

## Description

Redbreast is a gem used for generating extensions (categories) of UIImage or UIColor. In Swift it creates computed properties of images or colors that are in your assets folder. While in Objective-C it creates static methods that returns UIImage or UIColor object.

## Table of contents

* [Getting started](#getting-started)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)
* [Credits](#credits)

## Getting started

Add this line to your application's Gemfile:

```ruby
gem 'redbreast'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redbreast

## Usage

### Init

After installing redbreast run `redbreast init` to create `.redbreast.yml` file. This file is used for generating your extensions.
In the init you will be prompted to:

* Choose a language in which colors/images will be generated.
* Input the application name (optional)
* Input bundle names (default is main)
* Input whether you want to omit namespacing (optional)
* Choose whether you want to generate images, colors or both
* Input the path to assets folder
* Input the path where the files will be created
* Choose to create tests for generated assets

This is how your `.redbreast.yml` file should look after the `redbreast init` if you are using version 1.3.1 and lower:

```yml
---
:language: swift
:bundles:
- :name: main
  :reference: ".main"
  :shouldOmitNamespace: false
  :assetsSearchPath: "MyProject/**/*.xcassets"
  :outputSourcePathImages: "./MyProject/Common/Extensions/UIImage+Redbreast.swift"
  :outputSourcePathColors: "./MyProject/Common/Extensions/UIColor+Redbreast.swift"
  :outputTestPathImages: "./MyProject-UnitTests/Common/Extensions/UIImageExtensionTest.swift"
  :outputTestPathColors: "./MyProject-UnitTests/Common/Extensions/UIColorExtensionTest.swift"
  :testableImport: MyProject
:app_name: MyProject
```

Multiple language support is available from version 1.4.0. Example `.redbreast.yml` files from version 1.4.0 and higher:

If you are using only one language:

```yml
---
:bundles:
- :language: swift
  :name: main
  :reference: ".main"
  :assetsSearchPath: "MyProject/**/*.xcassets"
  :outputSourcePathImages: "./MyProject/Common/Extensions/UIImage+Redbreast.swift"
  :outputSourcePathColors: "./MyProject/Common/Extensions/UIColor+Redbreast.swift"
  :outputTestPathImages: "./MyProject-UnitTests/Common/Extensions/UIImageExtensionTest.swift"
  :outputTestPathColors: "./MyProject-UnitTests/Common/Extensions/UIColorExtensionTest.swift"
  :testableImport: MyProject
:app_name: MyProject
```

and if you are using two or more languages:

```yml
---
:bundles:
- :language: swift
  :name: main
  :reference: ".main"
  :assetsSearchPath: "**/*.xcassets"
  :outputSourcePathImages: ".MyProject/Common/Extensions/UIImageExtension.swift"
  :outputTestPathImages: ".MyProject/Common/Extensions/UIImageExtensionTest.swift"
  :testableImport: MyProject
- :language: swiftui
  :name: MyProjectUI
  :reference: ".MyProjectUI"
  :assetsSearchPath: "MyProject/**/*.xcassets"
  :outputSourcePathImages: ".MyProject/Common/Extensions/ImageExtension.swift"
  :outputSourcePathColors: ".MyProject/Common/Extensions/ColorExtension.swift"
  :outputTestPathImages: ".MyProject/Common/Extensions/ImageExtensionTest.swift"
  :outputTestPathColors: ".MyProject/Common/Extensions/ColorExtensionTest.swift"
  :testableImport: MyProject
:app_name: MyProject
```

### Generate

When you finish creating `.redbreast.yml` file,  run `redbreast generate` and all needed files will be generated.

### Install

Command `redbreast install` will setup a file generator in your project and whenever you build it, it will create new image/color names. 

In this example we will show how will your extensions (catergories) look like after using Redbreast.

Lets say this is how your *Images.xcassets* folder looks like:

```
Images.xcassets
    └── App // namespaced
    │    └── Admin // namespaced
    │    │   └── Report.imageset
    │    │   └── User.imageset
    │    └── Course
    │        └── Assignment.imageset
    │
    └── AppLogo.imageset
    │
    └── Arrows
        └── DownArrow.imageset
```

*App* and *Admin* are namespaced folders while *Course* and *Arrows* are not. If a folder is namespaced, enum with that folder name will appear in the exension and path to that image will contain folder name. In the other case, folders are ignored and images belong to the last namespaced folder.

Redbreast will generate a file similar to this one varying on app name (more in Usage chapter). As you can see *Arrows* folder is not namespaced so there isn't an enum called *Arrows*. Because of this *downArrow* is in root of extension and is accessed by writing `UIImage.downArrow`. *Report* image is in two namespaced folders (*App* and *Admin*) so path for it is *App/Admin* and it located inside both enums. *Report* is accessed by `UIImage.App.Admin.report`.

```swift
extension UIImage {

  static var appLogo: UIImage { return UIImage(named: "AppLogo", in: .main, compatibleWith: nil)! }
  static var downArrow: UIImage { return UIImage(named: "DownArrow", in: .main, compatibleWith: nil)! }

  enum App {

    enum Admin {
      static var report: UIImage { return UIImage(named: "App/Admin/Report", in: .main, compatibleWith: nil)! }
      static var user: UIImage { return UIImage(named: "App/Admin/User", in: .main, compatibleWith: nil)! }
    }
              
  static var assignment: UIImage { return UIImage(named: "App/Assignment", in: .main, compatibleWith: nil)! }
  }
}
```

In Objective-C .h and .m files are generated. Because enums don't exist in Objc folder names are used in method name instead. Everything else is the same as in Swift.
```objc
@implementation UIImage (ApplicationName)

+ (UIImage *)appLogo
{
    return [UIImage imageNamed:@"AppLogo" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage *)downArrow
{
    return [UIImage imageNamed:@"DownArrow" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage *)appAdminReport
{
    return [UIImage imageNamed:@"App/Admin/Report" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage *)appAdminUser
{
    return [UIImage imageNamed:@"App/Admin/User" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
}

+ (UIImage *)appAssignment
{
    return [UIImage imageNamed:@"App/Assignment" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
}

@end
```

For more examples checkout the sample project.

## Contributing

We believe that the community can help us improve and build better a product.
Please refer to our [contributing guide](CONTRIBUTING.md) to learn about the types of contributions we accept and the process for submitting them.

To ensure that our community remains respectful and professional, we defined a [code of conduct](CODE_OF_CONDUCT.md) <!-- and [coding standards](<link>) --> that we expect all contributors to follow.

We appreciate your interest and look forward to your contributions.

## License

```text
Copyright 2024 Infinum

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Credits

Maintained and sponsored by [Infinum](https://infinum.com).

<div align="center">
    <a href='https://infinum.com'>
    <picture>
        <source srcset="https://assets.infinum.com/brand/logo/static/white.svg" media="(prefers-color-scheme: dark)">
        <img src="https://assets.infinum.com/brand/logo/static/default.svg">
    </picture>
    </a>
</div>
