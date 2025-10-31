# frozen_string_literal: true

# Copied from https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/.simplecov
# Licensed under MIT - https://github.com/cucumber/aruba/blob/3b1a6cea6e3ba55370c3396eef0a955aeb40f287/LICENSE

SimpleCov.configure do
  enable_for_subprocesses true

  # Activate branch coverage
  enable_coverage :branch

  # ignore this file
  add_filter ".simplecov"
  add_filter "features"

  # Rake tasks aren't tested with rspec
  add_filter "Rakefile"
  add_filter "lib/tasks"

  #
  # Changed Files in Git Group
  # @see http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  untracked         = `git ls-files --exclude-standard --others`
  unstaged          = `git diff --name-only`
  staged            = `git diff --name-only --cached`
  all               = untracked + unstaged + staged
  changed_filenames = all.split("\n")

  add_group "Changed" do |source_file|
    changed_filenames.select do |changed_filename|
      source_file.filename.end_with?(changed_filename)
    end
  end

  add_group "Libraries", "lib"

  # Specs are reported on to ensure that all examples are being run and all
  # lets, befores, afters, etc are being used.
  add_group "Specs", "spec/"
end
