require 'rails_helper'

RSpec.describe Shopper, type: :model do

  it { is_expected.to have_many(:orders) }

end
