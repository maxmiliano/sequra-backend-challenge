require 'rails_helper'

RSpec.describe Merchant, type: :model do

  it { is_expected.to have_many(:orders) }

  pending "add some examples to (or delete) #{__FILE__}"
end
