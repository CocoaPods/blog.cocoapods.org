# blog.cocoapods.org

The blog for CocoaPods

## Setup

Run `bundle install` to get the project's dependencies    
Run `rake build` to build the site into the `_site` directory

## Development

Get started by running `rake init` this will install the submodules.
`rake dev` will start sass & jekyll running for development.
`rake end` will close the two processes.

This project uses two submodules,
   `_gh-pages` is the gh-pages of this repo. `rake deploy`` will push the built version of the site to that branch and push to the server pulling in any changes.
   `shared` is the cocoapods [shared resources](https://github.com/CocoaPods/shared_resources) repo that holds shared design notes and assets.

### License

This repository and CocoaPods are available under the MIT license.

