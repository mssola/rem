require 'spec_helper'

describe Authentication do
  it 'validates the presence of provider and uid' do
    expect { Authentication.create!(:provider => 'twitter') }.
      to raise_error(ActiveRecord::RecordInvalid)
    expect { Authentication.create!(:uid => '42') }.
      to raise_error(ActiveRecord::RecordInvalid)
    Authentication.create!(provider: 'twitter', uid: '42')
  end
end
