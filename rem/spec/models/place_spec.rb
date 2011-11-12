
require 'spec_helper'


describe Place do
  let(:place) { Factory(:place, name: nil) }
  let(:mplace) { Factory(:place, address: nil, latitude: nil, longitude: nil) }
  let(:nplace) { Factory(:place, address: 'elmo street') }
  let(:iplace) { Factory(:place, address: nil, latitude: '0.123', longitude: nil) }
  let(:jplace) { Factory(:place, address: nil, latitude: '0.123', longitude: '123.1233') }
  let(:kplace) { Factory(:place, address: 'elmo street', route_id: nil) }


  it 'validates the presence of the place name' do
    expect { place.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'validates that an address was given for this place' do
    expect { mplace.save! }.to raise_error(ActiveRecord::RecordInvalid)
    expect { nplace.save! }.not_to raise_error(ActiveRecord::RecordInvalid)
    expect { iplace.save! }.to raise_error(ActiveRecord::RecordInvalid)
    expect { jplace.save! }.not_to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'validates that a route_id was given for this place' do
    expect { kplace.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
