# Contributing

Any contribution is welcome.  
Please read the [CycloneDX contributing guidelines](https://github.com/CycloneDX/.github/blob/master/CONTRIBUTING.md) first.

Pull-requests from forks are welcome.  
We love to see your purposed changes, but we also like to discuss things first. Please open a [ticket][📜src-gh] and explain your intended changes to the community. And don't forget to mention that discussion in your pull-request later. 
Find the needed basics here:
* [how to fork a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
* [how create a pull request from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork)
* Remember to [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] if you make changes.

## Setup

This project uses ruby. Have a recent version installed and setup first.

To install dev-dependencies and tools:

```shell
bin/setup
```

## Environment Variables for Local Development

Below are the primary environment variables recognized by stone_checksums (and its integrated tools). Unless otherwise noted, set boolean values to the string "true" to enable.

General/runtime
- MIMIC_NEXT_MAJOR_VERSION: When set to true, simulates the next major version for testing breaking changes [📌semver-breaking] [📌major-versions-not-sacred] (default: false)
- ARUBA_NO_COVERAGE: Disable SimpleCov coverage in Aruba tests (default: false)

For a quick starting point, this repository’s `.envrc` shows sane defaults, and `.env.local` can override them locally.

## Testing

To run all tests

```console
bundle exec rake test
```

Or use the default task, which does the same

```console
bundle exec rake
```

### Spec organization (required)

- One spec file per class/module. For each class or module under `lib/`, keep all of its unit tests in a single spec file under `spec/` that mirrors the path and file name exactly: `lib/cyclonedx/my_class.rb` -> `spec/cyclonedx/my_class_spec.rb`.
- Exception: Integration specs that intentionally span multiple classes. Place these under `spec/integration/` (or a clearly named integration folder), and do not directly mirror a single class. Name them after the scenario, not a class.

## Lint It

Run the linter.

```console
bundle exec rake rubocop
```

### Important: Do not add inline RuboCop disables

Try not to add `# rubocop:disable ...` / `# rubocop:enable ...` comments to code or specs (except when following the few existing `rubocop:disable` patterns for a rule already being disabled elsewhere in the code). Instead:

- Prefer configuration-based exclusions when a rule should not apply to certain paths or files (e.g., via `.rubocop.yml`).
  - `bundle exec rubocop -a` (preferred)
  - `bundle exec rubocop --regenerate-todo` (only when you cannot fix the violations immediately)

As a general rule, fix style issues rather than ignoring them. For example, our specs should follow RSpec conventions like using `described_class` for the class under test.

## Sign off your commits

Please sign off your commits, to show that you agree to publish your changes under the current terms and licenses of the project
, and to indicate agreement with [Developer Certificate of Origin (DCO)](https://developercertificate.org/).

```shell
git commit --signed-off ...
```

## Contributors

Your picture could be here!

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

## For Maintainers

### To release a new version:

#### Automated process

Coming Soon!

#### Manual process

1. Run `bin/setup && bin/rake` as a "test, coverage, & linting" sanity check
2. Update the version number in `version.rb`, and ensure `CHANGELOG.md` reflects changes
3. Run `bin/setup && bin/rake` again as a secondary check, and to update `Gemfile.lock`
4. Run `git commit -am "🔖 Prepare release v<VERSION>"` to commit the changes
5. Run `git push` to trigger the final CI pipeline before release, and merge PRs
    - NOTE: Remember to [check the build][🧪build].
6. Run `export GIT_TRUNK_BRANCH_NAME="$(git remote show origin | grep 'HEAD branch' | cut -d ' ' -f5)" && echo $GIT_TRUNK_BRANCH_NAME`
7. Run `git checkout $GIT_TRUNK_BRANCH_NAME`
8. Run `git pull origin $GIT_TRUNK_BRANCH_NAME` to ensure latest trunk code
9. Optional for older Bundler (< 2.7.0): Set `SOURCE_DATE_EPOCH` so `rake build` and `rake release` use the same timestamp and generate the same checksums
    - If your Bundler is >= 2.7.0, you can skip this; builds are reproducible by default.
    - Run `export SOURCE_DATE_EPOCH=$EPOCHSECONDS && echo $SOURCE_DATE_EPOCH`
    - If the echo above has no output, then it didn't work.
    - Note: `zsh/datetime` module is needed, if running `zsh`.
    - In older versions of `bash` you can use `date +%s` instead, i.e. `export SOURCE_DATE_EPOCH=$(date +%s) && echo $SOURCE_DATE_EPOCH`
10. Run `bundle exec rake build`
11. Run `bundle exec rake release` which will create a git tag for the version,
    push git commits and tags, and push the `.gem` file to the gem host configured in the gemspec.
12. Run `bin/gem_checksums` (more context [1][🔒️rubygems-checksums-pr], [2][🔒️rubygems-guides-pr])
    to create SHA-256 and SHA-512 checksums. This functionality is provided by the `stone_checksums`
    [gem][💎stone_checksums].
    - The script automatically commits but does not push the checksums
13. Sanity check the SHA256, comparing with the output from the `bin/gem_checksums` command:
    - `sha256sum pkg/<gem name>-<version>.gem`

[📜src-gh]: https://github.com/CycloneDX/cyclonedx-ruby-gem
[🧪build]: https://github.com/CycloneDX/cyclonedx-ruby-gem/actions
[🤝conduct]: https://gitlab.com/CycloneDX/cyclonedx-ruby-gem/-/blob/main/CODE_OF_CONDUCT.md
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/CycloneDX/cyclonedx-ruby-gem/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=CycloneDX/cyclonedx-ruby-gem
[💎gem-coop]: https://gem.coop
[🔒️rubygems-security-guide]: https://guides.rubygems.org/security/#building-gems
[🔒️rubygems-checksums-pr]: https://github.com/rubygems/rubygems/pull/6022
[🔒️rubygems-guides-pr]: https://github.com/rubygems/guides/pull/325
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[🏃‍♂️runner-tool-cache]: https://github.com/ruby/ruby-builder/releases/tag/toolcache
