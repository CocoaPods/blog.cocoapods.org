# blog.cocoapods.org

The blog for CocoaPods

## Setup

Run `rake init` to install submodules and grab ruby dependencies.

## Development

One command to get dev up and running: `rake run`, after the initial `rake init`

The `shared` submodule is the cocoapods [shared
resources](https://github.com/CocoaPods/shared_resources) repo that holds
shared design notes and assets.

## Deployment

Run `rake deploy` to push to site the gh-pages branch.

The `_gh-pages` folder (which is ignored) is used to checkout the gh-pages of
this repo. `rake deploy` will push the built version of the site to that branch
and push to the server pulling in any changes.

### License

This repository and CocoaPods are available under the MIT license.

