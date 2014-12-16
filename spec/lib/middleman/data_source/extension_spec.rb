require 'spec_helper'

describe Middleman::DataSource::Extension do

  it "is registered as an extension" do
    expect( Middleman::Extensions.registered[:data_source] ).to eq Middleman::DataSource::Extension
  end

end
