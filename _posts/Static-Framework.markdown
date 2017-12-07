### Static Frameworks

Source static frameworks is powerful new feature of CocoaPods 1.4.0. For the first time, it is
possible to distribute source CocoaPods and require that they be built into a static framework
when `use_frameworks!` is specified in the Podfile. Because dynamic libraries cannot depend
upon static libraries, it now becomes possible to distribute CocoaPods that depend upon
other static library frameworks, including the many static frameworks that are
released as vendored_frameworks.

#### Background

A *framework* is a collection of a library, headers and resources. The library may be either
dynamic or static. A *static library* is linked at build time. A *dynamic library* is linked
and loaded at runtime.

A dynamic library cannot depend on a static library because a static library may
not have the necessary relocations to be loaded at runtime and because if multiple
dynamic libraries depended upon the same static library, there would be multiple
copies of the static library. The multiple copies is only a code size issue for
the code itself, but it will lead to functionality issues for any data in the
static library.

When Apple and Xcode refer to *frameworks*, dynamic is typically implied. However, the lower
level Apple build tools work correctly with both dynamic and static frameworks.

Historically many binary CocoaPods have been distributed as a vendored_framework
that includes a static library.

Before 1.4.0, source CocoaPods could only be built as dynamic frameworks. Therefore,
it was not possible to depend on many vendored_framework CocoaPods. Also, it was
not possible for a vendor who delivered their CocoaPod as a binary CocoaPod to
convert it to a source CocoaPod and keep it as a static framework.

#### Usage

Add the following to the podspec file:

```ruby
s.static_framework = true
```