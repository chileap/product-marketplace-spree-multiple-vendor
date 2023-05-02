require 'ffaker'
require 'pathname'
require './lib/spree_sample'

namespace :sample do
  desc 'Loads sample data'
  task load: :environment do
    SpreeSample::Engine.load_samples
  end
end
