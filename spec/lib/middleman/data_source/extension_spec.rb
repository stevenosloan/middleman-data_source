RSpec.describe Middleman::DataSource::Extension do

  it "is registered as an extension" do
    expect( Middleman::Extensions.registered[:data_source] ).to eq Middleman::DataSource::Extension
  end

  shared_examples "data import" do
    it "adds data to application" do
      expect( @mm.data.remote.map(&:to_h) ).to match_array [{"item" => "one"}, {"item" => "two"}]
    end

    it "supports nested routes" do
      expect( @mm.data.deeply.nested.routes.map(&:to_h) ).to match_array [{"item" => "one"}, {"item" => "two"}]
    end

    it "supports query params" do
      expect( @mm.data.query_param.map(&:to_h) ).to match_array [{"foo" => "bar"}]
    end

    it "attempts to not clobber data of overlapping nested routes (if it's hashes)" do
      expect( @mm.data.deeply.nested.to_h.has_key? "nestable" ).to eq true
      expect( @mm.data.deeply.nested["nestable"] ).to eq "data"
    end

    it "support yaml or json" do
      expect( @mm.data.in_yaml ).to match_array ["data","in","yaml"]
      expect( @mm.data.in_json ).to match_array ["data","in","json"]
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

    it "allows assignment of sources w/ given type" do
      expect( @mm.data.foo ).to eq ["one","two","three"]
    end

    it "allows assignment of custom data decoders" do
      expect( @mm.data.my_decoder ).to eq ["grass","is","greener"]
    end

    it "sets custom decoders based on file extensions" do
      expect( @mm.data.run_through_my_decoder ).to eq ["grass","is","greener"]
    end
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
      expect( @mm.data.remote ).to match_array [{"item" => "one"}, {"item" => "two"}]
      expect( @mm.data.in_yaml ).to match_array ["data","in","yaml"]
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
      expect( @mm.data.mapped_in_yaml ).to match_array ["data","in","yaml"]
      expect( @mm.data.mapped_in_json ).to match_array ["data","in","json"]
    end
  end

  it "allows for imediate use in config once defined" do
    Given.fixture 'imediate_use'
    @mm = Middleman::Fixture.app

    remote_data = (@mm.config.setting(:remote_data).value.respond_to?(:value)) ? @mm.config.setting(:remote_data).value.value : @mm.config.setting(:remote_data).value

    expect( remote_data ).to match_array [{"item"=>"one"},{"item"=>"two"}]
  end

  context "with nested alias locations" do
    before :each do
      Given.fixture 'nested_alias'
      @mm = Middleman::Fixture.app
    end

    after :each do
      Given.cleanup!
    end

    it "puts data into the nested data location as though alias was a path" do
      expect( @mm.data.mounted.remote.data ).to eq 'remote'
    end

    it "allows for overlapping paths" do
      expect( @mm.data.mounted.data ).to eq 'remote'
    end

  end


  context "with collection app" do
    before :each do
      Given.fixture 'collection'
      @mm = Middleman::Fixture.app
    end

    after :each do
      Given.cleanup!
    end

    it "makes collection items available at aliases" do
      expect( @mm.data.root.john.title ).to eq "John"
      expect( @mm.data.root.hodor.title ).to eq "Hodor"
    end

    it "makes collection index available at #all" do
      expect( @mm.data.root.all.map(&:to_h) ).to match_array [{ "extra" => "info",
                                                                "slug" => "hodor" },
                                                              { "extra" => "info",
                                                                "slug" => "john" }]
    end
  end

end
