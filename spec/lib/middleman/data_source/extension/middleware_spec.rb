RSpec.describe "Middleman::DataSource::Extension (feat) middleware" do

    before :each do
      Given.fixture 'middleware'
      @mm = Middleman::Fixture.app
    end

    after :each do
      Given.cleanup!
    end

    it "sets data after being passed through middleware" do
      expect( @mm.data.altered ).to match_array [1, 2, 3, 4]
    end

end
