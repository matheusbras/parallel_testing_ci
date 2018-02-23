require 'rails_helper'

RSpec.describe Person, type: :model do
  1000.times do
    it { is_expected.to validate_presence_of(:name) }
  end
end
