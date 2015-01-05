require 'spec_helper'

describe Middleman::DataSource::Extension do

  it "is registered as an extension" do
    expect( Middleman::Extensions.registered[:data_source] ).to eq Middleman::DataSource::Extension
  end

  shared_examples "data import" do
    it "adds data to application" do
      expect( @mm.data.remote ).to eq [{"item" => "one"}, {"item" => "two"}]
    end

    it "supports nested routes" do
      expect( @mm.data.deeply.nested.routes ).to eq [{"item" => "one"}, {"item" => "two"}]
    end

    it "attempts to not clobber data of overlapping nested routes (if it's hashes)" do
      expect( @mm.data.deeply.nested.has_key? "nestable" ).to eq true
      expect( @mm.data.deeply.nested["nestable"] ).to eq "data"
    end

    it "support yaml or json" do
      expect( @mm.data.in_yaml ).to eq ["data","in","yaml"]
      expect( @mm.data.in_json ).to eq ["data","in","json"]
    end
  end

  context "with the base fixture app" do
    before :each do
      Given.fixture 'base'
      @mm = Middleman::Fixture.app
      @extension = @mm.extensions[:data_source]
    end

    after :each do
      Given.cleanup!
    end

    it_behaves_like "data import"
  end

  context "with unsupported_extension" do
    before :each do
      Given.fixture 'unsupported_extension'
      @app = Middleman::Fixture.app
    end

    after :each do
      Given.cleanup!
    end

    it "raises UnsupportedDataExtension" do
      expect{ @app.data.unsupported }.to raise_error Middleman::DataSource::Extension::UnsupportedDataExtension
    end
  end

  context "with root set to http source" do
    before :each do
      Given.fixture 'borrower'
      @mm = Middleman::Fixture.app
      @extension = @mm.extensions[:data_source]
    end

    after :each do
      Given.cleanup!
    end

    it_behaves_like "data import"
  end


  context "with multiple instances" do
    before :each do
      Given.fixture 'multiple_instances'
      @mm = Middleman::Fixture.app
      @extension = @mm.extensions[:data_source]
    end

    after :each do
      Given.cleanup!
    end

    it "returns data from both instances" do
      expect( @mm.data.remote ).to eq [{"item" => "one"}, {"item" => "two"}]
      expect( @mm.data.in_yaml ).to eq ["data","in","yaml"]
    end
  end

  context "with files specified as hash" do
    before :each do
      Given.fixture 'files_as_hash'
      @mm = Middleman::Fixture.app
      @extension = @mm.extensions[:data_source]
    end

    after :each do
      Given.cleanup!
    end

    it "maps correctly between route & data name" do
      expect( @mm.data.mapped_nested["nestable"] ).to eq "data"
      expect( @mm.data.mapped_in_yaml ).to eq ["data","in","yaml"]
      expect( @mm.data.mapped_in_json ).to eq ["data","in","json"]
    end
  end

  it "allows for imediate use in config once defined" do
    Given.fixture 'imediate_use'
    @mm = Middleman::Fixture.app

    data = (@mm.respond_to?(:config) && @mm.config.respond_to?(:setting)) ? @mm.config.setting(:remote_data).value : @mm.remote_data
    expect( data ).to match_array [{"item"=>"one"},{"item"=>"two"}]
  end

end
