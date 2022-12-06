# frozen_string_literal: true

require 'bundler/setup'
require 'mini_magick'

require_relative 'support/helpers'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = 'documentation'
  config.color = true
  config.fail_fast = true unless ENV['CI']
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  %i[imagemagick graphicsmagick].each do |cli|
    config.before(cli: cli) do |_example|
      allow(MiniMagick).to receive(:cli).and_return(cli)
    end
    config.around(skip_cli: cli) do |example|
      example.run unless example.metadata[:cli] == cli
    end
  end

  %w[open3 posix-spawn].each do |shell_api|
    config.before(shell_api: shell_api) do |_example|
      allow(MiniMagick).to receive(:shell_api).and_return(shell_api)
    end
  end
end

SHELL_APIS = ['open3'].freeze
SHELL_APIS << 'posix-spawn' unless RUBY_PLATFORM == 'java'
