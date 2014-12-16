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

end
