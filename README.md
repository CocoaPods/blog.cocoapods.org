# blog.cocoapods.org

The blog for CocoaPods

## Setup

Run `rake init` to install submodules and grab ruby dependencies

## Development

Get started by running `rake init` this will install the submodules.

One command to get dev up and running: `jekyll serve --watch`, after the initial `rake init`

This project uses two submodules:
   `_gh-pages` is the gh-pages of this repo. `rake deploy` will push the built version of the site to that branch and push to the server pulling in any changes.
   `shared` is the cocoapods [shared resources](https://github.com/CocoaPods/shared_resources) repo that holds shared design notes and assets.

## Deployment

Run `rake dpeloy` to push to site the gh-pages branch

### License

This repository and CocoaPods are available under the MIT license.

