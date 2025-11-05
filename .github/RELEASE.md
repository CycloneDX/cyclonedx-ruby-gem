# Release Process

This repository uses an automated release pipeline via GitHub Actions.

## How It Works

The release workflow (`.github/workflows/release.yml`) is triggered when a version tag is pushed to the repository. The workflow:

1. **Runs tests** - Ensures all tests pass before releasing
2. **Builds the gem** - Creates the `.gem` package using `bundle exec rake build`
3. **Generates checksums** - Creates SHA-512 checksums for the gem package
4. **Creates GitHub Release** - Publishes a release on GitHub with the gem and checksums as artifacts
5. **Publishes to RubyGems** - Automatically pushes the gem to [rubygems.org](https://rubygems.org)

## Triggering a Release

### For Stable Releases

1. Update the version in `lib/cyclonedx/ruby/version.rb`
2. Update `CHANGELOG.md` with the changes
3. Commit the changes: `git commit -am "🔖 Prepare release v1.2.0"`
4. Create and push a tag: `git tag v1.2.0 && git push origin v1.2.0`

### For Prereleases

Prereleases follow the same process but use a tag with a prerelease identifier:

- Alpha: `git tag v1.3.0-alpha.1 && git push origin v1.3.0-alpha.1`
- Beta: `git tag v1.3.0-beta.1 && git push origin v1.3.0-beta.1`
- Release Candidate: `git tag v1.3.0-rc.1 && git push origin v1.3.0-rc.1`

Prereleases are automatically detected by the workflow and marked as "prerelease" on GitHub.

## Version Tag Format

- **Stable releases**: `v<MAJOR>.<MINOR>.<PATCH>` (e.g., `v1.2.0`)
- **Prereleases**: `v<MAJOR>.<MINOR>.<PATCH>-<PRERELEASE>` (e.g., `v1.3.0-alpha.1`)

The version in the tag must match the version in `lib/cyclonedx/ruby/version.rb`.

## Required Secrets

The workflow requires the following GitHub repository secret to be configured:

### `RUBYGEMS_API_KEY`

This is your RubyGems API key for publishing gems. To set it up:

1. Generate an API key on [rubygems.org](https://rubygems.org/profile/edit):
   - Go to your profile → Edit Profile → API Keys
   - Create a new API key with "Push rubygem" scope
   
2. Add it to GitHub repository secrets:
   - Go to repository Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `RUBYGEMS_API_KEY`
   - Value: Your RubyGems API key
   - Click "Add secret"

**Note**: The `publish` job only runs on the official repository (`CycloneDX/cyclonedx-ruby-gem`) to prevent accidental publishes from forks.

## Release Artifacts

Each release includes the following artifacts:

1. **Gem Package** (`cyclonedx-ruby-<version>.gem`) - The built Ruby gem
2. **SHA-512 Checksum** (`cyclonedx-ruby-<version>.gem.sha512`) - Checksum for verification

These artifacts are attached to the GitHub Release and can be downloaded for verification.

## Monitoring Releases

- **GitHub Actions**: Check the [Actions tab](https://github.com/CycloneDX/cyclonedx-ruby-gem/actions) for workflow runs
- **GitHub Releases**: View all releases in the [Releases section](https://github.com/CycloneDX/cyclonedx-ruby-gem/releases)
- **RubyGems**: Check [rubygems.org/gems/cyclonedx-ruby](https://rubygems.org/gems/cyclonedx-ruby) for published versions

## Troubleshooting

### Release workflow fails on tests

The workflow will not create a release if tests fail. Fix the failing tests and push a new commit, then create the tag again.

### Gem fails to publish to RubyGems

Check that:
- The `RUBYGEMS_API_KEY` secret is set correctly
- The API key has the "Push rubygem" permission
- The gem version doesn't already exist on RubyGems (versions cannot be overwritten)

### Prerelease not detected correctly

Ensure your tag follows the format `v<VERSION>-<PRERELEASE>` where `<PRERELEASE>` contains a hyphen or dot (e.g., `alpha.1`, `beta-2`, `rc.1`).
