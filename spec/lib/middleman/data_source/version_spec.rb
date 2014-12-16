require 'spec_helper'

describe Middleman::DataSource::VERSION do
  it "has a version" do
    expect( Middleman::DataSource::VERSION >= '0.0.0' ).to eq true
  end
end
