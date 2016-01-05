RSpec.describe "Middleman::DataSource::Extension (feat) collection" do

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

    it "allows passing an extension type" do
      expect( @mm.data.extensionless.all.foo ).to eq "bar"
    end

    it "sets custom index key if given one" do
      expect( @mm.data.custom_index.dem_things.map(&:to_h) ).to match_array [{"dem" => "things"}]
    end

    it "removes index if given index false" do
      expect( @mm.data.no_index.all ).to be_nil
      expect( @mm.data.no_index.data.missing ).to eq "index"
    end

end
