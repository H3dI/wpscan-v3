require 'spec_helper'

describe WPScan::Finders::DynamicFinder::WpItemVersion::Xpath do
  module WPScan
    module Finders
      module PluginVersion
        # Needed to be able to test the below
        module Rspec
        end
      end
    end
  end

  let(:finder_module) { WPScan::Finders::PluginVersion::Rspec }
  let(:finder_class)  { WPScan::Finders::PluginVersion::Rspec::Xpath }
  let(:finder_config) { { 'xpath' => "//div/h3[@class='version-number']" } }
  let(:default)       { { 'pattern' => /\A(?<v>[\d\.]+)/i, 'confidence' => 40 } }

  before { described_class.create_child_class(finder_module, :Xpath, finder_config) }
  after  { finder_module.send(:remove_const, :Xpath) }

  describe '.create_child_class' do
    context 'when no PATH and CONFIDENCE' do
      it 'contains the expected constants to their default values' do
        # Doesn't work, dunno why
        # expect(finder_module.const_get(:Xpath)).to be_a described_class
        # expect(finder_class.is_a?(described_class)).to eql true
        # expect(finder_class).to be_a described_class

        expect(finder_class::XPATH).to eql finder_config['xpath']

        expect(finder_class::PATTERN).to eql default['pattern']
        expect(finder_class::CONFIDENCE).to eql default['confidence']
        expect(finder_class::PATH).to eql nil
      end
    end

    context 'when CONFIDENCE' do
      let(:finder_config) { super().merge('confidence' => 30) }

      it 'contains the expected constants' do
        expect(finder_class::XPATH).to eql finder_config['xpath']
        expect(finder_class::CONFIDENCE).to eql finder_config['confidence']

        expect(finder_class::PATTERN).to eql default['pattern']
        expect(finder_class::PATH).to eql nil
      end
    end

    context 'when PATH' do
      let(:finder_config) { super().merge('path' => 'file.txt') }

      it 'contains the expected constants' do
        expect(finder_class::XPATH).to eql finder_config['xpath']
        expect(finder_class::PATH).to eql finder_config['path']

        expect(finder_class::PATTERN).to eql default['pattern']
        expect(finder_class::CONFIDENCE).to eql default['confidence']
      end
    end

    context 'when PATTERN' do
      let(:finder_config) { super().merge('pattern' => /Version: (?<v>[\d\.]+)/i) }

      it 'contains the expected constants' do
        expect(finder_class::XPATH).to eql finder_config['xpath']
        expect(finder_class::PATTERN).to eql finder_config['pattern']

        expect(finder_class::PATH).to eql nil
        expect(finder_class::CONFIDENCE).to eql default['confidence']
      end
    end
  end

  describe '#passive, #aggressive' do
    # Handled in spec/lib/finders/dynamic_finder/plugin_version_spec
  end
end
